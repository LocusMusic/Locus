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
fileprivate let GenresKey = "genres"
fileprivate let IdKey = "id"
fileprivate let HrefKey = "href"
fileprivate let URIKey = "uri"
fileprivate let FollowersKey = "followers"
fileprivate let TotalFollowersKey = "total"
fileprivate let ImagesKey = "images"

class Artist {
    
    //the spotify representation
    var dict: [String: Any]!
    
    init(dict: [String: Any]) {
        self.dict = dict
    }

    
    var followers: Int {
        guard let followersDict = self.dict[FollowersKey] as? [String: Any] else {
            return 0
        }
        return followersDict[TotalFollowersKey] as! Int
    }
    
    var genres: Array<Any> {
        return self.dict[GenresKey] as! Array
    }
    
    var href: String {
        return self.dict[HrefKey] as! String
    }
    
    var id: String! {
        return self.dict[IdKey] as! String
    }
    
    var images: [Image]? {
        guard let imagesDict = self.dict[ImagesKey] as? [[String: Any]] else {
            return nil
        }
        let images = imagesDict.map { (imageDict) -> Image in
            return Image(dict: imageDict)
        }
        return images
    }
    
    func getArtistImage(withSize size: CoverSize) -> Image? {
        let imagesCount = self.images?.count ?? 0
        guard imagesCount - 1 >= size.hashValue else {
            return nil
        }
        if let coverImage = self.images?[size.hashValue] {
            return coverImage
        } else {
            return self.images?.first
        }
    }
    
    var name: String? {
        return self.dict[NameKey] as? String
    }
    
    var uri: String? {
        return self.dict[URIKey] as? String
    }
    
}

