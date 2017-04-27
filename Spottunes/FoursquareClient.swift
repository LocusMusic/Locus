//
//  FoursquareClient.swift
//  Spottunes
//
//  Created by Huang Edison on 4/20/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit
import CoreLocation

fileprivate let CLIENT_ID = "1KQIXCE5TKJEOJW5MYZY25NZNTCRT2LHOYGL4YP2QCZWSDNF"
fileprivate let CLIENT_SECRET = "FIHIW2HW0ZJBU0ODD2YNWWA1UJPENZSJ24TLP2G3VQGDPPWF"

class FoursquareClient: NSObject {
    
    static let sharedInstance = FoursquareClient()
    let exploreBaseURL = "https://api.foursquare.com/v2/venues/explore?"
    let clientString = "client_id=\(CLIENT_ID)&client_secret=\(CLIENT_SECRET)"
    
    let limit = 30
    var offset = 0
    
    func getRecommendedPlaces(ll: CLLocationCoordinate2D, success: @escaping ([Location]) -> ()){
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
                    let items = self.getItemsByType(type: "Recommended Places", groups: groups!)
                    let locations = Location.locationsWithArray(items: items)
                    //print(locations)
                    success(locations)
                    self.offset += self.limit
                }
            }
        });
        task.resume()
    }
    
    func getMoreRecommendedPlaces(ll: CLLocationCoordinate2D, success: @escaping ([Location]) -> ()){
        getRecommendedPlaces(ll: ll, success: success)
    }
    
    private func getCurDateString() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: Date())
    }
    
    private func getItemsByType(type: String, groups: [NSDictionary]) -> [NSDictionary]{
        for group in groups{
            let group_type = group["type"] as? String
            if group_type == type {
                return group["items"] as! [NSDictionary]
            }
        }
        return []
    }
    
}
