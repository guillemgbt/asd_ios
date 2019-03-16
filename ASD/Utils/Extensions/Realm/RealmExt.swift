//
//  RealmExt.swift
//  MonkingMe
//
//  Created by Guillem Budia Tirado on 21/06/2018.
//  Copyright © 2018 Guillem Budia Tirado. All rights reserved.
//

import RealmSwift

extension Realm {
    
    class func writeBlock(_ writeBlock: @escaping ()->()) {
        let realm = try! Realm()
        
        try! realm.write {
            writeBlock()
        }
    }
}
