//
//  MapViewController.swift
//  Spottunes
//
//  Created by Huang Edison on 4/23/17.
//  Copyright © 2017 Edison. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    @IBOutlet weak var someLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    static var currentLocation : CLLocationCoordinate2D?
        
    var locationManager : CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // called when authorization status changed
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    // called when location changes
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                
        let location = locations.first
        MapViewController.currentLocation = location?.coordinate
        
        let mapSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: MapViewController.currentLocation!, span: mapSpan)
        // Set animated property to true to animate the transition to the region
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        let reuseID = "myAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            /// show the callout "bubble" when annotation view is selected
            
            annotationView?.canShowCallout = true
        }
        
        let pinImage = UIImage(named: "music")

        let resizeRenderImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        //resizeRenderImageView.layer.borderColor = UIColor.white.cgColor
        //resizeRenderImageView.layer.borderWidth = 3.0
        resizeRenderImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeRenderImageView.image = pinImage
        
        UIGraphicsBeginImageContextWithOptions(resizeRenderImageView.frame.size, false, 0.0)
        resizeRenderImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        annotationView?.image = thumbnail
        
        /// Add an info button to the callout "bubble" of the annotation view
        let rightCalloutButton = UIButton(type: .detailDisclosure)
        rightCalloutButton.tintColor = UIColor.red
        annotationView?.rightCalloutAccessoryView = rightCalloutButton
        
        
        
        /// Add image to the callout "bubble" of the annotation view
        let image = UIImage(named: "test")
        let leftCalloutImageView = UIImageView(image: image)
        annotationView?.leftCalloutAccessoryView = leftCalloutImageView
        annotationView?.leftCalloutAccessoryView?.contentMode = .scaleAspectFit
        //annotationView?.detailCalloutAccessoryView = leftCalloutImageView
        
        return annotationView
    }

    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("tap on ", view.annotation?.title)
        
    }
    
    @IBAction func onTapTestButton(_ sender: UIButton) {
        
        sender.tintColor = UIColor.green
        
        FoursquareClient.shared.fetchRecommendedPlaces(ll: MapViewController.currentLocation!) { (locations: [Location]) in
            for location in locations{
                self.mapView.addLocation(location)
            }
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
        
    }
    

    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
