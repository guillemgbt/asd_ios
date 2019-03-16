//
//  NetworkObject.swift
//  MonkingMe
//
//  Created by Adrià Sarquella on 01/11/2018.
//  Copyright © 2018 Guillem Budia Tirado. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

/// Class that wraps a `BaseObject` that needs to be fetched from the network by providing the object itself
/// (or `nil` if non existent) and the its' fetching network status.
class NetworkObject<Object: BaseObject> {
    
    internal var networkStatus: NetworkRequestState
    internal var objectId: String? //It stores just the wrapped object id to avoid having to store a full Realm reference
    
    
    init(networkStatus: NetworkRequestState, objectId: String?) {
        self.networkStatus = networkStatus
        self.objectId = objectId
    }
    
    
    /// Provides the fetching network status for the wrapped object
    ///
    /// - Returns: The network status via `NetworkRequestState` value
    func getNetworkStatus() -> NetworkRequestState {
        return self.networkStatus
    }
    
    
    /// Provides the wrapped object if existent in Realm. Returns `nil` otherwhise.
    ///
    /// - Returns: The wrapped object if existent in Realm. `nil` otherwise
    func getObject() -> Object? {
        if let id = objectId {
            let realm = try! Realm()
            return realm.object(ofType: Object.self, forPrimaryKey: id)
        } else {
            return nil
        }
    }
}


// Defines some extended methods for `Variable` which will only be available if the generic
// type corresponds to a `NetworkObject<Object: BaseObject>` instance
//
// NOTE: The generic type in which these methods are available is defined in the methods themselves
// instead of defining it in the 'extension' level as the generic type is a `NetworkObject<Object>`,
// which is also a generic type, and Swift does not provide for doing so (at least on Swift 3)
extension Variable {
    
    /// Observes its own value and dispatches the updated value to the provided callbacks.
    ///
    /// - Parameter onObjectUpdate: Callback that dispatches the new updated NetworkObject's 'object' value (Only when it is not `nil`)
    /// - Parameter onNetworkStatusUpdate: Callback that dispatches the new updated NetworkObject's 'networkStatus' value
    /// - Parameter disposeBag: The 'DisposeBag' instance used by the observable
    func observe<Object: BaseObject>(onObjectUpdate: @escaping (Object)->Void = {_ in },
                                     onNetworkStatusUpdate: @escaping (NetworkRequestState)->Void = {_ in },
                                     withDisposeBag disposeBag: DisposeBag)
        where Element == NetworkObject<Object>? {
            self.asObservable().subscribe(onNext: {networkObject in
                
                if networkObject == nil { return }
                
                //Notifies the new "networkStatus" value
                onNetworkStatusUpdate(networkObject!.networkStatus)
                
                //Notifies the new "object" value (In vase it is not nil)
                if let object = networkObject!.getObject() {
                    onObjectUpdate(object)
                }
            }).disposed(by: disposeBag)
    }
    
    /// Helper method to bind observables and use them in the Main Thread for UI changes
    ///
    /// - Parameters:
    ///   - callback: callback when observable is updated
    ///   - bag: dispose bag where to put the observable instance and manage its memory
    func bindInUI(_ callback: @escaping (Element)->(), disposedBy bag: DisposeBag) {
        
        self.asObservable().bind { (element) in
            DispatchQueue.main.async {
                callback(element)
            }
        }.disposed(by: bag)
    }
    
    
    func bindInMainScheduler(_ callback: @escaping (Element)->(), disposedBy bag: DisposeBag) {
        
        self.asObservable().observeOn(MainScheduler.asyncInstance).bind { (element) in
            DispatchQueue.main.async {
                callback(element)
            }
        }.disposed(by: bag)
    }
    
    /// Encapsulated method for normal binding of observables. Used to have all binding code in one place just in case it is needed to be changed.
    ///
    /// - Parameters:
    ///   - callback: called when object is updated
    ///   - bag: dispose bag where to put the observable instance and manage its memory
    func bind(_ callback: @escaping (Element)->(), disposedBy bag: DisposeBag) {
        self.asObservable().bind { (element) in
            callback(element)
        }.disposed(by: bag)
    }
    
    
    /// Updates the NetworkObject's 'networkStatus' value, keeping the current 'objectId'.
    ///
    /// - Parameter networkStatus: The new 'networkStatus' value
    func update<Object: BaseObject>(withNetworkStatus networkStatus: NetworkRequestState)
        where Element == NetworkObject<Object>?{
            self.update(withNetworkStatus: networkStatus, withObjectId: self.value?.objectId)
    }
    
    /// Updates the NetworkObject's 'objectId' value, keeping the current 'networkStatus'.
    ///
    /// - Parameter objectId: The new 'objectId' value
    func update<Object: BaseObject>(withObjectId objectId: String?)
        where Element == NetworkObject<Object>?{
            self.update(withNetworkStatus: self.value?.networkStatus ?? .initial, withObjectId: objectId)
    }
    
    /// Updates both the NetworkObject's 'networkStatus' and 'objectId' values.
    ///
    /// - Parameter networkStatus: The new 'networkStatus' value
    /// - Parameter objectId: The new 'objectId' value
    func update<Object: BaseObject>(withNetworkStatus networkStatus: NetworkRequestState, withObjectId objectId: String?)
        where Element == NetworkObject<Object>?{
            self.value = NetworkObject(networkStatus: networkStatus, objectId: objectId)
    }
    
}

