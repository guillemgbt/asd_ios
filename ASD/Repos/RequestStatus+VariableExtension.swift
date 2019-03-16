//
//  RequestStatus.swift
//  MonkingMe
//
//  Created by Adrià Sarquella on 16/11/2018.
//  Copyright © 2018 Guillem Budia Tirado. All rights reserved.
//

import Foundation
import RxSwift

/// Class that wraps the status of a request by providing a status value
/// as well as a message in case it is necessary
class RequestStatus {
    fileprivate var networkStatus: NetworkRequestState
    fileprivate var message: String?
    
    init(networkStatus: NetworkRequestState = .initial,
         message: String? = nil) {
        self.networkStatus = networkStatus
        self.message = message
    }
    
    func getNetworkStatus() -> NetworkRequestState {
        return self.networkStatus
    }
    
    func getMessage() -> String? {
        return self.message
    }
}

// Defines some extended methods for `Variable` which will only be available if the generic
// type corresponds to a `RequestStatus` instance
extension Variable where Element == RequestStatus {
    
    func update(networkStatus: NetworkRequestState) {
        self.update(networkStatus: networkStatus,
                    message: self.value.message)
    }
    
    func update(message: String?) {
        self.update(networkStatus: self.value.networkStatus,
                    message: message)
    }
    
    func update(networkStatus: NetworkRequestState, message: String?) {
        self.value = RequestStatus(networkStatus: networkStatus,
                                   message: message)
    }
}
