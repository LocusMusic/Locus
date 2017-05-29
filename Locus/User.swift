//
//  User.swift
//  Locus
//
//  Created by Xie kesong on 4/19/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import Parse
import ParseLiveQuery

fileprivate let className = "_User"
fileprivate let SpotifyIdKey = "spotifyId"
fileprivate let RecentlyVisitedSpotKey = "recentlyVisitedSpot"
fileprivate let ProfileImageKey = "profileImage"
fileprivate let DisplayNameKey = "displayName"
fileprivate let CurrentListeningPlaylistPostKey = "currentListeningPlaylistPost"
fileprivate let CurrentActiveTrackIndexKey = "currentActiveTrackIndex"
fileprivate let CurrentPlayingUpdatedTimeKey = "currentPlayingUpdatedTime"
fileprivate let InstallationKey = "installation"
//the value for UsernameKey is the same as the value for SpotifyIdKey
fileprivate let UsernameKey = "username"
fileprivate let PasswordKey = "password"
//CredentialTypeKey, default 0, means spotify
fileprivate let CredentialTypeKey = "credentialType"
fileprivate let authDataSpotifyKey = "authData"
fileprivate let authType = "spotify"


class User: PFUser {
    var spotifyId : String? {
        return self[SpotifyIdKey] as? String
    }
    
    var displayName: String?{
        return (self[DisplayNameKey] as? String) ?? self.spotifyId
    }
    
    override var hashValue: Int{
        return (self[SpotifyIdKey] as! String).hashValue
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
    
    
    
    var currentListeningPlaylistPost: PlaylistPost?{
        get{
            return self[CurrentListeningPlaylistPostKey] as? PlaylistPost
        }
        set{
            self[CurrentListeningPlaylistPostKey] = newValue
            self.saveInBackground()
        }
    }
    
    var recentlyVisitedSpot: RecentlyVisitedSpot?
    
    
    var currentActiveTrackIndex: Int?{
        get{
            return self[CurrentActiveTrackIndexKey] as? Int
        }
        set{
            print("setting the active track index with \(newValue)")
            self.currentPlayingUpdatedTime = Date().getCurrentLocalTime()
            self[CurrentActiveTrackIndexKey] = newValue
            self.saveInBackground()
        }
    }

    var currentPlayingUpdatedTime: Date?{
        get{
            return self[CurrentPlayingUpdatedTimeKey] as? Date
        }
        set{
            self[CurrentPlayingUpdatedTimeKey] = newValue
        }
    }
    
    
    override func isEqual(_ object: Any?) -> Bool {
        if let user = object as? User{
            return self.spotifyId! == user.spotifyId!
        }
        return false
    }
    
   
    func addRecentVisitSpot(spot: TuneSpot, completionHandler: @escaping PFBooleanResultBlock){
        RecentlyVisitedSpot.saveRecentlyVisitedSpot(user: self, newSpot: spot) { (newRecentSpots) in
            if let newRecentSpots = newRecentSpots{
                self.recentlyVisitedSpot = newRecentSpots
                completionHandler(true, nil)
            }else{
                completionHandler(false, nil)
            }
        }
    }
    
    //set the current currentActiveTrackIndex to -1
    func resetPlayingState(){
        self.currentActiveTrackIndex = -1
    }
    
    func subscribeTo(_ listener: User){
        guard let listenerUsername = listener.username else{
            return
        }
        //the query the current user will subscribe to
        let userQuery = User.query()?.whereKey(UsernameKey, equalTo: listenerUsername).includeKey(CurrentListeningPlaylistPostKey) as! PFQuery<User>
        
        App.delegate?.listenerSubcription = App.delegate?.liveQueryClient.subscribe(userQuery).handle(Event.updated, { (_, user) in
            print(user)
            print("user updated track index ")
            //use the new user's current playing list info to update the
            // current login user current playing list info
            guard let currentTrackIndex = user.currentActiveTrackIndex else{
                print("current track index is nil")
                return
            }
            
            
            if let currentPostColumn = user[CurrentListeningPlaylistPostKey] as? [String: Any]{
                if let postObjectId = currentPostColumn["objectId"] as? String{
                    let query = PFQuery(className: "PlaylistPost")
                    query.includeKey("user")
                    query.getObjectInBackground(withId: postObjectId, block: { (fetchedPlaylistPost, error) in
                        if let fetchedPlaylistPost = fetchedPlaylistPost as? PlaylistPost{
                            guard let userId = fetchedPlaylistPost.user?.spotifyId else{
                                print("user id is nil after fetching")
                                return
                            }
                            guard let playlistId = fetchedPlaylistPost.playlistId else{
                                print("playlist id is nil after fetching")
                                return
                            }
                            
                            SpotifyClient.fetchPlaylistByUserIdAndPlaylistId(userId: userId, playlistId: playlistId) { (playlist) in
                                DispatchQueue.main.async {
                                    if let playlist = playlist{
                                        fetchedPlaylistPost.playlist = playlist
        
                                        guard let trackList = fetchedPlaylistPost.trackList else{
                                            return
                                        }
                                        
                                        //play the current track that the listener is listening to
                                        if currentTrackIndex >= 0 {
                                            App.playTracks(trackList: trackList, activeTrackIndex: currentTrackIndex)
                                        }else{
                                            //unsubscribe
                                            App.delegate?.listenerSubcription = nil
                                            print("just unsubscribe")
                                        }
                                    }
                                }
                            }
                        }
                    })
                }
                
            }else{
                print("the object id is nil")
            }
        })
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
    
    
    class func register(profile: Profile, accessToken: String, completionHandler: @escaping  (User?) -> Void) {
        
        print("signing up ")
        print(profile.dict)
        print("end displya sign up name")
        User.register(ParseAuthDelegate(), forAuthType: authType)
        let authData: [String: String] = ["access_token": accessToken, "id" : profile.id]
        User.logInWithAuthType(inBackground: authType, authData: authData).continue({ (task) -> AnyObject? in
            guard let currentUser = User.current() else{
                return nil
            }
            //now we have the login user
            PFInstallation.saveUserPointerToCurrentInstallation(user: currentUser, completionHandler: { (succeed, error) in
                //saved the token correctly
                if succeed{
                    //save extra information about the user
                    currentUser[SpotifyIdKey] = profile.id
                    if let image = profile.image?.asset{
                        currentUser[ProfileImageKey] = image
                    }
                    if let displayNaem = profile.displayName{
                        print(displayNaem)
                        currentUser[DisplayNameKey] = displayNaem
                    }
                    currentUser.saveInBackground(block: { (succeed, error) in
                        if succeed{
                            completionHandler(currentUser)
                        }else{
                            print("failed to save current user")
                            completionHandler(nil)
                        }
                    })
                }else{
                    print("failed to save installation for user")
                    completionHandler(nil)
                }
            })
            return nil
        })
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

