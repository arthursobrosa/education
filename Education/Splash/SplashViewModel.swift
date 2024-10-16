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
    private var syncMonitor: SyncMonitor?
    
    // MARK: - Combine storage
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var syncStartDate = Date()
    
    var extraAnimationTime = TimeInterval()
    
    var isAvailable: Box<Bool> = Box(false)
    var unavailableStatus: Box<SyncMonitor.SyncSummaryStatus?> = Box(nil)
    private var syncCount: Int = 0 {
        didSet {
            guard syncCount == 3 else { return }
            
            setExtraAnimationTime()
            isAvailable.value = true
        }
    }
    
    // MARK: - Initializer
    init() {
        setSyncMonitor()
    }
    
    // MARK: - Methods
    private func bindNetworkAvailable() {
        syncMonitor?.$networkAvailable
            .sink { [weak self] networkAvailable in
                guard let self else { return }
                
                if let networkAvailable {
                    if networkAvailable {
                        self.bindiCloudAccountStatus()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindiCloudAccountStatus() {
        syncMonitor?.$iCloudAccountStatus
            .sink { [weak self] iCloudAccountStatus in
                guard let self else { return }
                
                if case .available = iCloudAccountStatus {
                    self.bindSyncStates()
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindSyncStates() {
        syncMonitor?.$setupState
            .sink { [weak self] setupState in
                guard let self else { return }
                
                self.syncCount += 1
            }
            .store(in: &cancellables)
        
        syncMonitor?.$importState
            .sink { [weak self] importState in
                guard let self else { return }
                
                self.syncCount += 1
            }
            .store(in: &cancellables)
        
        syncMonitor?.$exportState
            .sink { [weak self] exportState in
                guard let self else { return }
                
                self.syncCount += 1
            }
            .store(in: &cancellables)
    }
    
    private func setExtraAnimationTime() {
        let syncDuration = Date().timeIntervalSince(syncStartDate)
        
        if syncDuration < 2.0 {
            extraAnimationTime = 2.0 - syncDuration
        }
    }
    
    private func waitAndCheckSyncStatus() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self,
                  !self.isAvailable.value else { return }
            
            if let networkAvailable = self.syncMonitor?.networkAvailable {
                if !networkAvailable {
                    self.unavailableStatus.value = .noNetwork
                    return
                }
            }
             
            guard case .available = self.syncMonitor?.iCloudAccountStatus else {
                self.unavailableStatus.value = .accountNotAvailable
                return
            }
        }
    }
    
    func setSyncMonitor() {
        syncMonitor = nil
        syncMonitor = SyncMonitor()
        syncStartDate = Date.now
        isAvailable.value = false
        unavailableStatus.value = nil
        bindNetworkAvailable()
        waitAndCheckSyncStatus()
    }
}
