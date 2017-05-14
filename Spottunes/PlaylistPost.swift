//
//  Post.swift
//  Spottunes
//
//  Created by Kesong Xie on 5/9/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import Foundation
import Parse

fileprivate let ClassName = "PlaylistPost"
fileprivate let SpotKey = "spot"
fileprivate let UserKey = "user"
fileprivate let PlaylistIdKey = "playlistId"
fileprivate let TypeKey = "type" //reserve for later use, 0 for Spotify playlist

class PlaylistPost: PFObject {
    var user: User?
    var spot: TuneSpot?
    var playlistId: String?
    var type: Int = 0
    
    func share(completionHandler: @escaping PFBooleanResultBlock){
        //check whether the spot existed or not
        //save spot first if not
        guard let spot = self.spot else{
            return
        }
        
        if let existed = spot.isSpotExisted, existed{
            //no need to create
            self.savePlaylistToSpot(spot: spot, completionHandler: completionHandler)
        }else{
            //create new one
            spot.saveTuneSpot(completionHandler: { (succeed, error) in
                if succeed{
                   self.savePlaylistToSpot(spot: spot, completionHandler: completionHandler)
                }
                completionHandler(false, nil)
            })
        }
    }
    
    func savePlaylistToSpot(spot: TuneSpot, completionHandler: @escaping PFBooleanResultBlock){
        user?.addRecentVisitSpot(spot: spot, completionHandler: { (succeed, error) in
            if succeed{
                print("successfully added recently visited")
                guard let user = self.user else{
                    return
                }
                guard let playlistId = self.playlistId else{
                    return
                }
                self[SpotKey] = spot
                self[UserKey] = user
                self[PlaylistIdKey] = playlistId
                self[TypeKey] = self.type
                self.saveInBackground(block: completionHandler)
            }else{
                completionHandler(false, nil)
            }
        })
    }
    
    init(user: User, spot: TuneSpot, playlistId: String) {
        super.init()
        self.user = user
        self.spot = spot
        self.playlistId = playlistId
    }
}


extension PlaylistPost: PFSubclassing {
    static func parseClassName() -> String {
        return ClassName
    }
}
