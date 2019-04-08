//
//  MapViewController.swift
//  ASD
//
//  Created by Guillem Budia Tirado on 06/03/2019.
//  Copyright © 2019 Guillem Budia Tirado. All rights reserved.
//

import UIKit
import MapKit
import PullUpController
import CoreLocation
import RxSwift

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let viewModel = MapViewModel()
    let bag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindView()
        
        prepareMapView()
        
        presentPreviousAreasVC()
        
        viewModel.checkLocationServices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func bindView() {
        bindMapRegion()
        bindMessage()
        bindNewAnnotation()
    }
    
    private func bindMapRegion() {
        
        viewModel.mapRegion.bindInUI({ [weak self] (_region) in
            
            guard let region = _region else { return }
            
            self?.mapView.setRegion(region, animated: true)
            
        }, disposedBy: bag)
    }
    
    private func bindMessage() {
        
        viewModel.displayingMessage.bindInUI({ [weak self] _message in
            guard let message = _message else { return }
            self?.showMessage(title: message.title,
                              message: message.body)
            
        }, disposedBy: bag)
    }
    
    private func bindNewAnnotation() {
        
        viewModel.currentAnotation.bindInUI({ [weak self] (_annotation) in
            
            guard let annotation = _annotation else { return }
            
            self?.mapView.removePointAnnotations()
            self?.mapView.addAnnotation(annotation)
            self?.mapView.selectAnnotation(annotation, animated: true)
            
        }, disposedBy: bag)
        
    }
    
    private func prepareMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        setLongPressOnMap()
    }
    
    private func setLongPressOnMap() {
        
        let gesture = UILongPressGestureRecognizer(target: self,
                                                   action: #selector(didLongPressOnMap(gestureRegognizer:)))
        
        gesture.minimumPressDuration = 1.0
        
        mapView.addGestureRecognizer(gesture)
    }
    
    @objc func didLongPressOnMap(gestureRegognizer: UIGestureRecognizer) {
        
        viewModel.handleLongPress(gesture: gestureRegognizer, in: mapView)
        
    }
    
    
    
    private func presentPreviousAreasVC() {
        
        let vc = PreviousAreasViewController()
        
        vc.presenter = self
        
        addPullUpController(vc,
                            initialStickyPointOffset: 90,
                            animated: false)
    }
    
    
  

}

extension MapViewController: MKMapViewDelegate {}

extension MapViewController: AreaPresenter {
    func areaPresenter(didSelect area: Area) {
        
        let vc = EventListViewController(areaID: area.getPK())
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
