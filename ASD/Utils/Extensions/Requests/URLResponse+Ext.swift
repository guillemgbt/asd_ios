//
//  URLResponse+Ext.swift
//  MonkingMe
//
//  Created by Guillem Budia Tirado on 28/02/2019.
//  Copyright © 2019 Guillem Budia Tirado. All rights reserved.
//

import Foundation

extension URLResponse {
    
    func statusCode() -> Int? {
        
        guard let httpResponse = self as? HTTPURLResponse else {
            return nil
        }
        return httpResponse.statusCode
    }
    
    func isSuccessCode() -> Bool {
        
        guard let code = statusCode() else {
            return false
        }
        return (code >= 200) && (code < 300)
    }
}
