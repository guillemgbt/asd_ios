//
//  EventListViewModel.swift
//  ASD
//
//  Created by Guillem Budia Tirado on 17/03/2019.
//  Copyright © 2019 Guillem Budia Tirado. All rights reserved.
//

import RxSwift
import Foundation
import RealmSwift

class EventListViewModel: NSObject {

    let eventRepo: EventRepo
    
    let title: Variable<String> = Variable("Events")
    let isLoading: Variable<Bool> = Variable(false)
    let isScanning: Variable<Bool> = Variable(false)
    let requestState: Variable<NetworkRequestState> = Variable(.initial)
    let areaID: String
    var areaNetworkObject: Variable<NetworkObject<Area>?> = Variable(nil)
    let events: Results<Event>
    
    let bag = DisposeBag()
    private var timer = Timer()
    
    init(areaID: String, eventRepo: EventRepo = EventRepo.shared) {
        self.areaID = areaID
        self.eventRepo = eventRepo
        self.events = eventRepo.getSortdEvents(for: areaID)
        super.init()
        
        bindAreaNetworkObject()
        bindRequestState()
    }
    
    func fetchEvents() {
        eventRepo.fetchList(withKey: areaID, toUpdate: requestState)
    }
    
    func bindAreaNetworkObject() {
        
        areaNetworkObject.observe(onObjectUpdate: { [weak self] (area) in
            
            self?.title.value = "Events in \(area.getTitle())"
            
        }, onNetworkStatusUpdate: { (areaRequestState) in
            
        }, withDisposeBag: bag)
        
    }
    
    func bindRequestState() {
        
        requestState.bind({ [weak self] (state) in
            
            self?.isLoading.value = (state == .loading)
            
        }, disposedBy: bag)
    }
    
    func handleScanAction() {
        isScanning.value = !isScanning.value
        
        isScanning.value ? startTimer() : stopTimer()
    }
    
    private func startTimer() {
        
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { [weak self] (_) in
            self?.fetchEvents()
        })
        
    }
    
    private func stopTimer() {
        timer.invalidate()
    }
}
