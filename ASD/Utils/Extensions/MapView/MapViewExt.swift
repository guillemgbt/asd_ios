//
//  MapViewExt.swift
//  ASD
//
//  Created by Guillem Budia Tirado on 07/04/2019.
//  Copyright © 2019 Guillem Budia Tirado. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation


extension MKMapView {
    
    func coodrinates(from gesture: UIGestureRecognizer) -> CLLocationCoordinate2D {
        
        let point = gesture.location(in: self)
        return convert(point, toCoordinateFrom: self)
    }
    
    func removePointAnnotations() {
        
       removeAnnotations(annotations.filter({ $0 is MKPointAnnotation }))
    }
    
}
