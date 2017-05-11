//
//  Post.swift
//  Spottunes
//
//  Created by Kesong Xie on 5/9/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import Foundation
import Parse

fileprivate let ClassName = "Post"
fileprivate let SpotKey = "spot"
fileprivate let UserKey = "user"
fileprivate let PlaylistIdKey = "playlistId"
fileprivate let TypeKey = "type" //reserve for later use, 0 for Spotify playlist

class PlaylistPost: PFObject {
    var user: User?
    var spot: TuneSpot?
    var playlistId: String?
    var type: Int?
    
    func share(type: Int? = 0, result: @escaping PFBooleanResultBlock){
        //check whether the spot existed or not
        //save spot first if not
        guard let spot = self.spot else{
            return
        }
        
        if let existed = spot.isSpotExisted, existed{
            //no need to create
        }else{
            //need to create a new spot first before adding a post
            //check whether existed
            
            
        }

        
        
        
        guard let user = self.user else{
            return
        }
        
        guard let playlistId = self.playlistId else{
            return
        }
        
        guard let type = type else{
            return
        }
        
        self[SpotKey] = spot
        self[UserKey] = user
        self[PlaylistIdKey] = playlistId
        self[TypeKey] = type
        self.saveInBackground(block: result)
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
