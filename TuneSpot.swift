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
    
    var geoPoint: PFGeoPoint? {
        return self[LocationKey] as? PFGeoPoint
    }
    
    var isSpotExisted: Bool?
    
    override init(){
        super.init()
    }
    
    init(name: String, location: PFGeoPoint) {
        super.init()
    }
    

    class func saveTuneSpot(name: String, long: CLLocationDegrees, lat: CLLocationDegrees, completionHandler: @escaping PFBooleanResultBlock) {
        let spot = TuneSpot()
        spot[NameKey] = name
        spot[LocationKey] = PFGeoPoint(latitude: lat, longitude: long)
        spot.saveInBackground(block: completionHandler)
    }
    
    static func parseClassName() -> String {
        return ClassName
    }
    
    static func getNearByTuneSpots(completionHandler: @escaping ([TuneSpot]?) -> Void){
       
        
        PFGeoPoint.geoPointForCurrentLocation { (point, error) in
            if let point = point{
                
                //fetch from Foursquare api
                FoursquareClient.fetchRecommendedPlaces(geoPoint: point, success: { (locations) in
                    
                    
                    
                })

                //fetch from parse db
                let searchQuery = PFQuery(className: ClassName)
                searchQuery.whereKey(LocationKey, nearGeoPoint: point, withinMiles: searchNearbyRadiusMiles)
                searchQuery.findObjectsInBackground { (objects, error) in
                    if let objects = objects{
                        if var spots = objects as? [TuneSpot]{
                            spots = spots.map({ (spot) -> TuneSpot in
                                spot.isSpotExisted = true
                                return spot
                            })
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
