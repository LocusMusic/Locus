//
//  SpotifyClient.swift
//  Spottunes
//
//  Created by Xie kesong, Leo Wong on 4/19/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import Parse

fileprivate let idKey = "id"
fileprivate let clientID = "998109b54614480c81c056df333702a2"
fileprivate let clientSecret = "a4ac3e985ccb45f999b19fdfea0875f3"
fileprivate let tokenSwapURL = URL(string: "https://arcane-mesa-76444.herokuapp.com/swap")
fileprivate let tokenRefreshURL = URL(string:"https://arcane-mesa-76444.herokuapp.com/refresh")

fileprivate let redirectURL = URL(string: "spottunes://returnAfterLogin")
fileprivate let fetchTokenEndPoint = "https://accounts.spotify.com/api/token"
fileprivate let currentUserPlayListEndPoint = "https://api.spotify.com/v1/me/playlists"
fileprivate let currentUserProfileEndPoint = "https://api.spotify.com/v1/me"
fileprivate let userProfileEndPoint = "https://api.spotify.com/v1/users/"
//fetch a playlist by user id and playlist id
fileprivate let fetchPlaylistEndpoint = "https://api.spotify.com/v1/users/{user_id}/playlists/{playlist_id}"
fileprivate let searchEndPoint = "https://api.spotify.com/v1/search"

struct Http {
    struct Method{
        static let get = "GET"
        static let post = "POST"
    }
}

struct ResponseKey{
    struct CurrentUserPlaylist{
        static let ItemsKey = "items"
    }
}


class SpotifyClient {
    
    
    static var auth = SPTAuth()
    
    static let spotifySessionkey = "SpotifySession"
    
    static var encodedBase64ClientId: String {
        let data = clientID.data(using: String.Encoding.utf8)
        let base64 = data!.base64EncodedString()
        return base64
    }
    
    static var encodedBase64ClientSecret: String {
        let data = clientSecret.data(using: String.Encoding.utf8)
        let base64 = data!.base64EncodedString()
        return base64
    }
    
    static var encodedBase64ClientIdAndSecret: String {
        return encodedBase64ClientId + ":" + encodedBase64ClientSecret
    }
    
    var spotifyId: String? {
        return self.dictionary?[idKey] as? String
    }
    
    var dictionary: [String: Any]?
    
    init(dictionary: [String: Any]) {
        self.dictionary = dictionary
    }
    
    class func authInit(){
        self.auth.clientID = clientID
        self.auth.redirectURL = redirectURL
        self.auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        self.auth.sessionUserDefaultsKey = spotifySessionkey
        self.auth.tokenSwapURL = tokenSwapURL
        self.auth.tokenRefreshURL = tokenRefreshURL
        self.auth.session = getSession()
    }
    
    class func fetchAccessTokenHandler(withURL url: URL) -> Bool {
        let auth = SpotifyClient.auth
        if auth.canHandle(auth.redirectURL) {
            auth.handleAuthCallback(withTriggeredAuthURL: url, callback: { (error: Error?, session: SPTSession!) in
                if let error = error {
                    print("Auth Error! \(error.localizedDescription)")
                    return
                }
                saveSession(session: session)
                User.fetchUserByUsername(username: session.canonicalUsername, completionHandler: { (user) in
                    if let user = user{
                        //user existed
                        print("user existed already")
                        print(user)
                        App.delegate?.currentUser = user
                        App.postLocalNotification(withName: App.LocalNotification.Name.onLoginSuccessful)

                    }else{
                        print("user not existed")
                        
                        
                        User.register(ParseAuthDelegate(), forAuthType: "spotify")
                        if let token = session.accessToken{
                            let authData: [String: String] = ["access_token": token, "id" : session.canonicalUsername]
                            User.logInWithAuthType(inBackground: "spotify", authData: authData).continue({ (task) -> AnyObject? in
                                // the PFUser currentUser should not be nil at this point
                                if let currentUser = User.current(){
                                    print("has current user")
                                    if let installation = PFInstallation.current(){
                                        print("installation succeed")
//                                        currentUser["Installation"] = installation
//                                        currentUser.saveInBackground()
                                        
                                        installation["user"] = currentUser
                                        installation.saveInBackground(block: { (succeed, error) in
                                            if succeed{
                                                print("instllation user saved")
                                            }else{
                                                print("installation user failed")
                                            }
                                        })

                                        
                                        
                                    }else{
                                        print("no current installation")
                                    }
                                }else{
                                    print("no current user")
                                }
                                return nil
                            })
                        }

                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
//                        //user not existed
//                        //fetch the user's profile for recording to parse db
//                        SpotifyClient.fetchUserProfile({ (dict) in
//                            if let dict = dict{
//                                User.register(dict: dict, completionHandler: { (user) in
//                                    if let user = user{
//                                        print(user)
//                                        print("registered succeed")
//                                        App.postLocalNotification(withName: App.LocalNotification.Name.onLoginSuccessful)
//
//                                    }else{
//                                        print("failed to registered")
//                                    }
//                                })
//                            }
//                        })
                    }
                })
                
//                User.doesExist(spotifyId: session.canonicalUsername, completionHandler: { (exist) in
//                    if !exist {
//                        print("User with spotifyId \(session.canonicalUsername) doesn't exist")
//                        User.register(spotifyId: session.canonicalUsername, completionHandler: { (succeed, error) in
//                            if succeed{
//                                //save user to disk
//                                
//                                App.postLocalNotification(withName: App.LocalNotification.Name.onLoginSuccessful)
//                            }else{
//                                print("failed to register")
//                            }
//                        })
//                    }else{
//                        //save user to disk
//                        App.postLocalNotification(withName: App.LocalNotification.Name.onLoginSuccessful)
//                    }
//                })
            })
            return true
        }
        return false
    }
    
