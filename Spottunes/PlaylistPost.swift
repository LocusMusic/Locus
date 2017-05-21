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
        guard let currentUser = User.current() else {
            return nil
        }
        return self.likeUsers?.contains(currentUser)
    }
    
    var likeUsers: [User]? {
        get {
            return self[LikeUsersKey] as? [User]
        }
        set (newValue){
            self[LikeUsersKey] = newValue
        }
    }
    
    //get a list of listener list who contributed a playlist post in a given spot sorted by 
    //the the number of likes they received
    class func fetchListenersListBasedOnFavoredCount(forSpot spot: TuneSpot, completionHandler: @escaping ([(key: User, value: Int)]?) -> Void){
        let query = PFQuery(className: ClassName)
        query.whereKey(SpotKey, equalTo: spot)
        query.includeKey(UserKey)
        query.includeKey(SpotKey)
        query.includeKey(LikeUsersKey)
        //the userlistDict conatins the user as the key, and the favor count he or she receives
        //as the value
        var userlistDict = [User: Int]()
        query.findObjectsInBackground { (objects, erorr) in
            if let playlistPosts = objects as? [PlaylistPost]{
                for post in playlistPosts{
                    guard let user = post.user else{
                        break
                    }
                    if let favorCount = userlistDict[user]{
                        //already existed
                        userlistDict[user] = favorCount + (post.likeUsers?.count ?? 0)
                    }else{
                        //havn't existed
                        userlistDict[user] = (post.likeUsers?.count ?? 0)
                    }
                }
                let sortedUserListDict = userlistDict.sorted { (pair_1: (user_1: User, favor_count_1: Int), pair_2: (user_2: User, favor_count_2: Int)) -> Bool in
                    return pair_1.favor_count_1 > pair_2.favor_count_2
                }
                print(sortedUserListDict)
                completionHandler(sortedUserListDict)
            }
        }
    }
    
    
    class func shareAllToSpot(playlistPosts: [PlaylistPost], spot: TuneSpot, completionHandler: @escaping PFBooleanResultBlock){
        //check whether the spot existed or not
        //save spot first if not
        guard let currentUser = User.current() else{
            print("curent user si nil from shareAllToSpot in playlistPost.swift")
            return
        }
        
        if let existed = spot.isSpotExisted, existed{
            //no need to create
                currentUser.addRecentVisitSpot(spot: spot, completionHandler: { (succeed, error) in
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
                    currentUser.addRecentVisitSpot(spot: spot, completionHandler: { (succeed, error) in
                        if succeed{
                            print("existing recent spot added succeed")
                            PlaylistPost.saveAll(inBackground: playlistPosts, block: completionHandler)
                        }else{
                            print("existing recent spot added failed")
                        }
                    })
                }else{
                    completionHandler(false, nil)
                }
            })
        }
    }
    

    //fetch all the playlist post in a given spot
    class func fetchPlaylistPostInSpot(spot: TuneSpot, completionHandler: @escaping ([PlaylistPost]?) -> Void){
        let query = PFQuery(className: ClassName)
        query.whereKey(SpotKey, equalTo: spot)
        query.includeKey(UserKey)
        query.includeKey(LikeUsersKey)
        query.includeKey(SpotKey)
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
