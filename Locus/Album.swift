//
//  Album.swift
//  Locus
//
//  Created by Xie kesong on 5/3/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import Foundation



//api reference
//https://developer.spotify.com/web-api/get-playlists-tracks/

/*
 "album" : {
 "album_type" : "single",
 "artists" : [ {
 "external_urls" : {
 "spotify" : "https://open.spotify.com/artist/21451j1KhjAiaYKflxBjr1"
 },
 "href" : "https://api.spotify.com/v1/artists/21451j1KhjAiaYKflxBjr1",
 "id" : "21451j1KhjAiaYKflxBjr1",
 "name" : "Zion & Lennox",
 "type" : "artist",
 "uri" : "spotify:artist:21451j1KhjAiaYKflxBjr1"
 } ],
 "available_markets" : [ "AD", "AR", "AT", "AU", "BE", "BG", "BO", "BR", "CA", "CH", "CL", "CO", "CR", "CY", "CZ", "DE", "DK", "DO", "EC", "EE", "ES", "FI", "FR", "GB", "GR", "GT", "HK", "HN", "HU", "ID", "IE", "IS", "IT", "JP", "LI", "LT", "LU", "LV", "MC", "MT", "MX", "MY", "NI", "NL", "NO", "NZ", "PA", "PE", "PH", "PL", "PT", "PY", "SE", "SG", "SK", "SV", "TR", "TW", "UY" ],
 "external_urls" : {
 "spotify" : "https://open.spotify.com/album/5GjKG3Y8OvSVJO55dQTFyD"
 },
 "href" : "https://api.spotify.com/v1/albums/5GjKG3Y8OvSVJO55dQTFyD",
 "id" : "5GjKG3Y8OvSVJO55dQTFyD",
 "images" : [ {
 "height" : 640,
 "url" : "https://i.scdn.co/image/b16064142fcd2bd318b08aab0b93b46e87b1ebf5",
 "width" : 640
 }, {
 "height" : 300,
 "url" : "https://i.scdn.co/image/9f05124de35d807b78563ea2ca69550325081747",
 "width" : 300
 }, {
 "height" : 64,
 "url" : "https://i.scdn.co/image/863c805b580a29c184fc447327e28af5dac9490b",
 "width" : 64
 } ],
 "name" : "Otra Vez (feat. J Balvin)",
 "type" : "album",
 "uri" : "spotify:album:5GjKG3Y8OvSVJO55dQTFyD"
 },
 */

fileprivate let ImagesKey = "images"
fileprivate let NameKey = "name"
fileprivate let IdKey = "id"
fileprivate let HrefKey = "href"
fileprivate let TrackKey = "track"
fileprivate let ArtistsKey = "artists"
fileprivate let GenresKey = "genres"

class Album {
    
    var owner: User?
    
    var spot: Spot?
    
    var href: String{
        return self.dict[HrefKey] as! String
    }

    var id: String!{
        return self.dict[IdKey] as! String
    }
    
    var name: String?{
        return self.dict[NameKey] as? String
    }
    
    var genres: [String]?{
        return self.dict[GenresKey] as? [String]
    }
    
    var artists: [Artist]?{
        guard let artistsDict = self.dict[ArtistsKey] as? [[String: Any]] else{
            return nil
        }
        let artists = artistsDict.map { (artistdict) -> Artist in
            return Artist(dict: artistdict)
        }
        return artists
    }

    private var images: [Image]?{
        guard let imagesDict = self.dict[ImagesKey] as? [[String: Any]] else{
            return nil
        }
        let images = imagesDict.map { (imageDict) -> Image in
            return Image(dict: imageDict)
        }
        return images
    }
    
   
    //the spotify representation
    var dict: [String: Any]!
    
    init(dict: [String: Any]) {
        self.dict = dict
    }
    
    
    func getCoverImage(withSize size: CoverSize) -> Image?{
        let imagesCount = self.images?.count ?? 0
        guard imagesCount - 1 >= size.hashValue else{
            return nil
        }
        if let coverImage = self.images?[size.hashValue] {
            return coverImage
        }else{
            return self.images?.first
        }
    }
    
}

