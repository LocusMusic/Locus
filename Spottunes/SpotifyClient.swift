//
//  SpotifyClient.swift
//  Spottunes
//
//  Created by Xie kesong on 4/19/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import Foundation

fileprivate let idKey = "id"
fileprivate let clientID = "998109b54614480c81c056df333702a2"
fileprivate let clientSecret = "a4ac3e985ccb45f999b19fdfea0875f3"
fileprivate let tokenSwapURL = URL(string: "https://arcane-mesa-76444.herokuapp.com/swap")
fileprivate let tokenRefreshURL = URL(string:"https://arcane-mesa-76444.herokuapp.com/refresh")
fileprivate let redirectURL = URL(string: "spottunes://returnAfterLogin")
fileprivate let fetchTokenEndPoint = "https://accounts.spotify.com/api/token"
fileprivate let currentUserPlayListEndPoint = "https://api.spotify.com/v1/me/playlists"

struct Http{
    struct Method{
        static let get = "GET"
        static let post = "POST"
    }
}

class SpotifyClient{
    static var auth = SPTAuth()
    static let spotifySessionkey = "SpotifySession"

    static var encodedBase64ClientId: String {
        let data = clientID.data(using: String.Encoding.utf8)
        let base64 = data!.base64EncodedString()
        print(base64)
        return base64
    }
    
    static var encodedBase64ClientSecret: String {
        let data = clientSecret.data(using: String.Encoding.utf8)
        let base64 = data!.base64EncodedString()
        print(base64)
        return base64
    }
    
    static var encodedBase64ClientIdAndSecret: String {
        return encodedBase64ClientId + ":" + encodedBase64ClientSecret
    }
    
    var spotifyId: String?{
        return self.dictionary?[idKey] as? String
    }
    var dictionary: [String: Any]?
    init(dictionary: [String: Any]) {
        self.dictionary = dictionary
    }
    
    
    //needs to fix
    class func fetchAccessTokenIfNeeded(){
        if let session = auth.session, session.isValid(){
            guard let url = URL(string: fetchTokenEndPoint) else {
                print("Error: cannot create URL")
                return
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            //urlRequest.httpBody
            let postString = "grant_type=refresh_token&refresh_token=\(session.encryptedRefreshToken)"
            urlRequest.httpBody = postString.data(using: .utf8)
            
            //header
            urlRequest.addValue("Basic: \(encodedBase64ClientIdAndSecret)", forHTTPHeaderField: "Authorization")
            
            // set up the session
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                print(data)
                print(response)
                print(error)
            }).resume()
        }
    }
    
    
    class func doesSessionExist() {
        if let sessionObj:AnyObject = App.userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            print("sptify session here")
            let sessionDataObj = sessionObj as! Data
            let persistentSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            guard let token = persistentSession.accessToken else{
                return
            }
            
            print("Bearer \(token)")
            let todoEndpoint: String = "https://api.spotify.com/v1/me"
            guard let url = URL(string: todoEndpoint) else {
                print("Error: cannot create URL")
                return
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // set up the session
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                if let data = data{
                    if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) {
                        if let dataDict = jsonObject as? [String: Any]{
                            let spotifyClient = SpotifyClient(dictionary: dataDict)
                            guard let id = spotifyClient.spotifyId else{
                                return
                            }
                            User.doesExist(spotifyId: id, completionHandler: { (doesExisted) in
                                if !doesExisted{
                                    User.register(spotifyId: id)
                                }else{
                                    print("existed")
                                }
                            })
                        }
                    }
                }
            }).resume()
            
        }
    }
    //end needs to fix
    
    
    
    class func authInit(){
        self.auth.clientID = clientID
        self.auth.redirectURL = redirectURL
        self.auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        self.auth.sessionUserDefaultsKey = spotifySessionkey
        self.auth.tokenSwapURL = tokenSwapURL
        self.auth.tokenRefreshURL = tokenRefreshURL
        self.auth.session = getSession()
    }
    
    class func fetchTokenHandler(withURL url: URL) -> Bool {
        let auth = SpotifyClient.auth
        if auth.canHandle(auth.redirectURL) {
            auth.handleAuthCallback(withTriggeredAuthURL: url, callback: { (error: Error?, session: SPTSession!) in
                if let error = error {
                    print("Auth Error! \(error.localizedDescription)")
                    return
                }
                //Save session information
                saveSession(session: session)
                App.postLocalNotification(withName: App.LocalNotification.Name.onLoginSuccessful)
            })
            return true
        }
        return false
    }
    
    //save the session to the user defualt
    class func saveSession(session: SPTSession){
        let userDefaults = UserDefaults.standard
        let sessionData = NSKeyedArchiver.archivedData(withRootObject: session)
        userDefaults.set(sessionData, forKey: SpotifyClient.spotifySessionkey)
        userDefaults.synchronize()
    }
    
    
    class func getSession() -> SPTSession?{
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
                        completionHandler(session)
                    }
                })
            }else{
                completionHandler(currentSesison)
            }
        }else{
            print("no session object")
            completionHandler(nil)
        }
    }
    
    
    
    //the perfrom task will check whether the current session is valid or not, 
    //if it's not, then it's going to renew the session and perform the task
    //NOTE: when performing a get or post web api request, use perfrom task and wrap 
    //the corresponding task. This perfromTask will try to fetch a valid session token is 
    //availabe
    class func performTask(task: @escaping ()->Void){
        updateSession { (session) in
            if let currentSession = session, currentSession.isValid(){
                print("session is valid")
                task()
            }else{
                print("session not available")
            }
        }
    }
    
    
    class func fetchCurrentUserPlayList(_ completionHander: @escaping (_ responseDict: [String: Any]?) -> Void){
        guard let endPoint = URL(string: currentUserPlayListEndPoint) else{
            return
        }
        performTask {
            get(url: endPoint, completionHander: { (dataDict) in
                completionHander(dataDict)
            })
        }
    }
    
    private class func get(url: URL,  completionHander: @escaping (_ responseDict: [String: Any]?) -> Void){
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
            if let data = data{
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print(jsonObject)
                    if let dataDict = jsonObject as? [String: Any]{
                        print(dataDict)
                        completionHander(dataDict)
                    }else{
                        completionHander(nil)
                    }
                }else{
                    completionHander(nil)
                }
            }else{
                completionHander(nil)
            }
        }).resume()
    }
    
}
