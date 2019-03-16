//
//  RequestPath.swift
//  MonkingMe
//
//  Created by Adrià Sarquella on 12/02/2019.
//  Copyright © 2019 Guillem Budia Tirado. All rights reserved.
//

class RequestPath {
    
    static let KEY = "<key>"
    
    let path: String
    let rawPath: String
    
    init(path: String, keys: [String]) {
        self.rawPath = path
        
        var finalPath = path
        keys.forEach({key in
            if let range = finalPath.range(of: RequestPath.KEY) {
                finalPath = finalPath.replacingCharacters(in: range, with: key)
            }
        })
        self.path = finalPath
    }
    
    convenience init(path: String, key: String) {
        self.init(path: path, keys: [key])
    }
    
    convenience init(path: String) {
        self.init(path: path, keys: [])
    }
    
}
