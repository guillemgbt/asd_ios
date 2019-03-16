//
//  CollectionViewExt.swift
//  MonkingMe
//
//  Created by Guillem Budia Tirado on 02/01/2019.
//  Copyright © 2019 Guillem Budia Tirado. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionViewCell: ReusableView {}

extension UICollectionView {
    
    func registerNib<T: UICollectionViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
        register(UINib(nibName: T.nibName, bundle: nil),
                 forCellWithReuseIdentifier: T.nibName)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: ReusableView, T: NibLoadableView {
        
        guard let cell =  dequeueReusableCell(withReuseIdentifier: T.nibName, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")

        }
        
        return cell
    }
}
