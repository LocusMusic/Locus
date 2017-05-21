//
//  MKMapViewExtension.swift
//  Locus
//
//  Created by Huang Edison on 4/26/17.
//  Copyright © 2017 Edison. All rights reserved.
//

import UIKit
import MapKit

extension MKMapView {
    
    func addLocation(_ location: Location) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.latLng!
        annotation.title = String(describing: "\(location.name!)")
        self.addAnnotation(annotation)
    }
}

