//
//  JSON+Ext.swift
//  MonkingMe
//
//  Created by Guillem Budia Tirado on 06/03/2019.
//  Copyright © 2019 Guillem Budia Tirado. All rights reserved.
//

import Foundation
import SwiftyJSON

extension JSON {
    
    init?(uncheckedData: Data) {
        do {
            self = try JSON(data: uncheckedData)
        } catch let catchedError as NSError {
            Utils.printDebug(tag: "JSON", message: catchedError.localizedDescription)
            return nil
        }
    }
    
}
