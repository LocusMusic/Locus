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
    
    init(name: String, avatorURL: String) {
        super.init()
        self.name = name
        self.avatorURL = avatorURL
    }
    
    //Create a user and save it to Parse
    class func register(spotifyId: String) {
        let user = PFObject(className: className)
        user[spotifyIdKey] = spotifyId
        user.saveInBackground { (succeed, error) in
            print(succeed)
        }
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
