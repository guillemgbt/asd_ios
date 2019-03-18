//
//  MapViewController.swift
//  ASD
//
//  Created by Guillem Budia Tirado on 06/03/2019.
//  Copyright © 2019 Guillem Budia Tirado. All rights reserved.
//

import UIKit
import PullUpController

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPullUpController(PreviousAreasViewController(),
                            initialStickyPointOffset: 90,
                            animated: false)
        
    }

}
