//
//  BaseRepo.swift
//  MonkingMe
//
//  Created by Guillem Budia Tirado on 14/06/2018.
//  Copyright © 2018 Guillem Budia Tirado. All rights reserved.
//

import UIKit

class BaseRepo: NSObject {
    
    let api: API //API Dependenci Injection
    let utils: Utils //API Dependenci Injection
    
    init(withAPI api: API = API.shared, withUtils utils: Utils = Utils.shared) {
        self.api = api
        self.utils = utils
    }
}
