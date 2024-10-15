//
//  SplashViewModel.swift
//  Education
//
//  Created by Arthur Sobrosa on 15/10/24.
//

import Foundation
import Combine

class SplashViewModel {
    // MARK: - CoreData/CloudKit sync monitor
    private var syncMonitor: SyncMonitor
    
    // MARK: - Combine storage
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var syncStartDate = Date()
    
    var extraAnimationTime = TimeInterval()
    
    var syncSummaryStatus: Box<SyncMonitor.SyncSummaryStatus?> = Box(nil)
    private var syncCount: Int = 0 {
        didSet {
            guard syncCount == 3 else { return }
            
            setExtraAnimationTime()
            syncSummaryStatus.value = .succeeded
        }
    }
    
    // MARK: - Initializer
    init(syncMonitor: SyncMonitor = SyncMonitor.shared) {
        self.syncMonitor = syncMonitor
        
        bindNetworkAvailable()
    }
    
    // MARK: - Methods
    private func bindNetworkAvailable() {
        syncMonitor.$networkAvailable
            .sink { [weak self] networkAvailable in
                guard let self else { return }
                
                if let networkAvailable {
                    if networkAvailable == false {
                        self.syncSummaryStatus.value = .noNetwork
                    } else {
                        self.bindiCloudAccountStatus()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindiCloudAccountStatus() {
        syncMonitor.$iCloudAccountStatus
            .sink { [weak self] iCloudAccountStatus in
                guard let self else { return }
                
                if case .available = iCloudAccountStatus {
                    self.bindSyncStates()
                } else {
                    self.syncSummaryStatus.value = .accountNotAvailable
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindSyncStates() {
        syncMonitor.$setupState
            .sink { [weak self] setupState in
                guard let self else { return }
                
                self.syncCount += 1
            }
            .store(in: &cancellables)
        
        syncMonitor.$importState
            .sink { [weak self] importState in
                guard let self else { return }
                
                self.syncCount += 1
            }
            .store(in: &cancellables)
        
        syncMonitor.$exportState
            .sink { [weak self] exportState in
                guard let self else { return }
                
                self.syncCount += 1
            }
            .store(in: &cancellables)
    }
    
    private func setExtraAnimationTime() {
        let syncDuration = Date().timeIntervalSince(syncStartDate)
        
        if syncDuration < 2.0 {
            self.extraAnimationTime = 2.0 - syncDuration
        }
    }
}
