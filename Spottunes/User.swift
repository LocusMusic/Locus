//
//  User.swift
//  Spottunes
//
//  Created by Xie kesong on 4/19/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import Parse

fileprivate let className = "User"
fileprivate let SpotifyIdKey = "spotifyId"
fileprivate let RecentlyVisitedSpotKey = "recentlyVisitedSpot"
fileprivate let ProfileImageKey = "profileImage"
fileprivate let DisplayNameKey = "displayName"
fileprivate let CurrentListeningPlaylistPostKey = "currentListeningPlaylistPost"
fileprivate let CurrentActiveTrackIndexKey = "currentActiveTrackIndex"
fileprivate let InstallationKey = "installation"
//the value for UsernameKey is the same as the value for SpotifyIdKey
fileprivate let UsernameKey = "username"
fileprivate let PasswordKey = "password"
//CredentialTypeKey, default 0, means spotify
fileprivate let CredentialTypeKey = "credentialType"



class User: PFUser {
    
    var spotifyId : String? {
        return self[SpotifyIdKey] as? String
    }
    
    var displayName: String?{
        return self[DisplayNameKey] as? String
    }
    
    
    func loadUserProfileImage(withCompletion completion: @escaping (UIImage?, Error?) -> Void){
        DispatchQueue.global(qos: .default).async {
            (self[ProfileImageKey] as? PFFile)?.getDataInBackground { (data, error) in
                if error == nil{
                    if let data = data{
                        let image = UIImage(data: data)
                        completion(image, nil)
                    }else{
                        completion(nil, nil)
                    }
                }else{
                    completion(nil, error)
                }
            }
        }
    }
    
    
    var recentlyVisitedSpot: [TuneSpot]?{
        get{
            return self[RecentlyVisitedSpotKey] as? [TuneSpot]
        }
        set{
            
        }
    }
    
    var currentListeningPlaylistPost: PlaylistPost?{
        get{
            return self[CurrentListeningPlaylistPostKey] as? PlaylistPost
        }
        set{
            if let post = newValue{
                self[CurrentListeningPlaylistPostKey] = post
            }
        }
    }
    
    var currentActiveTrackIndex: Int?{
        get{
            return self[CurrentActiveTrackIndexKey] as? Int
        }
        set{
            if let index = newValue{
                self[CurrentActiveTrackIndexKey] = index
            }

        }
    }

    
    override func isEqual(_ object: Any?) -> Bool {
        if let user = object as? User{
            return self.spotifyId! == user.spotifyId!
        }
        return false
    }
    
    
   
    
    func addRecentVisitSpot(spot: TuneSpot ,completionHandler: @escaping PFBooleanResultBlock){
        let newSpot = [spot]
        let filteredArray = self.recentlyVisitedSpot?.filter({ (tuneSpot) -> Bool in
            return !newSpot.contains(tuneSpot)
        })
        let newRecentSpot = newSpot + (filteredArray ?? [TuneSpot]())
        self.recentlyVisitedSpot = newRecentSpot
        self[RecentlyVisitedSpotKey] = newRecentSpot
        self.saveInBackground(block: completionHandler)
    }
    
    
    //update the user's current listening state and save to parse database
    func updateCurrentPlayingState(){
        print("updating current playing state")
        guard let activeTrackIndex = self.currentActiveTrackIndex else{
            print("active track index is nil")
            return
        }
        guard let currentListeningPlaylistPost = self.currentListeningPlaylistPost else{
            print("current listing playing list post is nil")
            return
        }
        self[CurrentActiveTrackIndexKey] = activeTrackIndex
        self[CurrentListeningPlaylistPostKey] = currentListeningPlaylistPost
        self.saveInBackground()
    }

    
   
    class func fetchUserByUsername(username: String, completionHandler: @escaping (User?) -> Void){
        let query = PFQuery(className: className)
        query.whereKey(SpotifyIdKey, equalTo: username)
        query.includeKey(RecentlyVisitedSpotKey)
        query.getFirstObjectInBackground { (object, error) in
            if let user = object as? User{
                SpotifyClient.fetchUserProfileByUsername(username: username, { (userDict) in
//                    user.dict = userDict
                })
                completionHandler(user)
            }else{
                completionHandler(nil)
            }
        }
    }
    
    //Create a user and save it to Parse
    class func register(dict: [String: Any], completionHandler: @escaping  (User?) -> Void) {
        let user = User()
        let profile = Profile(dict: dict)
        user[SpotifyIdKey] = profile.id
        user[UsernameKey] = profile.id
        let uuid = UUID().uuidString
        user[PasswordKey] = uuid
        user[CredentialTypeKey] = 0

        
        if let image = profile.image?.asset{
            user[ProfileImageKey] = image
        }
        if let displayNaem = profile.displayName{
            user[DisplayNameKey] = displayNaem
        }
        
        if let installation = PFInstallation.current(){
            user[InstallationKey] = installation
        }
        
        
        
        user.signUpInBackground  { (succeed, error) in
            if succeed{
                if let installation = PFInstallation.current(){
                    print("current installation is not nil")
                    installation["user"] = user
                    installation.saveInBackground(block: { (succeed, error) in
                        print(error)
                        if succeed{
                            completionHandler(user)
                        }else{
                            completionHandler(nil)
                        }
                    })
                }else{
                    completionHandler(nil)
                }
            }else{
                completionHandler(nil)
            }
        }
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
    
    //fetch all the users at a given spot
    class func fetchVisitedUserInSpot(spot: TuneSpot, completionHandler: @escaping ([User]?) -> Void ){
        let query = PFQuery(className: className)
        query.whereKey(RecentlyVisitedSpotKey, containsAllObjectsIn: [spot])
        query.findObjectsInBackground { (objects, error) in
            if let users = objects as? [User]{
                completionHandler(users)
            }else{
                completionHandler(nil)
            }
        }
    }

    
    
}

