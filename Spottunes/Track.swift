//
//  Track.swift
//  Spottunes
//
//  Created by Xie kesong on 5/3/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import Foundation

//api reference
//https://developer.spotify.com/web-api/get-playlists-tracks/

/*
 "track" : {
 "album" : {}
 artists: {}
 "external_urls" : {
 "spotify" : "https://open.spotify.com/track/7pk3EpFtmsOdj8iUhjmeCM"
 },
 "href" : "https://api.spotify.com/v1/tracks/7pk3EpFtmsOdj8iUhjmeCM",
 "id" : "7pk3EpFtmsOdj8iUhjmeCM",
 "name" : "Otra Vez (feat. J Balvin)",
 "popularity" : 85,
 "preview_url" : "https://p.scdn.co/mp3-preview/79c8c9edc4f1ced9dbc368f24374421ed0a33005",
 "track_number" : 1,
 "type" : "track",
 "uri" : "spotify:track:7pk3EpFtmsOdj8iUhjmeCM"
 */

fileprivate let URIKey = "uri"
fileprivate let IdKey = "id"
fileprivate let NameKey = "name"
fileprivate let TrackKey = "track"
fileprivate let AlbumKey = "album"
fileprivate let ArtistsKey = "artists"
fileprivate let ImagesKey = "images"



class Track{
    var dict: [String: Any]!
    var uri: String?{
        return self.dict[URIKey] as? String
    }
    
    var id: String!{
        return self.dict[IdKey] as! String
    }

    var album: Album?{
        guard let albumDict = self.dict[AlbumKey] as? [String: Any] else{
            return nil
        }
        return Album(dict: albumDict)
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

    func getCoverImage(withSize size: CoverSize) -> Image?{
        return self.album?.getCoverImage(withSize: size)
        
    }

    
    
    var name: String?{
        return self.dict[NameKey] as? String
    }

    init(dict: [String: Any]) {
        self.dict = dict
    }
}
