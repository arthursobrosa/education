//
//  SyncMonitor.swift
//  Education
//
//  Created by Arthur Sobrosa on 15/10/24.
//

import Combine
import CoreData
import Network
import SwiftUI
import CloudKit

public class SyncMonitor: ObservableObject {
    // MARK: - Summary properties
    /// Possible values for the summary of the state of iCloud sync
    public enum SyncSummaryStatus {
        case noNetwork, accountNotAvailable
        
        // A string you could use to display the status
        public var title: String {
            switch self {
                case .noNetwork:
                    String(localized: "noNetworkTitle")
                case .accountNotAvailable:
                    String(localized: "accountNotAvailableTitle")
            }
        }
        
        public var message: String {
            switch self {
                case .noNetwork:
                    String(localized: "noNetworkMessage")
                case .accountNotAvailable:
                    String(localized: "accountNotAvailableMessage")
            }
        }
    }

    public var syncError: Bool {
        return setupError != nil || importError != nil || exportError != nil
    }

    public var shouldBeSyncing: Bool {
        if case .available = iCloudAccountStatus, self.networkAvailable == true, !syncError,
           case .succeeded = setupState {
            return true
        }
        return false
    }

    public var notSyncing: Bool {
        if case .notStarted = importState, shouldBeSyncing {
            return true
        }
        return false
    }

    public var setupError: Error? {
        if networkAvailable == true, let error = setupState.error {
            return error
        }
        return nil
    }

    public var importError: Error? {
        if networkAvailable == true, let error = importState.error {
            return error
        }
        return nil
    }

    public var exportError: Error? {
        if networkAvailable == true, let error = exportState.error {
            return error
        }
        return nil
    }

    // MARK: - Specific Status Properties
    /// The state of `NSPersistentCloudKitContainer`'s "setup" event
    @Published public private(set) var setupState: SyncState = .notStarted

    /// The state of `NSPersistentCloudKitContainer`'s "import" event
    @Published public private(set) var importState: SyncState = .notStarted

    /// The state of `NSPersistentCloudKitContainer`'s "export" event
    @Published public private(set) var exportState: SyncState = .notStarted

    /// Is the network available?
    ///
    /// This is true if the network is available in any capacity (Wi-Fi, Ethernet, cellular, carrier pidgeon, etc) - we just care if we can reach iCloud.
    @Published public private(set) var networkAvailable: Bool? = nil

    @Published public private(set) var loggedIntoIcloud: Bool? = nil

    /// The current status of the user's iCloud account - updated automatically if they change it
    @Published public private(set) var iCloudAccountStatus: CKAccountStatus?

    /// If an error was encountered when retrieving the user's account status, this will be non-nil
    public private(set) var iCloudAccountStatusUpdateError: Error?

    // MARK: - Diagnosis properties
    /// Contains the last Error encountered.
    ///
    /// This can be helpful in diagnosing "notSyncing" issues or other "partial error"s from which CloudKit thinks it recovered, but didn't really.
    public private(set) var lastError: Error?

    // MARK: - Listeners -

    /// Where we store Combine cancellables for publishers we're listening to, e.g. NSPersistentCloudKitContainer's notifications.
    private var disposables = Set<AnyCancellable>()

    /// Network path monitor that's used to track whether we can reach the network at all
    //    fileprivate let monitor: NetworkMonitor = NWPathMonitor()
    private let monitor = NWPathMonitor()

    /// The queue on which we'll run our network monitor
    private let monitorQueue = DispatchQueue(label: "NetworkMonitor")

