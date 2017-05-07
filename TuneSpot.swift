//
//  TuneSpot.swift
//  Spottunes
//
//  Created by Leo Wong on 5/2/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit
import Parse

fileprivate let NameKey = "name"
fileprivate let LocationKey = "location"
fileprivate let ClassName = "TuneSpot"
fileprivate let searchNearbyRadiusMiles: Double = 10

class TuneSpot : PFObject, PFSubclassing {
    
    var name: String? {
        return self[NameKey] as? String
    }
    
    var location: PFGeoPoint? {
        return self[LocationKey] as? PFGeoPoint
    }
    
    
    func saveTuneSpot(name: String, long: CLLocationDegrees, lat: CLLocationDegrees) {
        self[NameKey] = name
        self[LocationKey] = PFGeoPoint(latitude: lat, longitude: long)
        self.saveInBackground()
    }
    
    static func parseClassName() -> String {
        return ClassName
    }
    
    static func getNearByTuneSpots(completionHandler: @escaping ([TuneSpot]?) -> Void){
        PFGeoPoint.geoPointForCurrentLocation { (point, error) in
            if let point = point{
                let searchQuery = PFQuery(className: ClassName)
                searchQuery.whereKey(LocationKey, nearGeoPoint: point, withinMiles: searchNearbyRadiusMiles)
                searchQuery.findObjectsInBackground { (objects, error) in
                    if let objects = objects{
                        if let spots = objects as? [TuneSpot]{
                            completionHandler(spots)
                        }else{
                            completionHandler(nil)
                        }
                    }else{
                        completionHandler(nil)
                    }
                }
            }
        }
    }
    
   
    
    
}
