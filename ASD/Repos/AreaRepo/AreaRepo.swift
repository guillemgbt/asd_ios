//
//  AreaRepo.swift
//  ASD
//
//  Created by Guillem Budia Tirado on 15/03/2019.
//  Copyright © 2019 Guillem Budia Tirado. All rights reserved.
//

import RealmSwift
import SwiftyJSON
import RxSwift
import CoreLocation

class AreaRepo: GeneralObjectRepo<Area> {
    
    static let shared: AreaRepo = AreaRepo()
    
    override func fetch(withKey key: String, toUpdate networkObject: Variable<NetworkObject<Area>?>) {
        
        networkObject.update(withNetworkStatus: .loading)
        
        api.get(requestPath: RequestPath(path: "area/\(key)/"), onSuccess: { (json) in
            
            guard let area = Area(fromJSON: json) else {
                Utils.printDebug(sender: self, message: "Could not parse area JSON")
                networkObject.update(withNetworkStatus: .error)
                return
            }
            
            self.updateStored(object: area)
            
            networkObject.update(withNetworkStatus: .success, withObjectId: key)
            
        }) { (description, _) in
            Utils.printDebug(sender: self, message: "error geting area \(key)")
            networkObject.update(withNetworkStatus: .error)
        }
        
    }
    
    override func fetchList(withKey key: String, toUpdate networkState: Variable<NetworkRequestState>) {
        
        networkState.value = .loading
        
        api.get(requestPath: RequestPath(path: "areas/"), onSuccess: { (json) in
                        
            var areas = [Area]()
            
            for areaJSON in json.arrayValue {
                if let area = Area(fromJSON: areaJSON) {
                    areas.append(area)
                }
            }
            
            self.replaceStored(objects: areas)
            
            networkState.value = .success

        }) { (description, _) in
            Utils.printDebug(sender: self, message: "error geting area \(key)")
            networkState.value = .error
        }
        
        
    }
    
    func registerArea(name: String, center: CLLocationCoordinate2D, state: Variable<NetworkRequestState>) {

        let data = ["title" : name,
                    "center_latitude" : "\(center.latitude)",
                    "center_longitude" : "\(center.longitude)",
                    "radius" : 10] as [String : Any]

        state.value = .loading
        
        api.post(requestPath: RequestPath(path: "areas/"), dataDict: data, onSucces: { (json, _) in
            
            if let area = Area(fromJSON: json) {
                self.updateStored(object: area)
            }
            
            state.value = .success
            
        }) { (description, dict) in
            
            state.value = .error
        }
        
    }

}
