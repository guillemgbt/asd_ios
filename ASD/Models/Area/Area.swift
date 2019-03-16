//
//  Area.swift
//  ASD
//
//  Created by Guillem Budia Tirado on 14/03/2019.
//  Copyright © 2019 Guillem Budia Tirado. All rights reserved.
//

import Foundation
import SwiftyJSON

class Area: GeneralObject {
    
    @objc dynamic var title: String = ""
    @objc dynamic var center_latitude: Double = 0
    @objc dynamic var center_longitude: Double = 0
    @objc dynamic var radius: Double = 0
    @objc dynamic var created: Double = 0
    
    convenience init?(fromJSON json: JSON) {
        
        guard let id = json["id"].int else {
            return nil
        }
        
        self.init(id: "\(id)",
                  title: json["title"].stringValue.html2String,
                  center_latitude: json["center_latitude"].doubleValue,
                  center_longitude: json["center_longitude"].doubleValue,
                  radius: json["radius"].doubleValue,
                  created: json["created"].doubleValue)
    }
    
    convenience init(id: String, title: String, center_latitude: Double, center_longitude: Double, radius: Double, created: Double) {
        
        self.init(pk: id)
        self.title = title
        self.center_latitude = center_latitude
        self.center_longitude = center_longitude
        self.radius = radius
        self.created = created
    }
    
    @objc func getTitle() -> String {
        return title
    }
    
    func getLoactionDescription() -> String {
        return "\(getCenterLatitude()), \(getCenterLongitude())"
    }
    
    func getCenterLatitude() -> Double {
        return center_latitude
    }
    
    func getCenterLongitude() -> Double {
        return center_longitude
    }

}
