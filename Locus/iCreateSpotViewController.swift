//
//  CreateSpotViewController.swift
//  Spottunes
//
//  Created by Xie kesong on 4/22/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit
import CoreLocation


class CreateSpotViewController: GradientBackgroundAnimatedViewController {
    var locations : [Location]?
    var isFetchingLocation = false
    lazy var locationManager =  CLLocationManager()
    
   
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        print(UIScreen.main.bounds)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
        
}

extension CreateSpotViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocationCoordinate = locations.first?.coordinate{
            if !self.isFetchingLocation{
                FoursquareClient.sharedInstance.getRecommendedPlaces(ll: currentLocationCoordinate) { (locations: [Location]) in
                    self.locations = locations
                    for location in locations{
                        print(location.name!)
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status{
        case .authorizedWhenInUse:
            self.locationManager.requestLocation()
            print("requesting location")
        case .denied:
            print("please allow location service")
        default:
            break
        }
    }
    
    
}
