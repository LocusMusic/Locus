//
//  User.swift
//  Spottunes
//
//  Created by Xie kesong on 4/19/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import Parse

fileprivate let spotifyIdKey = "spotifyId"
fileprivate let className = "User"

class User: PFObject {
    
    var spotifyId : String? {
        return self[spotifyIdKey] as? String
    }
    
    var name: String?
    
    var avatorURL: String?
    
    //    init(name: String, avatorURL: String) {
    //        super.init()
    //        self.name = name
    //        self.avatorURL = avatorURL
    //    }
    //
    //
    
    static var currentUser: User?
   
    static func getCurrentUser(completionHandler: @escaping (_ user: User?) -> Void){
        let query = PFQuery(className: className)
        query.fromLocalDatastore()
        query.getFirstObjectInBackground { (userObject, error) in
            completionHandler(userObject as? User)
        }
    }
    
    
    func saveCurrentUserToDisk(completionHandler: @escaping PFBooleanResultBlock){
        self.pinInBackground(block: completionHandler)
    }
    
   
    class func fetchUserByUsername(username: String, completionHandler: @escaping (User?) -> Void){
        let query = PFQuery(className: className)
        query.whereKey(spotifyIdKey, equalTo: username)
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
        user[spotifyIdKey] = spotifyId
        user.saveInBackground(block: completionHandler)
    }
    
    //Check if the current session user exists in Parse
    class func doesExist(spotifyId: String, completionHandler: @escaping (_ exists: Bool) -> Void ) {
        let query = PFQuery(className: className)
        query.whereKey(spotifyIdKey, equalTo: spotifyId)
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
