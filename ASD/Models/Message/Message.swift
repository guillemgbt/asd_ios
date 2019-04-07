//
//  Message.swift
//  ASD
//
//  Created by Guillem Budia Tirado on 06/04/2019.
//  Copyright © 2019 Guillem Budia Tirado. All rights reserved.
//

import Foundation

class Message: NSObject {
    
    let title: String
    let body: String
    
    init(title: String, body: String) {
        self.title = title
        self.body = body
    }

}
