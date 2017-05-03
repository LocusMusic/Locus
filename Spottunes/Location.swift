//
//  Location.swift
//  Spottunes
//
//  Created by Huang Edison on 4/20/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit
import CoreLocation

class Location: NSObject {
    var location: NSDictionary?
    var name: String?
    
    init(venue: NSDictionary) {
        self.location = venue["location"] as? NSDictionary
        self.name = venue["name"] as? String
    }
    
    // example: (lat: 40.69957, lng: -73.99793)
    var latLng : CLLocationCoordinate2D {
        let lat = location?["lat"] as! Double
        let lng = location?["lng"] as! Double
        let CLLat = CLLocationDegrees(exactly: lat)
        let CLLng = CLLocationDegrees(exactly: lng)
        return CLLocationCoordinate2DMake(CLLat!, CLLng!)
    }
    
    var lat : CLLocationDegrees {
        return location?["lat"] as! CLLocationDegrees
    }
    
    var lng : CLLocationDegrees {
        return location?["lng"] as! CLLocationDegrees
    }
    
    // example: Furman St
    var address: String? {
        return location?["address"] as? String
    }
    
    // example: Brooklyn Bridge Park Greenway
    var crossStreet: String? {
        return location?["crossStreet"] as? String
    }
    
    // distance in meter, example: 180
    var distance: Int? {
        return location?["distance"] as? Int
    }
    
    // example: US
    var cc: String? {
        return location?["cc"] as? String
    }
    
    // example: Brooklyn
    var city: String? {
        return location?["city"] as? String
    }
    
    // example: NY
    var state: String? {
        return location?["state"] as? String
    }
    
    // example: United State
    var country: String? {
        return location?["country"] as? String
    }
    
    class func locationsWithArray(items: [NSDictionary]) -> [Location] {
        var locations = [Location]()
        for item in items{
            let venue = item["venue"] as! NSDictionary
            locations.append(Location(venue: venue))
        }
        return locations
    }
    
}
