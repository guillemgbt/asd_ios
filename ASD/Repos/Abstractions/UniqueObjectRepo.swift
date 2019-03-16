//
//  UniqueObjectRepo.swift
//  MonkingMe
//
//  Created by Guillem Budia Tirado on 14/06/2018.
//  Copyright © 2018 Guillem Budia Tirado. All rights reserved.
//

import RealmSwift

class UniqueObjectRepo<T: UniqueObject>: BaseRepo {

    func update(updateBlock: @escaping (_ model: T)->()) {
        
        let model = T.getDefault()
        
        try! Realm().write {
            updateBlock(model)
        }
    }
    
    func deleteStored() {
        let realm = try! Realm()
        let allObjects = realm.objects(T.self)
        try! realm.write {
            realm.delete(allObjects)
        }
    }
}
