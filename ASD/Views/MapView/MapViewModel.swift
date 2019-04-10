//
//  MapViewModel.swift
//  ASD
//
//  Created by Guillem Budia Tirado on 06/04/2019.
//  Copyright © 2019 Guillem Budia Tirado. All rights reserved.
//

import MapKit
import CoreLocation
import RxSwift

class MapViewModel: NSObject {
    
    let mapRegion: Variable<MKCoordinateRegion?> = Variable(nil)
    let displayingMessage: Variable<Message?> = Variable(nil)
    let currentAnotation: Variable<MKPointAnnotation?> = Variable(nil)
    let registrationState: Variable<NetworkRequestState> = Variable(.initial)
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            
            prepareLocationManager()
            checkLocationAuthorization()
            
        } else {
            displayPermissionsMessage()
        }
    }
    
    func prepareLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                self.centerRegionOnUserLocation()
            }
        }
    }
    
    func centerRegionOnUserLocation() {
        
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionInMeters,
                                            longitudinalMeters: regionInMeters)
            
            mapRegion.value = region
        }
        
    }
    
    func removeAnnotation() {
        currentAnotation.value = nil
    }
    
    func handleLongPress(gesture: UIGestureRecognizer, in mapView: MKMapView) {
        
        guard gesture.state == .began else { return }
        
        let pinCoordinates = mapView.coodrinates(from: gesture)
        
        Utils.printDebug(sender: self, message: "Setting new Pin: \(pinCoordinates.latitude) - \(pinCoordinates.longitude)")
        
        setNewAnnotation(coordinates: pinCoordinates, title: "New Area Center")
    }
    
    func handleNewArea(name: String) {
        
        guard let center = currentAnotation.value else { return }
        
        AreaRepo.shared.registerArea(name: name,
                                     center: center.coordinate,
                                     state: registrationState)
        
        
    }
    
    private func setNewAnnotation(coordinates: CLLocationCoordinate2D, title: String) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotation.title = title
        annotation.subtitle = "\(coordinates.latitude) - \(coordinates.longitude)"
        
        currentAnotation.value = annotation
    }
    

    
    private func displayPermissionsMessage() {
        displayingMessage.value = Message(title: "Location Services Disabled",
                                          body: "Please turn on your location services to use the app.")
    }

}

extension MapViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
}
