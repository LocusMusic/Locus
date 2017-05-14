//
//  Artists.swift
//  Spottunes
//
//  Created by Leo Wong on 5/13/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

fileprivate let HrefKey = "href"
fileprivate let TotalKey = "total"
fileprivate let ItemsKey = "items"
fileprivate let ArtistKey = "artist"
fileprivate let NextKey = "next"

class Artists {
    
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
    
    var artistList: [Artist]? {
        guard let itemsDict = self.dict[ItemsKey] as? [[String: Any]] else{
            return nil
        }
        let artists = itemsDict.map { (itemDict) -> Artist in
            if let artistDict = itemDict[ArtistKey] as? [String : Any] {
                return Artist(dict: artistDict)
            } else {
                return Artist(dict: itemDict)
            }
        }
        return artists
    }
}
