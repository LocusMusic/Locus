//
//  Artist.swift
//  Spottunes
//
//  Created by Xie kesong on 5/3/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import Foundation

/*
 artist {
 "external_urls" : {
 "spotify" : "https://open.spotify.com/artist/21451j1KhjAiaYKflxBjr1"
 },
 "href" : "https://api.spotify.com/v1/artists/21451j1KhjAiaYKflxBjr1",
 "id" : "21451j1KhjAiaYKflxBjr1",
 "name" : "Zion & Lennox",
 "type" : "artist",
 "uri" : "spotify:artist:21451j1KhjAiaYKflxBjr1"
 }
 */

fileprivate let NameKey = "name"
fileprivate let IdKey = "id"
fileprivate let HrefKey = "href"
fileprivate let URIKey = "uri"

class Artist {
    var href: String{
        return self.dict[HrefKey] as! String
    }
    
    var id: String!{
        return self.dict[IdKey] as! String
    }
    
    var name: String?{
        return self.dict[NameKey] as? String
    }
    
    var uri: String?{
        return self.dict[URIKey] as? String
    }
    
    //the spotify representation
    var dict: [String: Any]!
    
    init(dict: [String: Any]) {
        self.dict = dict
    }
}

