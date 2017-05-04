//
//  Location.swift
//  Spottunes
//
//  Created by Huang Edison on 4/20/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit
import CoreLocation

class Location: NSObject, CLLocationManagerDelegate {
    var venue: NSDictionary?
    var name: String?
    
    
    init(venue: NSDictionary) {
        self.venue = venue
        self.name = venue["name"] as? String
    }
    
    // example: (lat: 40.69957, lng: -73.99793)
    var latLng : CLLocationCoordinate2D? {
        let lat = venue?.value(forKeyPath: "location.lat") as! NSNumber
        let lng = venue?.value(forKeyPath: "location.lng") as! NSNumber
        let CLLat = CLLocationDegrees(lat)
        let CLLng = CLLocationDegrees(lng)
        return CLLocationCoordinate2DMake(CLLat, CLLng)
    }
    
    var lat: CLLocationDegrees? {
        return latLng?.latitude
    }
    
    var lng: CLLocationDegrees? {
        return latLng?.longitude
    }
    
    // example: Furman St
    var address: String? {
        return venue?.value(forKeyPath: "location.address") as? String
    }
    
    // example: Brooklyn Bridge Park Greenway
    var crossStreet: String? {
        return venue?.value(forKeyPath: "location.crossStreet") as? String
    }
    
    // distance in meter, example: 180
    var distance: Int? {
        return venue?.value(forKeyPath: "location.distance") as? Int
    }
    
    // example: US
    var cc: String? {
        return venue?.value(forKeyPath: "location.cc") as? String
    }
    
    // example: Brooklyn
    var city: String? {
        return venue?.value(forKeyPath: "location.city") as? String
    }
    
    // example: NY
    var state: String? {
        return venue?.value(forKeyPath: "location.state") as? String
    }
    
    // example: United State
    var country: String? {
        return venue?.value(forKeyPath: "location.country") as? String
    }
    
    class func locationsWithArray(venues: [NSDictionary]) -> [Location] {
        var locations = [Location]()
        
        for venue in venues {
            locations.append(Location(venue: venue))
        }
        return locations
    }
    
}
