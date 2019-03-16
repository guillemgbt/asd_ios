//
//  FetchingFrequency.swift
//  MonkingMe
//
//  Created by Adrià Sarquella on 02/11/2018.
//  Copyright © 2018 Guillem Budia Tirado. All rights reserved.
//

import Foundation

enum FetchingFrequency {
    case always
    case whenNotStored
    case after(minutes: Int)
    case onAppLaunched
    
    /// To know if an object has to be fetched given a fetching frequency and the object last updated date. IMPORTANT: This func accesses to Realm properties of Base Object; take into account that the object passed should be created/fetched in the same thread that this function is being used.
    ///
    /// - Parameter object: object to u`date or not
    /// - Parameter utils: dependency injection of utils manager, used to get the timestamp of the app launched
    /// - Returns: if the object needs to be fetched
    func shouldFetch(object: BaseObject, utils: Utils = Utils.shared) -> Bool{
        switch self {
        case .whenNotStored:
            return false
        case .after(minutes: let minutes):
            
            guard let thresholdDate = Calendar.current.date(byAdding: .minute,
                                                            value: minutes,
                                                            to: object.lastUpdate()) else
            { return true }
            
            return thresholdDate < Date()
            
        case .onAppLaunched:
            return object.lastUpdate() < utils.getLaunchingTimestamp()
        default:
            return true
        }
    }
}
