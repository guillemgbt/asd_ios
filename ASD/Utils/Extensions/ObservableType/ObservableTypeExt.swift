//
//  ObservableTypeExt.swift
//  MonkingMe
//
//  Created by Guillem Budia Tirado on 21/06/2018.
//  Copyright © 2018 Guillem Budia Tirado. All rights reserved.
//

import RxSwift

extension ObservableType {
    
    /**
     RunningDiff simplifies the operation of maintaining a running diff from an observable value.
     
     @param seed: The initial value to diff against
     @param diffSeed: The initial diff value
     @param diff: A function that is able to compute the diff between two Observable elements
     */
    // swiftlint:disable:next variable_name
    func runningDiff<A>(seed: E, diffSeed: A, diff: @escaping (E, E) -> A) -> Observable<A> {
        return self
            .scan((seed, diffSeed), accumulator: { running, new -> (E, A) in
                let diffed = diff(running.0, new)
                
                return (new, diffed)
            })
            .map { _, diffed in diffed }.skip(1)
    }
    
}
