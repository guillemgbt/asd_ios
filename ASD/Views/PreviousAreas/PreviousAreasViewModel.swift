//
//  PreviousAreasViewModel.swift
//  ASD
//
//  Created by Guillem Budia Tirado on 14/03/2019.
//  Copyright © 2019 Guillem Budia Tirado. All rights reserved.
//

import RxSwift
import Foundation
import RealmSwift

class PreviousAreasViewModel: NSObject {
    
    let areaRepo: AreaRepo
    
    let title: Variable<String> = Variable("Previous Areas")
    let isLoading: Variable<Bool> = Variable(false)
    let requestState: Variable<NetworkRequestState> = Variable(.initial)
    let areas: Results<Area>
    
    let bag = DisposeBag()
    
    init(areaRepo: AreaRepo = AreaRepo.shared) {
        self.areaRepo = areaRepo
        self.areas = areaRepo.getSortedObjectResults()
        super.init()
        
        bindRequestState()
    }
    
    func fetchAreas() {
        areaRepo.fetchList(withKey: "", toUpdate: requestState)
    }
    
    func bindRequestState() {
        
        requestState.bind({ [weak self] (state) in
            
            self?.isLoading.value = (state == .loading)
            
        }, disposedBy: bag)
    }

}
