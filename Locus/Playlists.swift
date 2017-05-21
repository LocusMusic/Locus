//
//  Playlists.swift
//  Locus
//
//  Created by Leo Wong on 5/14/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

fileprivate let HrefKey = "href"
fileprivate let TotalKey = "total"
fileprivate let ItemsKey = "items"
fileprivate let PlaylistKey = "playlist"
fileprivate let NextKey = "next"

class Playlists {
    
    var dict: [String: Any]!
    
    init(dict: [String: Any]) {
        self.dict = dict
    }
    
    var href: String {
        return self.dict[HrefKey] as! String
    }
    
    var next: String {
        return self.dict[NextKey] as! String
    }
    
    var total: Int! {
        return self.dict[TotalKey] as! Int
    }
    
    var playlists: [Playlist]? {
        guard let itemsDict = self.dict[ItemsKey] as? [[String: Any]] else{
            return nil
        }
        let playlists = itemsDict.map { (itemDict) -> Playlist in
            if let playlistDict = itemDict[PlaylistKey] as? [String : Any] {
                return Playlist(dict: playlistDict)
            } else {
                return Playlist(dict: itemDict)
            }
        }
        return playlists
    }
    

    

}
