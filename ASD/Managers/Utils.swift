//
//  Debug.swift
//  MonkingMe
//
//  Created by Adrià Sarquella on 12/1/17.
//  Copyright © 2017 Guillem Budia Tirado. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class Utils{
    
    static let shared = Utils()
    
    var appLaunchingTimestamp: Date
    
    init(appLaunchingTimestamp: Date = Date()) {
        self.appLaunchingTimestamp = appLaunchingTimestamp
    }
    
    func updateLaunchingTimestamp(date: Date = Date()) {
        self.appLaunchingTimestamp = date
    }
    
    func getLaunchingTimestamp() -> Date {
        return appLaunchingTimestamp
    }
    
    static func printDebug(sender: AnyObject?, message: Any){
        if let _sender = sender {
            print("["+String(describing: type(of: _sender))+"]: \(message)")
        } else {
            print("[]: \(message)")
        }
    }
    
    static func logDebug(sender: AnyObject?, message: Any){
        if let _sender = sender {
            let str = "["+String(describing: type(of: _sender))+"]: \(message)"
            NSLog(str)
        } else {
            print("[]: \(message)")
        }
    }
    
    static func printError(sender: AnyObject?, message: Any){
        if let _sender = sender {
            print("ERROR! -> ["+String(describing: type(of: _sender))+"]: \(message)")
        } else {
            print("ERROR! -> []: \(message)")
        }
    }
    
    static func printDebug(tag: String, message: Any){
        print("[\(tag)]: \(message)")
    }
    
    static func printError(tag: String, message: Any){
        print("ERROR! -> [\(tag)]: \(message)")
    }
    
    func getComponentFromStringDate(component comp: Calendar.Component, stringDate d: String, dateStyle style: DateFormatter.Style) -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        let date: Date = dateFormatter.date(from: d)!
        
        let calendar = Calendar.current
        
        return calendar.component(comp, from: date)

    }
}
