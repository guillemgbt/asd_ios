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
    @IBOutlet weak var createNewAreaView: UIView!
    @IBOutlet weak var createNewAreaButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        createNewAreaButton.makeCircular()
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
            
            self?.mapView.removePointAnnotations()
            self?.showCreateAreaButton(show: _annotation != nil)
            
            guard let annotation = _annotation else { return }
            self?.mapView.addAnnotation(annotation)
            self?.mapView.selectAnnotation(annotation, animated: true)
            
        }, disposedBy: bag)
        
    }
    
    private func prepareMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        createNewAreaView.isHidden = true
        
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
    
    
    @IBAction func createAreaButtonAction(_ sender: Any) {
        presentTextFieldAlert()
    }
    
    private func presentPreviousAreasVC() {
        
        let vc = PreviousAreasViewController()
        
        vc.presenter = self
        
        addPullUpController(vc,
                            initialStickyPointOffset: 90,
                            animated: false)
    }
    
    private func presentTextFieldAlert() {
        
        showTextFieldAlert(title: "New Area Title",
                           subtitle: "Set a descriptive name for the area you want to scan.",
                           placeholder: "New Area") { (text) in
                        
                            Utils.printDebug(sender: self, message: text)
        }        
    }
    
    private func showCreateAreaButton(show: Bool) {
        
        if show { createNewAreaView.isHidden = false}
        
        UIView.animate(withDuration: 0.3, animations: {
            self.createNewAreaView.alpha = show ? 1 : 0
        }) { (_) in
            self.createNewAreaView.isHidden = !show
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        viewModel.removeAnnotation()
    }
}

extension MapViewController: AreaPresenter {
    func areaPresenter(didSelect area: Area) {
        
        let vc = EventListViewController(areaID: area.getPK())
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
