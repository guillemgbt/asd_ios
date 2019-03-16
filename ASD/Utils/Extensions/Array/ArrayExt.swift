//
//  ArrayExt.swift
//  MonkingMe
//
//  Created by Guillem Budia Tirado on 29/06/2018.
//  Copyright © 2018 Guillem Budia Tirado. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    mutating func mix(newElements: [Element], maxElements: Int? = nil, blockSize: Int = 1) {
        
        
        if self.isEmpty {
            self.append(contentsOf: newElements)
        } else {
            
            var finalArray = [Element]()

            let blocks: Int = Swift.max(self.blockNumber(forSize: blockSize), newElements.blockNumber(forSize: blockSize))
            
            for  blockIndex in 0...((2*blocks)-1){
                for _ in 0...blockSize-1 {
                    
                    if let mxEl = maxElements, finalArray.count >= mxEl {break}
                    
                    let possibleNextSong = (blockIndex%2 == 0 ? self : newElements).first { (element) -> Bool in
                        return !finalArray.contains(element)
                    }
                    
                    if let nextSong = possibleNextSong {
                        finalArray.append(nextSong)
                    }
                }
            }
            
            self = finalArray
        }

    }
    
    private func blockNumber(forSize size: Int) -> Int {
        return Int(ceil(Float(self.count)/Float(size)))
    }
}
