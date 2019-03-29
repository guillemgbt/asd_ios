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
        
        presentPreviousAreasVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func presentPreviousAreasVC() {
        
        let vc = PreviousAreasViewController()
        
        vc.presenter = self
        
        addPullUpController(vc,
                            initialStickyPointOffset: 90,
                            animated: false)
    }

}

extension MapViewController: AreaPresenter {
    func areaPresenter(didSelect area: Area) {
        
        let vc = EventListViewController(areaID: area.getPK())
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
