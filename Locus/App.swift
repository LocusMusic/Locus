//
//  Global.swift
//  Twitter
//
//  Created by Xie kesong on 1/18/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import Foundation
import UIKit

struct App{
    static let mainStoryboadName = "Main"
    static let searchStoryboardName = "Search"
    static let streamingStoryboardName = "Streaming"
    static let spotStoryboardName = "Spot"
    static let grayColor = UIColor(hexString: "#8C8E94")
    static let backColor = UIColor(hexString: "#323335")
    static let themeColor = UIColor(red: 23 / 255.0, green: 131 / 255.0, blue: 198 / 255.0, alpha: 1)
    static let bannerAspectRatio: CGFloat = 3.0
    static let delegate = (UIApplication.shared.delegate as? AppDelegate)

    static let mainStoryBoard = UIStoryboard(name: App.mainStoryboadName, bundle: nil)
    static let searchStoryBoard = UIStoryboard(name: App.searchStoryboardName, bundle: nil)
    static let streammingStoryBoard = UIStoryboard(name: App.streamingStoryboardName, bundle: nil)
    static let spotStoryBoard = UIStoryboard(name: App.spotStoryboardName, bundle: nil)

    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let userDefaults = UserDefaults()
    static let mediaMaxLenght: CGFloat = 600
    
    struct Style{
        struct Color {
            static let heartInactiveColor = App.grayColor
            static let heartActiveColor = UIColor(hexString: "#B70C1F")
        }
        
        struct NavigationBar{
            static let titleFont = UIFont(name: "Avenir-Heavy", size: 17.0)!
            static let barTintColor = UIColor.white
            static let isTranslucent = false
            static let titleTextAttribute = [NSForegroundColorAttributeName: App.backColor]
            static let clipsToBounds = true
        }
        
        struct TabBar{
            static let tintColor = App.backColor
            static let barTintColor = UIColor.white
            static let isTranslucent = false
            static let titleTextAttribute = [NSForegroundColorAttributeName: App.backColor]
        }
        
        struct LoginBtn{
            static let activeTitle = "Login with Spotify"
            static let deactiveTitle = ""
        }
        
        struct Onboard{
            struct Share{
                static let backgroundImage = #imageLiteral(resourceName: "onboard-share-screen")
                static let actionBtnTitle = "Sounds Great"
            }
            struct Listen{
                static let backgroundImage = #imageLiteral(resourceName: "onboard-listen")
                static let actionBtnTitle = "Let's Go"
            }
            
            struct Discover{
                static let backgroundImage = #imageLiteral(resourceName: "onboard-discover")
                static let actionBtnTitle = "Turn on Location"
            }
        }
        
        struct SliderMenue{
            static let activeColor = App.backColor
            static let deactiveColor = App.grayColor
        }
        
        struct MinPlayerView{
            static let height: CGFloat = 48
        }
        
        struct PlaylistSelection{
            static let spotThumbnailWidth = App.screenWidth / 3.2
        }
        
        struct AddMusicConatainerView{
            static let minimizedCornerRadius: CGFloat = 8.0
        }
        
        struct TableView{
            static let contentInset = UIEdgeInsetsMake(8, 0, 0, 0)
        }
    }
    
    struct UserDefaultKey{
        static let queue = "queue"
    }
    
    struct LocalNotification{
        struct Name{
            static let mapShouldReveal = Notification.Name("mapShouldReveal")
            static let onLoginSuccessful = Notification.Name("loginSuccessful")
            static let keyboardDidShow = Notification.Name.UIKeyboardDidShow
            static let keyboardWillHide = Notification.Name.UIKeyboardWillHide
            static let streamingSpotShouldBecomeActive = Notification.Name("streamingSpotShouldBecomeActive")
            static let streamingQueueShouldBecomeActive = Notification.Name("streamingQueueShouldBecomeActive")
            static let homeOverviewShouldBecomeActive = Notification.Name("homeOverviewShouldBecomeActive")
            static let homePlayingShouldBecomeActive = Notification.Name("homePlayingShouldBecomeActive")
            static let searchSongShouldBecomeActive = Notification.Name("searchSongShouldBecomeActive")
            static let searchArtistsShouldBecomeActive = Notification.Name("searchArtistsShouldBecomeActive")
            static let searchPlaylistsShouldBecomeActive = Notification.Name("searchPlaylistsShouldBecomeActive")
            static let searchSpotsShouldBecomeActive = Notification.Name("searchSpotsShouldBecomeActive")
            static let popularSpotShouldUpdate = Notification.Name("popularSpotShouldUpdate")
            static let recentlyVisitedShouldUpdate = Notification.Name("recentlyVisitedShouldUpdate")
            static let queueShouldUpdate = Notification.Name("queueShouldUpdate")
        }
        
        struct finishSharingPlaylist{
            static let name = Notification.Name("FinishSharingPlaylist")
            static let spotKey = "spot"
        }
        
        struct PlayViewShouldShow{
            static let name = Notification.Name("playViewShouldShow")
            static let tracksKey = "tracks" //tracks key for the user info dictionary
            static let activeTrackIndex = "trackIndex" // active track key for ther user info dictionary
        }
        
