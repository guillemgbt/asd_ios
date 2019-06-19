//
//  FlightControlRepo.swift
//  ASD
//
//  Created by Guillem Budia Tirado on 24/04/2019.
//  Copyright © 2019 Guillem Budia Tirado. All rights reserved.
//

import RealmSwift
import RxSwift

class FlightControlRepo: UniqueObjectRepo<FlightControl> {
    
    static let shared: FlightControlRepo = FlightControlRepo()
    
    func getFlightControl() -> FlightControl {
        return FlightControl.getDefault()
    }
    
    func resetFlightControl() {
        deleteStored()
        _ = getFlightControl()
    }
    
    func fetch(networkState: Variable<NetworkRequestState>? = nil) {
        
        networkState?.value = .loading
        
        api.get(requestPath: RequestPath(path: "flight/"), onSuccess: { (json) in
            
            print(json)
            
            self.update(updateBlock: { (flightControl) in
                flightControl.update(from: json)
            })
            
            networkState?.value = .success
            
            Utils.printDebug(sender: self, message: "Fetch success")
            
        }) { (description, dict) in
            
            networkState?.value = .error
            
            Utils.printError(sender: self, message: "Could not fetch: \(description)")
            
        }
        
    }
    
    func requestStart(for areaID: String, networkState: Variable<NetworkRequestState>? = nil) {
        
        networkState?.value = .loading
        
        api.get(requestPath: RequestPath(path: "area/\(areaID)/start/"), onSuccess: { (json) in
            
            print(json)
            
            self.update(updateBlock: { (flightControl) in
                flightControl.update(from: json)
            })
            
            networkState?.value = .success
            
            Utils.printDebug(sender: self, message: "Start success")
            
        }) { (description, dict) in
            
            networkState?.value = .error
            
            Utils.printError(sender: self, message: "Start error: \(description)")
            
        }
        
    }
    
    func requestStop(networkState: Variable<NetworkRequestState>? = nil) {
        
        networkState?.value = .loading
        
        api.get(requestPath: RequestPath(path: "area/stop/"), onSuccess: { (json) in
            
            print(json)
            
            self.update(updateBlock: { (flightControl) in
                flightControl.update(from: json)
            })
            
            networkState?.value = .success
            
            Utils.printDebug(sender: self, message: "Stop success")
            
        }) { (description, dict) in
            
            networkState?.value = .error
            
            Utils.printError(sender: self, message: "Stop error: \(description)")
            
        }
    }
    
    
    


}
