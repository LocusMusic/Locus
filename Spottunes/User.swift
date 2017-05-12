//
//  User.swift
//  Spottunes
//
//  Created by Xie kesong on 4/19/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import Parse

fileprivate let SpotifyIdKey = "spotifyId"
fileprivate let RecentlyVisitedSpotKey = "recentlyVisitedSpot"
fileprivate let className = "User"

class User: PFObject {
    
    var spotifyId : String? {
        return self[SpotifyIdKey] as? String
    }
    
    var recentlyVisitedSpot: [TuneSpot]?{
        get{
            return self[RecentlyVisitedSpotKey] as? [TuneSpot]
        }
        set{
            
        }
    }
   
    static func getCurrentUser(completionHandler: @escaping (_ user: User?) -> Void){
        let query = PFQuery(className: className)
        query.fromLocalDatastore()
        query.includeKey(RecentlyVisitedSpotKey)

        query.getFirstObjectInBackground { (userObject, error) in
            completionHandler(userObject as? User)
        }
    }
    
    func addRecentVisitSpot(spot: TuneSpot ,completionHandler: @escaping PFBooleanResultBlock){
        let newRecentSpot = [spot] + (self.recentlyVisitedSpot ?? [TuneSpot]())
        self.recentlyVisitedSpot = newRecentSpot
        self[RecentlyVisitedSpotKey] = newRecentSpot
        self.saveCurrentUserToDisk { (suceed, error) in
            if suceed{
                self.saveInBackground(block: completionHandler)
            }else{
                completionHandler(false, nil)
            }
        }
    }
    
    
    func saveCurrentUserToDisk(completionHandler: @escaping PFBooleanResultBlock){
        self.pinInBackground(block: completionHandler)
    }
    
   
    class func fetchUserByUsername(username: String, completionHandler: @escaping (User?) -> Void){
        let query = PFQuery(className: className)
        query.whereKey(SpotifyIdKey, equalTo: username)
        query.includeKey(RecentlyVisitedSpotKey)
        query.getFirstObjectInBackground { (object, error) in
            if let user = object as? User{
                completionHandler(user)
            }else{
                completionHandler(nil)
            }
        }
    }
    
    //Create a user and save it to Parse
    class func register(spotifyId: String, completionHandler: @escaping  PFBooleanResultBlock) {
        let user = PFObject(className: className)
        user[SpotifyIdKey] = spotifyId
        user.saveInBackground(block: completionHandler)
    }
    
    //Check if the current session user exists in Parse
    class func doesExist(spotifyId: String, completionHandler: @escaping (_ exists: Bool) -> Void ) {
        let query = PFQuery(className: className)
        query.whereKey(SpotifyIdKey, equalTo: spotifyId)
        query.findObjectsInBackground { (response, error) in
            if let objects = response, objects.count > 0 {
                print("USER EXISTS")
                completionHandler(true)
            } else {
                print("USER DOESNT EXIST")
                completionHandler(false)
            }
        }
    }
}

extension User: PFSubclassing {
    static func parseClassName() -> String {
        return className
    }
}
