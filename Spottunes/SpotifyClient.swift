//
//  SpotifyClient.swift
//  Spottunes
//
//  Created by Xie kesong on 4/19/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import Foundation

fileprivate let idKey = "id"
fileprivate let spotifySessionkey = "SpotifySession"
fileprivate let clientID = "998109b54614480c81c056df333702a2"
fileprivate let clientSecret = "a4ac3e985ccb45f999b19fdfea0875f3"
fileprivate let fetchTokenEndPoint = "https://accounts.spotify.com/api/token"
fileprivate let tokenSwapURL = "https://arcane-mesa-76444.herokuapp.com/swap"
fileprivate let tokenRefreshServiceURL = "https://arcane-mesa-76444.herokuapp.com/refresh"



class SpotifyClient{
    
    static var auth = SPTAuth()
    
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
    
    
    static var session: SPTSession?{
        if let sessionObj : AnyObject = App.userDefaults.object(forKey: spotifySessionkey) as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            return  NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as? SPTSession
        }
        return nil
    }
    
    class func fetchAccessTokenIfNeeded(){
        if let session = self.session, session.isValid(){
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
            
        } else {
            print("hello")
        }
    }
    
    class func setupAuth() -> SPTAuth{
        
        
            auth.redirectURL = URL(string: redirectURL)
            auth.clientID = clientID
            auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
            loginUrl = auth.spotifyWebAuthenticationURL()
            
        

    }
}
