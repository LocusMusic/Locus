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
    static let grayColor = UIColor(hexString: "#8C8E94")
    static let backColor = UIColor(hexString: "#323335")
//    static let currentLocation = App.delegate?.locationManager.startUpdate()
    static let themeColor = UIColor(red: 23 / 255.0, green: 131 / 255.0, blue: 198 / 255.0, alpha: 1)
    static let bannerAspectRatio: CGFloat = 3.0
    static let delegate = (UIApplication.shared.delegate as? AppDelegate)
    static let mainStoryBoard = UIStoryboard(name: App.mainStoryboadName, bundle: nil)
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let userDefaults = UserDefaults()
    static let mediaMaxLenght: CGFloat = 600
    

    
    struct Style{
        struct NavigationBar{
            static let titleFont = UIFont(name: "HelveticaNeue-Bold", size: 17.0)!
            static let barTintColor = UIColor.white
            static let isTranslucent = false
            static let titleTextAttribute = [NSForegroundColorAttributeName: UIColor.black]
        }
        
        struct TabBar{
            static let tintColor = App.grayColor
            static let barTintColor = UIColor.white
            static let isTranslucent = false
            static let titleTextAttribute = [NSForegroundColorAttributeName: UIColor.black]

        }
        
        struct LoginBtn{
            static let activeTitle = "Login with Spotify"
            static let deactiveTitle = ""
        }
        
        struct Onboard{
            struct Share{
                static let backgroundImage = #imageLiteral(resourceName: "onboard-share")
                static let actionBtnTitle = "Create Tunes Spot"
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
            static let activeColor = UIColor(hexString: "#323335")
            static let deactiveColor = App.grayColor
        }
        
        struct MinPlayerView{
            static let height: CGFloat = 48
        }

    }
    
    struct LocalNotification{
        struct Name{
            static let mapShouldReveal = Notification.Name("mapShouldReveal")
            static let onLoginSuccessful = Notification.Name("loginSuccessful")
            static let keyboardDidShow = Notification.Name.UIKeyboardDidShow
            static let keyboardWillHide = Notification.Name.UIKeyboardWillHide
            static let homeOverviewShouldBecomeActive = Notification.Name("homeOverviewShouldBecomeActive")
            static let homePlayingShouldBecomeActive = Notification.Name("homePlayingShouldBecomeActive")
        }
        
        struct PlayViewShouldShow{
            static let name = Notification.Name("playViewShouldShow")
            static let tracksKey = "tracks" //tracks key for the user info dictionary
            static let activeTrackIndex = "trackIndex" // active track key for ther user info dictionary
        }
    }
    
    static func postLocalNotification(withName name: Notification.Name, object: Any? = nil, userInfo: [String: Any]? = nil){
        NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
    }
    
    struct StoryboardIden{
        static let overviewViewController = "OverviewViewController"
        static let playingViewController = "PlayingViewController"
        static let listenerViewController = "ListenerViewController"  
    }
    
    struct SegueIden{
        static let embedPageVCIden = "EmbedPageVCIden"
    }
}

enum CoverSize{
    case large
    case medium
    case small
}


