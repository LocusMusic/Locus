//
//  FoursquareClient.swift
//  Spottunes
//
//  Created by Huang Edison on 4/20/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

fileprivate let CLIENT_ID = "1KQIXCE5TKJEOJW5MYZY25NZNTCRT2LHOYGL4YP2QCZWSDNF"
fileprivate let CLIENT_SECRET = "FIHIW2HW0ZJBU0ODD2YNWWA1UJPENZSJ24TLP2G3VQGDPPWF"

class FoursquareClient: NSObject {
    
    static let shared = FoursquareClient()
    let exploreBaseURL = "https://api.foursquare.com/v2/venues/explore?"
    let searchBaseURL = "https://api.foursquare.com/v2/venues/search?"
    let clientString = "client_id=\(CLIENT_ID)&client_secret=\(CLIENT_SECRET)"
    
    let limit = 10
    var offset = 0
    
    func fetchRecommendedPlaces(ll: CLLocationCoordinate2D, success: @escaping ([Location]) -> ()){
        let ll_string = "&ll=\(ll.latitude),\(ll.longitude)"
        let date_string = "&v="+getCurDateString()
        let limit_offset = "&limit=\(limit)&offset=\(offset)"
        let queryString = exploreBaseURL+clientString+ll_string+date_string+limit_offset
        let url = URL(string: queryString)!
        let request = URLRequest(url: url)
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: { (maybeData, response, error) in
            if let data = maybeData {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    let groups = (responseDictionary["response"] as! NSDictionary)["groups"] as? [NSDictionary]
                    let venues = self.getVenuesByType(type: "Recommended Places", groups: groups!)
                    let locations = Location.locationsWithArray(venues: venues)
                    //print(locations)
                    success(locations)
                    self.offset += self.limit
                }
            }
        });
        task.resume()
    }
    
    func fetchMoreRecommendedPlaces(ll: CLLocationCoordinate2D, success: @escaping ([Location]) -> ()){
        fetchRecommendedPlaces(ll: ll, success: success)
    }
    
    func searchNearByLocation(query: String, success: @escaping ([Location])->()){
        PFGeoPoint.geoPointForCurrentLocation { (point, error) in
            if let geoPoint = point{
                let coordinate = CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
                self.fetchSearchPlacesResult(query, ll: coordinate, success: success)
            }else{
                print("search nearby failed")
            }
        }
    }
    
    func fetchSearchPlacesResult(_ query: String, ll: CLLocationCoordinate2D, success: @escaping ([Location]) -> ()){
        let ll_string = "&ll=\(ll.latitude),\(ll.longitude)"
        let date_string = "&v="+getCurDateString()
        //let limit_offset = "&limit=\(limit)&offset=\(offset)"
        let query_string = "&query=\(query)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url_string = searchBaseURL+clientString+ll_string+date_string+query_string! //+limit_offset
        let url = URL(string: url_string)!
        let request = URLRequest(url: url)
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: { (maybeData, response, error) in
            if let data = maybeData {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    let venues = responseDictionary.value(forKeyPath: "response.venues") as? [NSDictionary]
                    let locations = Location.locationsWithArray(venues: venues!)
                    //print(locations)
                    success(locations)
                    //self.offset += self.limit
                }
            }
        });
        task.resume()
    }
    
    
    private func getCurDateString() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: Date())
    }
    
    private func getVenuesByType(type: String, groups: [NSDictionary]) -> [NSDictionary]{
        for group in groups{
            let group_type = group["type"] as? String
            if group_type == type {
                return group.value(forKeyPath: "items.venue") as! [NSDictionary]
            }
        }
        return []
    }
    
}
