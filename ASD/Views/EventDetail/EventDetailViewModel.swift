//
//  EventDetailViewModel.swift
//  ASD
//
//  Created by Guillem Budia Tirado on 17/07/2019.
//  Copyright © 2019 Guillem Budia Tirado. All rights reserved.
//

import RxSwift

class EventDetailViewModel: NSObject {
    
    let eventDescription: Variable<String> = Variable("")
    let eventImageURL: Variable<URL?> = Variable(nil)
    
    private let eventID: String
    private let eventRepo: EventRepo
    private let eventNetworkObject: Variable<NetworkObject<Event>?> = Variable(nil)
    
    let disposeBag = DisposeBag()
    
    init(eventID: String, eventRepo: EventRepo = EventRepo.shared) {
        self.eventID = eventID
        self.eventRepo = eventRepo
        super.init()
        
        bindEvent()
        fetchEvent()
    }
    
    private func bindEvent() {
        
        eventNetworkObject.observe(onObjectUpdate: { [weak self] (event) in
            
            self?.eventDescription.value = "\(event.count) matches of \(event.entity) found at \(event.created.formatToHHdMMMYYYYSS())"
            self?.eventImageURL.value = event.getImageURL()
            
        }, onNetworkStatusUpdate: { (networkState) in
            
        }, withDisposeBag: disposeBag)
        
    }
    
    private func fetchEvent() {
        eventRepo.fetch(withKey: eventID, toUpdate: eventNetworkObject)
    }


}
