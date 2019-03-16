//
//  GeneralObject.swift
//  MonkingMe
//
//  Created by Guillem Budia Tirado on 09/06/2018.
//  Copyright © 2018 Guillem Budia Tirado. All rights reserved.
//

import SwiftyJSON


class GeneralObject: BaseObject {
    
    class func canBeParsed(fromJSON json: JSON) -> Bool{
        return false
    }
    
    convenience init?(fromJSON json: JSON) {
        self.init()
    }
    
}
