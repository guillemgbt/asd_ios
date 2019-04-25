//
//  FlightControl.swift
//  ASD
//
//  Created by Guillem Budia Tirado on 24/04/2019.
//  Copyright © 2019 Guillem Budia Tirado. All rights reserved.
//

import SwiftyJSON
import RealmSwift

enum FlightState: String {
    case landed = "LANDED"
    case starting = "STARTING"
    case scanning = "SCANNING"
    case stopping = "STOPPING"
    case error = "ERROR"
    case initial = "INITIAL"
}

class FlightControl: UniqueObject {
    
    @objc dynamic var state: String = FlightState.initial.rawValue
    @objc dynamic var area_id: Int = -1
    
    @discardableResult
    func update(from json: JSON) -> Bool {
        
        guard let state = FlightState(rawValue: json["state"].stringValue), let area_id = json["area_id"].int else {
            return false
        }
        
        update(state: state.rawValue,
               area_id: area_id,
               created: json["created"].stringValue.toDate() ?? Date())
        
        return true
    }
    
    func update(state: String, area_id: Int, created: Date) {
        self.created = created
        self.state = state
        self.area_id = area_id
    }
    
    func getState() -> FlightState {
        return FlightState(rawValue: state) ?? FlightState.error
    }
    
    func getAreaID() -> Int {
        return area_id
    }

}