    //save the session to the user defaults
    class func saveSession(session: SPTSession) {
        let userDefaults = UserDefaults.standard
        let sessionData = NSKeyedArchiver.archivedData(withRootObject: session)
        userDefaults.set(sessionData, forKey: SpotifyClient.spotifySessionkey)
        userDefaults.synchronize()
    }
    
    class func getSession() -> SPTSession? {
        if let sessionObj : AnyObject = App.userDefaults.object(forKey: spotifySessionkey) as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            return NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as? SPTSession
        }
        return nil
    }
    
    //update the session, if it's invalid, the function will renew the session
    class func updateSession(completionHandler: @escaping (_ session: SPTSession?) -> Void){
        if let sessionObj : AnyObject = App.userDefaults.object(forKey: spotifySessionkey) as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            guard let currentSesison = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as? SPTSession else{
                print("current session not in defualt")
                completionHandler(nil)
                return
            }
            //if the session is not valid right now, we should renew session
            if !currentSesison.isValid(){
                auth.renewSession(currentSesison, callback: { (error, session) in
                    if let session = session{
                        //save the new session
                        saveSession(session: session)
                        print("renew session")
                        auth.session = session
                        print("auth after renewing \( auth.session.isValid())")
                        completionHandler(session)
                    }
                })
            } else {
                completionHandler(currentSesison)
            }
        } else {
            print("no session object")
            completionHandler(nil)
        }
    }
    
    //the perform task will check whether the current session is valid or not,
    //if it's not, then it's going to renew the session and perform the task
    //NOTE: when performing a get or post web api request, use perfrom task and wrap
    //the corresponding task. This perfromTask will try to fetch a valid session token is
    //availabe
    class func performTask(task: @escaping ()->Void) {
        updateSession { (session) in
            if let currentSession = session, currentSession.isValid(){
                print("session is valid")
                task()
            } else {
                print("session not available")
            }
        }
    }
    
    class func fetchCurrentUserPlayList(_ completionHandler: @escaping (_ responseDict: [Playlist]?) -> Void) {
        guard let endPoint = URL(string: currentUserPlayListEndPoint) else { return }
        performTask {
            get(url: endPoint, completionHandler: { (responseDict) in
                guard let responseDict = responseDict else{
                    completionHandler(nil)
                    return
                }
                guard let playlistDicts = responseDict[ResponseKey.CurrentUserPlaylist.ItemsKey] as? [[String: Any]] else{
                    completionHandler(nil)
                    return
                }
                let playlists = playlistDicts.map({ (playlistDict) -> Playlist in
                    return Playlist(dict: playlistDict)
                })
                

                completionHandler(playlists)
            })
        }
    }
    
    class func fetchUserProfile(_ completionHandler: @escaping (_ responseDict: [String: Any]?) -> Void) {
        guard let endPoint = URL(string: currentUserProfileEndPoint) else { return }
        performTask {
            get(url: endPoint, completionHandler: { (dataDict) in
                completionHandler(dataDict)
            })
        }
    }
    
    class func fetchUserProfileByUsername(username: String, _ completionHandler: @escaping (_ responseDict: [String: Any]?) -> Void){
        guard let endPoint = URL(string: userProfileEndPoint + username) else { return }
        performTask {
            get(url: endPoint, completionHandler: { (dataDict) in
                completionHandler(dataDict)
            })
        }

    }
    
    
    class func fetchPlaylistByUserIdAndPlaylistId(userId:String, playlistId: String,completionHandler: @escaping (_ responseDict: Playlist?) -> Void  ){
        var endPointStrig = fetchPlaylistEndpoint
        endPointStrig =  SpotifyClient.replaceUserIdPlaceholder(ofEnpoint: endPointStrig, userId: userId)
        endPointStrig = SpotifyClient.replacePlaylistIdPlaceholder(ofEnpoint: endPointStrig, playlistId: playlistId)
        guard let endPoint = URL(string: endPointStrig) else {
            completionHandler(nil)
            return
        }
        performTask {
            get(url: endPoint, completionHandler: { (dataDict) in
                if let dataDict = dataDict{
                    let playlist = Playlist(dict: dataDict)
                    completionHandler(playlist)
                }else{
                    completionHandler(nil)
                }
            })
        }
    }
    
    
    class func getTracksInPlaylist(playlist: Playlist, completionHandler: @escaping (_ responseDict: [Track]?) -> Void ){
        if let tracksHref = playlist.tracks?.href{
            guard let endPoint = URL(string: tracksHref) else{
                print("end point onvalid")
                completionHandler(nil)
                return
            }
            performTask {
                get(url: endPoint, completionHandler: { (dataDict) in
                    guard let dataDict = dataDict else{
                        completionHandler(nil)
                        return
                    }
                    
                    let tracks = Tracks(dict: dataDict)
                    guard let trackList = tracks.trackList else{
                        completionHandler(nil)
                        return
                    }
                    completionHandler(trackList)
                })
            }
        }
    }
    
    
    
    
    
    
    //get tracks in playlists
    class func getTracksInPlaylist(tracksHref: String,  completionHandler: @escaping (_ responseDict: [Track]?) -> Void){
        guard let endPoint = URL(string: tracksHref) else{
            completionHandler(nil)
            return
        }
        performTask {
            get(url: endPoint, completionHandler: { (dataDict) in
                guard let dataDict = dataDict else{
                    completionHandler(nil)
                    return
                }
                let tracks = Tracks(dict: dataDict)
                guard let trackList = tracks.trackList else{
                    completionHandler(nil)
                    return
                }
                completionHandler(trackList)
            })
        }
    }
    
    class func getSearch(parameters: [String: AnyObject], completionHandler: @escaping (_ responseDict: [String: Any]?) -> Void) {
        
        let paramString = parameters.stringFromHttpParams() as String!
        guard let requestURL = URL(string:"\(searchEndPoint)?\( paramString!)") else {
            return
        }
 
        performTask {
            get(url: requestURL, completionHandler: { (dataDict) in
                guard let dataDict = dataDict else {
                    completionHandler(nil)
                    return
                }
                completionHandler(dataDict)
            })
        }
    }
    
    
    private class func get(url: URL,  completionHandler: @escaping (_ responseDict: [String: Any]?) -> Void){
        guard auth.session != nil else{
            print("session is nil")
            return
        }
        guard auth.session.isValid() else{
            print("auth session is not valid")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = Http.Method.get
        urlRequest.addTokenValue(token: auth.session.accessToken)
        urlRequest.addJsonContentType()
        
        // set up the session
        let config = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: config)
        urlSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if let data = data {
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) {
                    if let dataDict = jsonObject as? [String: Any] {
                        completionHandler(dataDict)
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }).resume()
    }
    
    
    //helper functions
    private class func replaceUserIdPlaceholder(ofEnpoint endpoint: String, userId: String) -> String{
        return endpoint.replacingOccurrences(of: "{user_id}", with: userId)
    }
    
    
    private class func replacePlaylistIdPlaceholder(ofEnpoint endpoint: String, playlistId: String) -> String{
        return endpoint.replacingOccurrences(of: "{playlist_id}", with: playlistId)
    }
    

}
