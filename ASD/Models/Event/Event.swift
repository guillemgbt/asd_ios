//
//  Event.swift
//  ASD
//
//  Created by Guillem Budia Tirado on 15/03/2019.
//  Copyright © 2019 Guillem Budia Tirado. All rights reserved.
//

import Foundation
import SwiftyJSON

class Event: GeneralObject {
    
    @objc dynamic var entity: String = ""
    @objc dynamic var count: Int = 0
    @objc dynamic var image: String = ""
    @objc dynamic var area_id: String = ""    
    
    convenience init?(fromJSON json: JSON) {
        
        guard let id = json["id"].int else {
            return nil
        }
        
        self.init(id: "\(id)",
                  entity: json["entity"].stringValue.html2String,
                  count: json["count"].intValue,
                  image: json["image"].stringValue,
                  area_id: json["area_id"].stringValue,
                  created: json["created"].stringValue.toDate() ?? Date())
    }
    
    convenience init(id: String, entity: String, count: Int, image: String, area_id: String, created: Date) {
        
        self.init(pk: id, created: created)
        self.entity = entity
        self.count = count
        self.image = image
        self.area_id = area_id
    }
    
    @objc func getEntity() -> String {
        return entity
    }
    
    @objc func getCount() -> Int {
        return count
    }
    
    func getEntityDescription() -> String {
        return "\(getCount()) matches of \(getEntity())"
    }
    
    func getImageURL() -> URL? {
        return URL(string: API.shared.completeImageURL(image))
    }
    
}
