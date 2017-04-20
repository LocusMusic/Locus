//
//  User.swift
//  Spottunes
//
//  Created by Xie kesong on 4/19/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import Parse

fileprivate  let spotifyIdKey = "spotifyId"
let className = "_User"

class User: PFObject{
    var spotifyId:String?{
        return self[spotifyIdKey] as? String
    }
    class func register(spotifyId: String){
        let user = PFObject(className: "User")
        user[spotifyIdKey] = spotifyId
        user.saveInBackground { (succeed, error) in
            print(succeed)
        }
        
    }
    
    class func doesExist(spotifyId: String, completionHandler: @escaping (_ exitsed: Bool) -> Void ){
        let query = PFQuery(className: className)
        query.whereKeyExists(spotifyIdKey)
        query.findObjectsInBackground { (response, error) in
            
            if let objects = response,  objects.count > 0 {
                completionHandler(true)
            }else{
                completionHandler(false)
            }
        }
        
    }
    
}
