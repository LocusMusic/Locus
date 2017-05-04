//
//  Tracks.swift
//  Spottunes
//
//  Created by Xie kesong on 5/3/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import Foundation


fileprivate let HrefKey = "href"
fileprivate let TotalKey = "url"
fileprivate let ItemsKey = "items"
fileprivate let TrackKey = "track"



/*
 href = "https://api.spotify.com/v1/users/taylordiem1025/playlists/1y5Xvya1yqXOMpF6ErmExv/tracks";
 total = 736;
 */

class Tracks{
    var dict: [String: Any]!
    var href: String{
        return self.dict[HrefKey] as! String
    }
    
    var total: Int!{
        return self.dict[TotalKey] as! Int
    }
    
    var trackList: [Track]?{
        guard let itemsDict = self.dict[ItemsKey] as? [[String: Any]] else{
            return nil
        }
        let tracks = itemsDict.map { (itemDict) -> Track in
            let trackDict = itemDict[TrackKey] as! [String : Any]
            return Track(dict: trackDict)
        }
        return tracks
    }
    
    
    
    
    init(dict: [String: Any]) {
        self.dict = dict
    }
}
