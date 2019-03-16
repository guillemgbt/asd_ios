//
//  SyncInterface.swift
//  MonkingMe
//
//  Created by Guillem Budia Tirado on 11/06/2018.
//  Copyright © 2018 Guillem Budia Tirado. All rights reserved.
//

import Foundation
import RealmSwift


protocol SyncInterface {
    
    associatedtype T
    
    func localUpdate(model: T, multiplier: Int)
    
    func serverUpdate(model: T)
    
    func undoLocalUpdate(model: T)
    
    
}
