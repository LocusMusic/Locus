//
//  Owner.swift
//  Locus
//
//  Created by Xie kesong on 5/13/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import Foundation

fileprivate let TypeKey = "name"
fileprivate let IdKey = "id"
fileprivate let HrefKey = "href"
fileprivate let URIKey = "uri"

/*
 "owner" : {
 "external_urls" : {
 "spotify" : "http://open.spotify.com/user/12125995664"
 },
 "href" : "https://api.spotify.com/v1/users/12125995664",
 "id" : "12125995664",
 "type" : "user",
 "uri" : "spotify:user:12125995664"
 },
 */
class Owner {
    var href: String{
        return self.dict[HrefKey] as! String
    }
    
    var id: String!{
        return self.dict[IdKey] as! String
    }
    
    var type: String?{
        return self.dict[TypeKey] as? String
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

