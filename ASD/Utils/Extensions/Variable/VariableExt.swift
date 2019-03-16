//
//  VariableExt.swift
//  MonkingMe
//
//  Created by Adrià Sarquella on 20/12/2018.
//  Copyright © 2018 Guillem Budia Tirado. All rights reserved.
//

import RxSwift

extension Variable {
    
    func observeInUI(onNext: @escaping (Element)->Void,
                        disposeBy disposeBag: DisposeBag) {
        self.asObservable().subscribe(onNext: { element in
            DispatchQueue.main.async {
                onNext(element)
            }
        }).disposed(by: disposeBag)
    }
}
