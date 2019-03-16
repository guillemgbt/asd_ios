//
//  TableViewCell+Extensions.swift
//  MonkingMe
//
//  Created by Guillem Budia Tirado on 18/11/2018.
//  Copyright © 2018 Guillem Budia Tirado. All rights reserved.
//

import UIKit
import Foundation


protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self)
    }
}

extension UITableViewCell: ReusableView {}

protocol NibLoadableView: class {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

