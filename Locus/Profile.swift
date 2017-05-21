//
//  Profile.swift
//  Locus
//
//  Created by Xie kesong on 5/13/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import Foundation

/*
 {
 "display_name" : "Lilla Namo",
 "external_urls" : {
 "spotify" : "https://open.spotify.com/user/tuggareutangranser"
 },
 "followers" : {
 "href" : null,
 "total" : 4561
 },
 "href" : "https://api.spotify.com/v1/users/tuggareutangranser",
 "id" : "tuggareutangranser",
 "images" : [ {
 "height" : null,
 "url" : "http://profile-images.scdn.co/artists/default/d4f208d4d49c6f3e1363765597d10c4277f5b74f",
 "width" : null
 } ],
 "type" : "user",
 "uri" : "spotify:user:tuggareutangranser"
 }
 */

fileprivate let ImagesKey = "images"
fileprivate let IdKey = "id"
fileprivate let DisplayNmaekey = "display_name"


class Profile {
    var image: Image?{
        if let imageDict = (self.dict[ImagesKey] as? [[String: Any]])?.first{
            return Image(dict: imageDict)
        }
        return nil
    }
    
    var id: String!{
        return self.dict[IdKey] as! String
    }
    
    var displayName: String?{
        return self.dict[DisplayNmaekey] as? String
    }
    
    //the spotify representation
    var dict: [String: Any]!
    
    init(dict: [String: Any]) {
        self.dict = dict
    }
}
