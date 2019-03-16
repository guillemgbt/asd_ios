//
//  GeneralRepo.swift
//  MonkingMe
//
//  Created by Guillem Budia Tirado on 14/06/2018.
//  Copyright © 2018 Guillem Budia Tirado. All rights reserved.
//

import RealmSwift
import RxSwift
import SwiftyJSON

class GeneralObjectRepo<T: GeneralObject>: BaseRepo {
    
    // MARK: - [NextRefactor]: Status included in each attribute of the class that request server data e.g. NetworkBoundModel (including network state and data as observables)
    var fetchingStatus: Variable<NetworkRequestState> = Variable(.initial)
    
    func getObject(byPK pk: String) -> T? {
        let realm = try! Realm()
        return realm.object(ofType: T.self, forPrimaryKey: pk)
    }
    
    func objectExists(withPk pk: String) -> Bool {
        return getObject(byPK: pk) != nil
    }
    

    func shouldFetchObject(withPK pk: String, withFetchingFrequency fetchingFrequency: FetchingFrequency) -> Bool {
        
        guard let object = getObject(byPK: pk) else {
            return true //Object does not exist
        }
        
        return fetchingFrequency.shouldFetch(object: object, utils: utils)
    }
    
    
    func fetchNetworkObject(withPK pk: String, withFetchingFrequency fetchingFrequency: FetchingFrequency, networkObjectObservable: Variable<NetworkObject<T>?>) {
        
        //Initialising the value (networkObject) of the observable.
        //This will trigger an binding update for the newtworkStatus and object if in DB
        networkObjectObservable.update(withNetworkStatus: .initial, withObjectId: pk)
        
        //Object must be fetched if it does not exists or if fetchingFrequency specifies so
        if shouldFetchObject(withPK: pk, withFetchingFrequency: fetchingFrequency) {
            fetch(withKey: pk, toUpdate: networkObjectObservable)
        }
    }
    
    
    func getObjectResults() -> Results<T> {
        let realm = try! Realm()
        return realm.objects(T.self)
    }
    
    func getObjectResults(filteredBy predicate: NSPredicate) -> Results<T> {
        return getObjectResults().filter(predicate)
    }
    
    func deleteAllStored() {
        let realm = try! Realm()
        let allObjects = getObjectResults()
        try! realm.write {
            realm.delete(allObjects)
        }
    }
    
    func fetch() {} //To override
    
    func fetch(withKey key: String, toUpdate networkObject: Variable<NetworkObject<T>?>) {} //To override
    
    //As we request a list of multiple objects, the element "Results" of Realm is the observable itself of the data.
    //Then we only need to update the network state for a particular call
    func fetchList(withKey key: String, toUpdate networkState: Variable<NetworkRequestState>) {} //To override

    
    func networkObservable(forState state: NetworkRequestState) -> Observable<Bool> {
        
        return fetchingStatus.asObservable().map { (networkState) -> Bool in
            return networkState == state
        }
    }
    
    internal func updateStored(object: T) {
        self.updateStored(objects: [object])
    }
    
    internal func updateStored(objects: [T]) {
        
        let realm = try! Realm()

        try! realm.write {
            realm.add(objects, update: true)
        }
    }
    
    /// Deletes objects of the specified type and category (if specified) and stores the new ones. eg. Store Giveaway type objects, but deleting only the category of a specified artist.
    ///
    /// - Parameters:
    ///   - objects: objects to be stored
    ///   - categoryPredicate: predicate representing the category of a type of object
    internal func replaceStored(objects: [T], categoryPredicate: NSPredicate? = nil) {
        
        let realm = try! Realm()
        
        let newPKs = objects.map { $0.getPK() }
        
        try! realm.write {
            
            let toDeletePredicate = NSPredicate(format: "NOT pk IN %@", newPKs)
            var objectsToDelete = getObjectResults(filteredBy: toDeletePredicate)
            
            if let category = categoryPredicate {
                objectsToDelete = objectsToDelete.filter(category)
            }
            
            realm.delete(objectsToDelete)
            
            realm.add(objects, update: true)
        }
        
    }
    
}
