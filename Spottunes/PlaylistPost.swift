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
fileprivate let LikeUsersKey = "likeUsers"

fileprivate let TypeKey = "type" //reserve for later use, 0 for Spotify playlist

class PlaylistPost: PFObject {
    
    var user: User?{
        get{
            return self[UserKey] as? User
        }
        set{
        
        }
    }
    
    var spot: TuneSpot?{
        get{
            return self[SpotKey] as? TuneSpot
        }
        set{
        }
    }
    
    var playlistId: String?{
        get{
            return self[PlaylistIdKey] as? String
        }
        set{
            
        }
    }
    
    var playlist: Playlist?
    
    var type: Int?{
        get{
            return self[TypeKey] as? Int
        }
        set {
            
        }
    }
    
    var isFavored: Bool? {
        guard let currentUser = App.delegate?.currentUser else {
            return nil
        }
        return self.likeUsers?.contains(currentUser)
    }
    
    var likeUsers: [User]? {
        get {
            return self[LikeUsersKey] as! [User]
        }
        set (newValue){
            print("new users are ")
            self[LikeUsersKey] = newValue

        }
    }
    
    class func shareAllToSpot(playlistPosts: [PlaylistPost], spot: TuneSpot, completionHandler: @escaping PFBooleanResultBlock){
        //check whether the spot existed or not
        //save spot first if not
        
        if let existed = spot.isSpotExisted, existed{
            //no need to create
            App.delegate?.currentUser?.addRecentVisitSpot(spot: spot, completionHandler: { (succeed, error) in
                if succeed{
                    print("existing recent spot added succeed")
                    PlaylistPost.saveAll(inBackground: playlistPosts, block: completionHandler)
                }else{
                    print("existing recent spot added failed")
                }
            })
        }else{
            //create new spot first
            spot.saveTuneSpot(completionHandler: { (succeed, error) in
                if succeed{
                    App.delegate?.currentUser?.addRecentVisitSpot(spot: spot, completionHandler: { (succeed, error) in
                        if succeed{
                            print("existing recent spot added succeed")
                            PlaylistPost.saveAll(inBackground: playlistPosts, block: completionHandler)
                        }else{
                            print("existing recent spot added failed")
                        }
                    })
                }
                completionHandler(false, nil)
            })
        }
    }
    
//    func savePlaylistToSpot(spot: TuneSpot, completionHandler: @escaping PFBooleanResultBlock){
//        user?.addRecentVisitSpot(spot: spot, completionHandler: { (succeed, error) in
//            if succeed{
//                print("successfully added recently visited")
//                guard let user = self.user else{
//                    return
//                }
//                guard let playlistId = self.playlistId else{
//                    return
//                }
//                self[SpotKey] = spot
//                self[UserKey] = user
//                self[PlaylistIdKey] = playlistId
//                self[TypeKey] = self.type
//                self.saveInBackground(block: completionHandler)
//            }else{
//                completionHandler(false, nil)
//            }
//        })
//    }
    
    class func fetchPlaylistPostInSpot(spot: TuneSpot, completionHandler: @escaping ([PlaylistPost]?) -> Void){
        let query = PFQuery(className: ClassName)
        query.whereKey(SpotKey, equalTo: spot)
        query.includeKey(UserKey)
        query.findObjectsInBackground { (objects, error) in
            if let playlistPosts = objects as? [PlaylistPost]{
                let resultSortedList = playlistPosts.sorted(by: { (post_1, post_2) -> Bool in
                    return post_1.likeUsers!.count > post_2.likeUsers!.count
                })
                completionHandler(resultSortedList)
            }else{
                completionHandler(nil)
            }
        }
    }
    
    func fetchPlaylist(completionHandler: @escaping (Playlist) -> Void){
        
    }
    
    override init() {
        super.init()
    }
    
    init(user: User, spot: TuneSpot, type: Int? = 0, likeUser: [User]? = [],  playlistId: String) {
        super.init()
        self[UserKey] = user
        self[SpotKey] = spot
        self[TypeKey] = type
        self[LikeUsersKey] = likeUser
        self[PlaylistIdKey] = playlistId
    }
}


extension PlaylistPost: PFSubclassing {
    static func parseClassName() -> String {
        return ClassName
    }
}
