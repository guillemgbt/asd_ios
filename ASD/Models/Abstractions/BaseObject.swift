//
//  BaseObject.swift
//  MonkingMe
//
//  Created by Guillem Budia Tirado on 08/06/2018.
//  Copyright © 2018 Guillem Budia Tirado. All rights reserved.
//

import RealmSwift

class BaseObject: Object {
    
    @objc internal dynamic var pk: String = ""
    @objc internal dynamic var updatedAt: Date = Date()
    
    convenience init(pk: String){
        self.init()
        self.pk = pk
        updateLastUpdate(updatedAt: updatedAt)
    }
    
    func getPK() -> String {
        return pk
    }
    
    func lastUpdate() -> Date {
        return updatedAt
    }
    
    func updateLastUpdate(updatedAt: Date = Date()) {
        self.updatedAt = updatedAt
    }
    
    override static func primaryKey() -> String? {
        return "pk"
    }
}