    // MARK: - Initializers
    /// Creates a new sync monitor and sets up listeners to sync and network changes
    public init(setupState: SyncState = .notStarted, importState: SyncState = .notStarted,
                exportState: SyncState = .notStarted, networkAvailable: Bool? = nil,
                iCloudAccountStatus: CKAccountStatus? = nil,
                lastErrorText: String? = nil,
                listen: Bool = true) {
        self.setupState = setupState
        self.importState = importState
        self.exportState = exportState
        self.networkAvailable = networkAvailable
        self.iCloudAccountStatus = iCloudAccountStatus
        if let e = lastErrorText {
            self.lastError = NSError(domain: e, code: 0, userInfo: nil)
        }

        guard listen else { return }

        NotificationCenter.default.publisher(for: NSPersistentCloudKitContainer.eventChangedNotification)
            .sink(receiveValue: { notification in
                if let cloudEvent = notification.userInfo?[NSPersistentCloudKitContainer.eventNotificationUserInfoKey]
                    as? NSPersistentCloudKitContainer.Event {
                    let event = SyncEvent(from: cloudEvent) // To make testing possible
                    // Properties need to be set on the main thread for SwiftUI, so we'll do that here
                    // instead of maing setProperties run async code, which is inconvenient for testing.
                    DispatchQueue.main.async { self.setProperties(from: event) }
                }
            })
            .store(in: &disposables)
        

        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.networkAvailable = (path.status == .satisfied)
            }
        }
        monitor.start(queue: monitorQueue)

        // Monitor changes to the iCloud account (e.g. login/logout)
        self.updateiCloudAccountStatus()
        NotificationCenter.default.publisher(for: .CKAccountChanged)
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink(receiveValue: { notification in
                self.updateiCloudAccountStatus()
            })
            .store(in: &disposables)
    }

    /// Convenience initializer that creates a SyncMonitor with preset state values for testing or previews
    ///
    ///     let syncMonitor = SyncMonitor(importSuccessful: false, errorText: "Cloud distrupted by weather net")
    public init(setupSuccessful: Bool = true, importSuccessful: Bool = true, exportSuccessful: Bool = true,
                networkAvailable: Bool = true, iCloudAccountStatus: CKAccountStatus = .available, errorText: String?) {
        var error: Error? = nil
        if let errorText = errorText {
            error = NSError(domain: errorText, code: 0, userInfo: nil)
        }
        let startDate = Date(timeIntervalSinceNow: -15) // a 15 second sync. :o
        let endDate = Date()
        self.setupState = setupSuccessful
            ? SyncState.succeeded(started: startDate, ended: endDate)
            : .failed(started: startDate, ended: endDate, error: error)
        self.importState = importSuccessful
            ? .succeeded(started: startDate, ended: endDate)
            : .failed(started: startDate, ended: endDate, error: error)
        self.exportState = exportSuccessful
            ? .succeeded(started: startDate, ended: endDate)
            : .failed(started: startDate, ended: endDate, error: error)
        self.networkAvailable = networkAvailable
        self.iCloudAccountStatus = iCloudAccountStatus
    }

    /// Checks the current status of the user's iCloud account and updates our iCloudAccountStatus property
    ///
    /// When SyncMonitor is listening to notifications (which it does unless you tell it not to when initializing), this method is called each time CKContainer
    /// fires off a `.CKAccountChanged` notification.
    private func updateiCloudAccountStatus() {
        #if DEBUG
        let isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        if isPreview {
            return
        }
        #endif
            
        CKContainer.default().accountStatus { (accountStatus, error) in
            DispatchQueue.main.async {
                if let e = error {
                    self.iCloudAccountStatusUpdateError = e
                } else {
                    self.iCloudAccountStatus = accountStatus
                }
            }
        }
    }

    // MARK: - Processing NSPersistentCloudKitContainer events
    /// Set the appropriate State property (importState, exportState, setupState) based on the provided event
    internal func setProperties(from event: SyncEvent) {
        // First, set the SyncState for the event
        var state: SyncState = .notStarted
        // NSPersistentCloudKitContainer sends a notification when an event starts, and another when it
        // ends. If it has an endDate, it means the event finished.
        if let startDate = event.startDate, event.endDate == nil {
            state = .inProgress(started: startDate)
        } else if let startDate = event.startDate, let endDate = event.endDate {
            if event.succeeded {
                state = .succeeded(started: startDate, ended: endDate)
            } else {
                state = .failed(started: startDate, ended: endDate, error: event.error)
            }
        }

        switch event.type {
        case .setup:
            setupState = state
        case .import:
            importState = state
        case .export:
            exportState = state
        @unknown default:
            assertionFailure("NSPersistentCloudKitContainer added a new event type.")
        }

        if event.error != nil {
            lastError = event.error
        }
    }

    /// A sync event containing the values from NSPersistentCloudKitContainer.Event that we track
    internal struct SyncEvent {
        var type: NSPersistentCloudKitContainer.EventType
        var startDate: Date?
        var endDate: Date?
        var succeeded: Bool
        var error: Error?

        /// Creates a SyncEvent from explicitly provided values (for testing)
        init(type: NSPersistentCloudKitContainer.EventType, startDate: Date?, endDate: Date?, succeeded: Bool,
             error: Error?) {
            self.type = type
            self.startDate = startDate
            self.endDate = endDate
            self.succeeded = succeeded
            self.error = error
        }

        /// Creates a SyncEvent from an NSPersistentCloudKitContainer Event
        init(from cloudKitEvent: NSPersistentCloudKitContainer.Event) {
            self.type = cloudKitEvent.type
            self.startDate = cloudKitEvent.startDate
            self.endDate = cloudKitEvent.endDate
            self.succeeded = cloudKitEvent.succeeded
            self.error = cloudKitEvent.error
        }
    }

    // MARK: - Defining state
    /// The state of a CloudKit import, export, or setup event as reported by an `NSPersistentCloudKitContainer` notification
    public enum SyncState {
        /// No event has been reported
        case notStarted

        /// A notification with a start date was received, but it had no end date.
        case inProgress(started: Date)

        /// The last sync of this type finished and succeeded (`succeeded` was `true` in the notification from `NSPersistentCloudKitContainer`).
        case succeeded(started: Date, ended: Date)

        /// The last sync of this type finished but failed (`succeeded` was `false` in the notification from `NSPersistentCloudKitContainer`).
        case failed(started: Date, ended: Date, error: Error?)

        /// Convenience property that returns true if the last sync of this type succeeded
        ///
        /// `succeeded` is true if the sync finished and reported true for its "succeeded" property.
        /// Otherwise (e.g.
        var succeeded: Bool {
            if case .succeeded = self { return true }
            return false
        }

        /// Convenience property that returns true if the last sync of this type failed
        var failed: Bool {
            if case .failed = self { return true }
            return false
        }

        /// Convenience property that returns the error returned if the event failed
        ///
        /// This is the main property you'll want to use to detect an error, as it will be `nil` if the sync is incomplete or succeeded, and will contain
        /// an `Error` if the sync finished and failed.
        ///
        ///     if let error = SyncMonitor.shared.exportState.error {
        ///         print("Sync failed: \(error.localizedDescription)")
        ///     }
        ///
        /// Note that this property will report all errors, including those caused by normal things like being offline.
        /// See also `SyncMonitor.importError` and `SyncMonitor.exportError` for more intelligent error reporting.
        var error: Error? {
            if case let .failed(_,_,error) = self, let e = error {
                return e
            }
            return nil
        }
    }
}
