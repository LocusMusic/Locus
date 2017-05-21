//
//  Locus
//
//  Created by Xie kesong on 4/15/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import Foundation
import Parse


//the value is the same as the actual key for Spotify
fileprivate let IdKey = "id"
fileprivate let ImagesKey = "images"
fileprivate let NameKey = "name"
fileprivate let OwnerKey = "owner"
fileprivate let TracksKey = "tracks"
fileprivate let FollowersKey = "followers"
fileprivate let TotalFollowersKey = "total"

class Playlist: PFObject {

    //the spotify representation
    var dict: [String: Any]!
    
    init(dict: [String: Any]) {
        super.init()
        self.dict = dict
    }

    var owner: User?
    
    var spot: Spot?
    
    var spotifyId: String!{
        return self.dict[IdKey] as! String
    }
    
//    var followers: Int {
//        print(self.dict)
//        
//        guard let followersDict = self.dict[FollowersKey] as? [String: Any] else {
//            print("PLAYLIST FOLLOWERS FAIL")
//            return -1
//        }
//        return followersDict[TotalFollowersKey] as! Int
//    }
    
    private var images: [Image]?{
        guard let imagesDict = self.dict[ImagesKey] as? [[String: Any]] else{
            return nil
        }
        let images = imagesDict.map { (imageDict) -> Image in
            return Image(dict: imageDict)
        }
        return images
    }
    
    var name: String?{
        return self.dict[NameKey] as? String
    }
    
    var ownerId: String?{
        if let ownerDict = self.dict[OwnerKey] as? [String: Any]{
            return Owner(dict: ownerDict).id
        }
        return nil
    }
    
    
    var tracks: Tracks?{
        guard let tracksDict = self.dict[TracksKey] as? [String: Any] else{
            return nil
        }
        return Tracks(dict: tracksDict)
    }
    
    var trackCount: Int?{
        return self.tracks?.total ?? 0
    }
    
    var trackCountString: String?{
        if let trackCount = self.trackCount{
            return "\(trackCount) Song" + ((trackCount > 1) ? "s" : "")
        }
        return "0 Song"
    }
    
    
    
    func savePlaylist(){
        if let id = self.spotifyId{
            self[IdKey] = id
            self.saveInBackground { (succeed, error) in
                print("saved \(succeed)")
            }
        }else{
            print("id is nil")
        }
    }
    
    func getCoverImage(withSize size: CoverSize) -> Image?{
        return self.images?.first
    }
    
//    func getGenre(){
//        if let tracks = self.tracks?.trackList{
//            print("track is not inil")
//            for track in tracks{
//                print(track.album)
//            }
//        }else{
//            print("track list is nil")
//        }
//    }
    
    
}

    
extension Playlist: PFSubclassing {
    static func parseClassName() -> String {
        return "Playlist"
    }
}
