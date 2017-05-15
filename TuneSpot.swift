//
//  TuneSpot.swift
//  Spottunes
//
//  Created by Leo Wong, Kesong Xie on 5/2/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit
import Parse

fileprivate let ClassName = "TuneSpot"
fileprivate let NameKey = "name"
fileprivate let LocationKey = "location"
fileprivate let AddressKey = "address"
fileprivate let CoverURLStringKey = "coverURLString"
fileprivate let GenreKey = "genre"

fileprivate let searchNearbyRadiusMiles: Double = 10

class TuneSpot : PFObject {
    
    var name: String! {
        if self.embedLocation == nil{
            return self[NameKey] as! String
        }else{
            return self.embedLocation.name
        }
    }
    
    var address: String! {
        if self.embedLocation == nil{
            return self[AddressKey] as! String
        }else{
            return self.embedLocation.formatAddress
        }
    }

    var location: PFGeoPoint! {
        if self.embedLocation == nil{
            return self[LocationKey] as! PFGeoPoint
        }else{
            return PFGeoPoint(latitude: self.embedLocation.lat, longitude: self.embedLocation.lng)
        }
    }
    
    var coverURLString: String?{
        get{
            return self[CoverURLStringKey] as? String
        }
        set(newValue){
            self[CoverURLStringKey] = newValue
        }
    }

    var coverURL: URL?{
        if let urlString = self.coverURLString{
            return URL(string: urlString)
        }
        return nil
    }
    
    var genre: String?{
        get{
            return self[CoverURLStringKey] as? String
        }
        set(newValue){
            self[CoverURLStringKey] = newValue
        }
    }

    
    
    var embedLocation: Location!
    
    var isSpotExisted: Bool?
    
    override init(){
        super.init()
    }
    
    init(location: Location) {
        super.init()
        self.embedLocation = location
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let spot = object as? TuneSpot{
            print("is equals?")
            print(abs(self.location.latitude - spot.location.latitude) < 0.0001 && abs(self.location.longitude - spot.location.longitude) < 0.0001)
            return abs(self.location.latitude - spot.location.latitude) < 0.0001 && abs(self.location.longitude - spot.location.longitude) < 0.0001
        }
        return false
    }
    
 
    func saveTuneSpot(completionHandler: @escaping PFBooleanResultBlock) {
        self[NameKey] = self.name
        self[LocationKey] = self.location
        self[AddressKey] = self.address
        self[CoverURLStringKey] = self.coverURLString ?? ""
        self.saveInBackground(block: completionHandler)
    }
    
    static func getNearbyPopularTuneSpot(completionHandler: @escaping ([TuneSpot]?) -> Void){
        PFGeoPoint.geoPointForCurrentLocation { (point, error) in
            if let point = point{
                //fetch from parse db
                let searchQuery = PFQuery(className: ClassName)
                searchQuery.whereKey(LocationKey, nearGeoPoint: point, withinMiles: searchNearbyRadiusMiles)
                searchQuery.findObjectsInBackground { (objects, error) in
                    if let objects = objects{
                        if var spotsFromParse = objects as? [TuneSpot]{
                            spotsFromParse = spotsFromParse.map({ (spot) -> TuneSpot in
                                spot.isSpotExisted = true
                                return spot
                            })
                            spotsFromParse = spotsFromParse.map({ (spot) -> TuneSpot in
                                spot.isSpotExisted = true
                                return spot
                            })
                            completionHandler(spotsFromParse)
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
    
    static func getNearByTuneSpots(completionHandler: @escaping ([TuneSpot]?) -> Void){
        //fetch from Foursquare api
        PFGeoPoint.geoPointForCurrentLocation { (point, error) in
            if let point = point{
                let spotsFromParse = App.delegate?.popularTuneSpot ?? []
                FoursquareClient.fetchRecommendedPlaces(geoPoint: point, success: { (spotsFromFourSquare) in
                    //filtered out the spot already in parse database
                    let filteredSpot = spotsFromFourSquare.filter({ (spot) -> Bool in
                        return !spotsFromParse.contains(spot)
                    })
                    let resultSpot = spotsFromParse + filteredSpot
                    completionHandler(resultSpot)
                })
            }
        }
    }

    
    static func searchNearbyTuneSpot(query: String, completionHandler: @escaping ([TuneSpot]?) -> Void){
        PFGeoPoint.geoPointForCurrentLocation { (point, error) in
            if let point = point{
                //fetch from parse db
                let searchQuery = PFQuery(className: ClassName)
                searchQuery.whereKey(LocationKey, nearGeoPoint: point, withinMiles: searchNearbyRadiusMiles)
                searchQuery.whereKey(NameKey, matchesRegex: query, modifiers: "i")
                searchQuery.findObjectsInBackground { (objects, error) in
                    if let objects = objects{
                        if var spotsFromParse = objects as? [TuneSpot]{
                            spotsFromParse = spotsFromParse.map({ (spot) -> TuneSpot in
                                spot.isSpotExisted = true
                                return spot
                            })
                            spotsFromParse = spotsFromParse.map({ (spot) -> TuneSpot in
                                spot.isSpotExisted = true
                                return spot
                            })
                            completionHandler(spotsFromParse)
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
    
    static func searchNearbyTuneSpotInclusive(query: String, completionHandler: @escaping ([TuneSpot]?) -> Void){
        //combine parse and foursquare api
        TuneSpot.searchNearbyTuneSpot(query: query) { (spotsFromParse) in
            let spotsFromParse = spotsFromParse ?? []
            FoursquareClient.searchNearByLocation(query: query, success: { (spotsFromFourSquare) in
                //filtered out the spot already in parse database
                let filteredSpot = spotsFromFourSquare.filter({ (spot) -> Bool in
                    return !spotsFromParse.contains(spot)
                })
                let resultSpot = spotsFromParse + filteredSpot
                completionHandler(resultSpot)

            })
        }
    }
}

        
extension TuneSpot: PFSubclassing{
    static func parseClassName() -> String {
        return ClassName
    }
}
