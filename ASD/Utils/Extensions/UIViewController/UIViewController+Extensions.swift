//
//  UIViewController+Extensions.swift
//  MonkingMe
//
//  Created by Guillem Budia Tirado on 24/10/2018.
//  Copyright © 2018 Guillem Budia Tirado. All rights reserved.
//

import UIKit

extension UIViewController {
    func getTopScreenPading() -> CGFloat? {
        
        if #available(iOS 11.0, *) {
            if let tp = UIApplication.shared.keyWindow?.safeAreaInsets.top, !tp.isZero {
                return tp
            }
        }
        return nil
    }
    
    func mapParallaxToFadingNavigationBarProgress(_ progress: CGFloat) -> CGFloat {
        
        var progressMapped = progress*2 - 0.5 //Mapping progress to [0, 2]
        
        if progressMapped.isNaN { progressMapped = 2 }
        
        if progressMapped > 1 { progressMapped = 1 } // Capping progress to [0, 1], half of the header compression
        
        return 1-progressMapped
    }
    
    /// Styles the navBar with a custom large title style
    /// It is recommended to be called in "onViewWillAppear"
    func setLargeTitleNavBar() {
        if #available(iOS 11.0, *) {
            if let navController = self.navigationController  {
                navController.view.backgroundColor = UIColor.white
                navController.navigationBar.prefersLargeTitles = true
                navController.navigationBar.isTranslucent = false //Sets background to be white
                navController.navigationBar.shadowImage = UIImage() //Removes bottom line
                
                //Updates title margins to be 24 for each side
                navController.navigationBar.layoutMargins.left = 24
                navController.navigationBar.layoutMargins.right = 24
                
            }
        }
    }
    
    func resetDefaultNavBar() {
        if #available(iOS 11.0, *) {
            if let navBar = self.navigationController?.navigationBar {
                navBar.prefersLargeTitles = false
                navBar.isTranslucent = true
                navBar.shadowImage = nil
            }
        }
    }
}

