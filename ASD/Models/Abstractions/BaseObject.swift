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
    @objc dynamic var created: Date = Date()
    
    convenience init(pk: String, created: Date){
        self.init()
        self.pk = pk
        self.created = created
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
