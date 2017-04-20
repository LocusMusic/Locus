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
    static let grayColor = UIColor(red: 101 / 255.0, green: 119 / 255.0, blue: 134 / 255.0, alpha: 1)
    static let themeColor = UIColor(red: 23 / 255.0, green: 131 / 255.0, blue: 198 / 255.0, alpha: 1)
    static let bannerAspectRatio: CGFloat = 3.0
    
    static let delegate = (UIApplication.shared.delegate as? AppDelegate)
    static let mainStoryBoard = UIStoryboard(name: App.mainStoryboadName, bundle: nil)
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let userDefaults = UserDefaults()
    static let mediaMaxLenght: CGFloat = 600
    
   
    struct Style{
        struct navigationBar{
            static let titleFont = UIFont(name: "HelveticaNeue-Bold", size: 17.0)!
            static let barTintColor = UIColor.white
            static let isTranslucent = false
            static let titleTextAttribute = [NSForegroundColorAttributeName: UIColor.black]
        }
    }
    
    struct LocalNotification{
        struct Name{
            static let mapShouldReveal = Notification.Name("mapShouldReveal")
            static let keyboardDidShow = Notification.Name.UIKeyboardDidShow
            static let keyboardWillHide = Notification.Name.UIKeyboardWillHide
            
//            static let statusBarShouldUpdateNotificationName = Notification.Name("StatusBarShouldUpdateNotification")
//            static let statusBarStyleKey = Notification.Name("statusBarStyleKey")
//            
//            
//            static let colorPaletteActivatedNotificationName = Notification.Name("colorPaletteActivatedNotificationName")
//            static let colorPaletteDeActivatedNotificationName = Notification.Name("colorPaletteDeActivatedNotificationName")
//            
//            
//            static let statusBarShouldHideNotificationName = Notification.Name("statusBarShouldHideNotification")
//            static let statusBarShouldHideKey = "ShouldHide"
//            
//            static let finishedPostingNotificationName = Notification.Name("FinishedPostingNotification")
//            
            //            //            static let presentHomeForLoggedIn = Notification.Name("presentHomeForLoggedIn")
            //            static let needsLogin = Notification.Name("needsLoginNotification")
            //            static let didPostNotificationName = Notification.Name("didPostNotification")
            //            static let postKey = Notification.Name("post")
            //            

//
//            static let userLogoutNotificationName = Notification.Name("userLogoutNotification")

        }
    }

    
    
 
//    static func postStatusBarShouldUpdateNotification(style : UIStatusBarStyle){
//        let userInfo = [AppNotification.statusBarStyleKey: style]
//        let notification = Notification(name: AppNotification.statusBarShouldUpdateNotificationName, object: self, userInfo: userInfo)
//        NotificationCenter.default.post(notification)
//    }
//    
//    static func postStatusBarShouldHideNotification(hide : Bool){
//        let userInfo = [AppNotification.statusBarShouldHideKey: hide]
//        let notification = Notification(name: AppNotification.statusBarShouldHideNotificationName, object: self, userInfo: userInfo)
//        NotificationCenter.default.post(notification)
//    }
//    
}


enum FileType{
    case video
    case photo
}




