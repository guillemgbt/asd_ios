//
//  EventRepo.swift
//  ASD
//
//  Created by Guillem Budia Tirado on 17/03/2019.
//  Copyright © 2019 Guillem Budia Tirado. All rights reserved.
//

import RealmSwift
import SwiftyJSON
import RxSwift


class EventRepo: GeneralObjectRepo<Event> {

    static let shared: EventRepo = EventRepo()
    
    
    func getEvents(for area: Area) -> Results<Event> {
        return getEvents(for: area.getPK())
    }
    
    func getEvents(for areaID: String) -> Results<Event> {
        let areaPredicate = NSPredicate(format: "area_id == %@", areaID)
        return getObjectResults(filteredBy: areaPredicate)
    }
    
    func getSortdEvents(for areaID: String) -> Results<Event> {
        let areaPredicate = NSPredicate(format: "area_id == %@", areaID)
        return getSortedObjectResults(filteredBy: areaPredicate)
    }
    
    override func fetch(withKey key: String, toUpdate networkObject: Variable<NetworkObject<Event>?>) {
        
        networkObject.update(withNetworkStatus: .loading)
        
        api.get(requestPath: RequestPath(path: "event/\(key)/"), onSuccess: { (json) in
            
            guard let event = Event(fromJSON: json) else {
                Utils.printDebug(sender: self, message: "Could not parse event JSON")
                networkObject.update(withNetworkStatus: .error)
                return
            }
            
            self.updateStored(object: event)
            
            networkObject.update(withNetworkStatus: .success, withObjectId: key)
            
        }) { (description, _) in
            Utils.printDebug(sender: self, message: "error geting event \(key)")
            networkObject.update(withNetworkStatus: .error)
        }
        
    }
    
    override func fetchList(withKey key: String, toUpdate networkState: Variable<NetworkRequestState>) {
        
        networkState.value = .loading
        
        api.get(requestPath: RequestPath(path: "events/areas/\(key)/"), onSuccess: { (json) in
            
            var events = [Event]()
            
            print(json)
            
            for areaJSON in json.arrayValue {
                if let event = Event(fromJSON: areaJSON) {
                    events.append(event)
                }
            }
            
            self.replaceAreaEvents(events, areaID: key)
            
            networkState.value = .success
            
        }) { (description, _) in
            Utils.printDebug(sender: self, message: "error geting area \(key)")
            networkState.value = .error
        }
    }
    
    private func replaceAreaEvents(_ events: [Event], areaID: String) {
        
        let areaPredicate = NSPredicate(format: "area_id == %@", areaID)
        replaceStored(objects: events, categoryPredicate: areaPredicate)
    }

}
