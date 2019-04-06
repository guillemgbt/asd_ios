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

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    let regionInMeters: Double = 10000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareLocationManager()
        prepareMapView()
        presentPreviousAreasVC()
        
        checkLocationServices()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func prepareLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerRegionOnUserLocation() {
        
        mapView.showsUserLocation = true
        
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionInMeters,
                                            longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
        
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            
            prepareLocationManager()
            checkLocationAuthorization()
            
        } else {
            displayPermissionsMessage()
        }
    }
    
    func checkLocationAuthorization() {
        
        switch CLLocationManager.authorizationStatus() {
        case .denied:
            displayPermissionsMessage()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            displayPermissionsMessage()
            break
        default:
            centerRegionOnUserLocation()
        }
    }
    
    private func prepareMapView() {
        
        mapView.delegate = self
        
    }
    
    private func presentPreviousAreasVC() {
        
        let vc = PreviousAreasViewController()
        
        vc.presenter = self
        
        addPullUpController(vc,
                            initialStickyPointOffset: 90,
                            animated: false)
    }
    
    private func displayPermissionsMessage() {
        showMessage(title: "Location Services Disabled",
                    message: "Please turn on your location services to use the app.")
    }

}

extension MapViewController: MKMapViewDelegate {
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
}

extension MapViewController: AreaPresenter {
    func areaPresenter(didSelect area: Area) {
        
        let vc = EventListViewController(areaID: area.getPK())
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
