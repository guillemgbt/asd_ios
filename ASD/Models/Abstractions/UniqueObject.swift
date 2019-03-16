//
//  UniqueObject.swift
//  MonkingMe
//
//  Created by Guillem Budia Tirado on 08/06/2018.
//  Copyright © 2018 Guillem Budia Tirado. All rights reserved.
//


import RealmSwift

class UniqueObject: BaseObject {
    
    class func createDefault(in realm: Realm) -> Self {
        
        let model = self.init()
        
        try? realm.write {
            realm.add(model)
        }
        return model
    }
    
    class func existsDefault() -> Bool {
        let realm = try! Realm()
        return realm.objects(self).first != nil
    }
    
    
    @discardableResult
    class func getDefault() -> Self {
        let realm = try! Realm()
        return realm.objects(self).first ?? createDefault(in: realm)
    }
    
    @discardableResult
    class func deleteDefault() -> Bool {
        
        if !existsDefault() { return false }
        
        let realm = try! Realm()
        
        var isDeleted = false
        
        try? realm.write {
            let model = getDefault()
            realm.delete(model)
            isDeleted = true
        }
        
        return isDeleted
    }

    
}