        struct UpdatePlaylistPickerAfterSpotSelected{
            static let name = Notification.Name("updatePlaylistPickerAfterSpotSelected")
            static let spotKey = "spot" //tracks key for the user info dictionary
        }
        
        struct StatusBarStyleUpdate{
            static let name = Notification.Name("StatusBarStyleUpdate")
            static let styleKey = "style" //tracks key for the user info dictionary
        }
    }
    
    static func postLocalNotification(withName name: Notification.Name, object: Any? = nil, userInfo: [String: Any]? = nil){
        NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
    }
    
    struct StoryboardIden {
        static let overviewViewController = "OverviewViewController"
        static let playingViewController = "PlayingViewController"
        static let listenerViewController = "ListenerViewController"
        static let playlistDetailViewController = "PlaylistDetailViewController"
        static let selectionFromPlaylistViewController = "SelectionFromPlaylistViewController"
    }
    
    struct SearchStoryboardIden {
        static let songsSearchViewController = "SongsSearchViewController"
        static let artistsSearchViewController = "ArtistsSearchViewController"
        static let spotsSearchViewController = "SpotsSearchViewController"
        static let playlistsSearchViewController = "PlaylistsSearchViewController"
    }
    
    
    struct StreammingStoryboradIden{
        static let connectedSpotViewController = "ConnectedSpotViewController"
        static let queueViewController = "QueueViewController"
        static let streamingViewController = "StreamingViewController"
    }
    
    
    struct SpotStoryboardIden{
        static let spotViewController = "SpotViewController"
        static let topPlaylistViewController = "TopPlaylistViewController"
        static let listenerViewController = "ListenerViewController"
    }
    
    
    struct SegueIden {
        static let embedPageVCIden = "EmbedPageVCIden"
        static let addMusicEmbedSegueIden = "AddMusicEmbedSegueIden"
        static let globalTabBarEmbedSegueIden = "GlobalTabBarEmbedSegueIden"
        static let globalWrapperEmbedSegueIden = "GlobalWrapperEmbedSegueIden"
        static let LoginEmbedSegueIden = "LoginEmbedSegueIden"
        static let selectFromPlaylistEmbedSegueIden = "SelectFromPlaylistEmbedSegueIden"
        static let embedSearchPageVCIden = "EmbedSearchPageVCIden"
        static let selectPlayListSegue = "SelectPlayListSegue"
        static let selectSpotSegue = "SelectSpotSegue"
        static let selectSongsSegue = "SelectSongsSegue"
        static let streamEmbedPageVCIden = "StreamEmbedPageVCIden"
        static let spotEmbedSegueIden = "SpotEmbedSegueIden"
    }
    
    struct PostInfoKey{
        static let spot = "spot"
        static let user = "user"
        static let playlist = "playlistId"
    }
    
    static func postStatusBarShouldUpdateNotification(style : UIStatusBarStyle){
        let userInfo = [App.LocalNotification.StatusBarStyleUpdate.styleKey: style]
        App.postLocalNotification(withName: App.LocalNotification.StatusBarStyleUpdate.name, object: nil, userInfo: userInfo)
    }
    
    static func setStatusBarStyle(style : UIStatusBarStyle){
        let info = [App.LocalNotification.StatusBarStyleUpdate.styleKey : style]
        App.postLocalNotification(withName: App.LocalNotification.StatusBarStyleUpdate.name, object: self, userInfo: info)
    }
    
    static func playTracks(trackList: [Track], activeTrackIndex: Int){
        let userInfo: [String: Any] = [
            App.LocalNotification.PlayViewShouldShow.tracksKey: trackList,
            App.LocalNotification.PlayViewShouldShow.activeTrackIndex: activeTrackIndex
        ]
        
        App.delegate?.queue =  Array(trackList[activeTrackIndex ... trackList.count - 1])
        App.savingQueueToDisk()
        App.postLocalNotification(withName: App.LocalNotification.Name.queueShouldUpdate)
        App.postLocalNotification(withName: App.LocalNotification.PlayViewShouldShow.name, object: self, userInfo: userInfo)
    }
    
    
    //saving current queue in the app delegate to disk
    static func savingQueueToDisk(){
        if let queue = App.delegate?.queue{
            let queueDict = queue.map({ (track) -> [String: Any] in
                return track.dict
            })
            if let data = try? JSONSerialization.data(withJSONObject: queueDict, options: []){
                UserDefaults.standard.set(data, forKey: App.UserDefaultKey.queue)
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    //retriving queue form disk
    static func retrivingQueueFromDisk() -> [Track]?{
        if let queueData = UserDefaults.standard.value(forKey: App.UserDefaultKey.queue) as? Data{
            guard let jsonObject = try? JSONSerialization.jsonObject(with: queueData, options: []) else{
                return nil
            }
            
            guard let queueDicts = jsonObject as? [[String: Any]] else{
                return nil
            }
            let tracks = queueDicts.map({ (trackDict) -> Track in
                return Track(dict: trackDict)
            })
            return tracks
        }
        return nil
    }
    
    
}

enum CoverSize{
    case large
    case medium
    case small
}


