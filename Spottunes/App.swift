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
            static let onLoginSuccessful = Notification.Name("loginSuccessful")

            static let keyboardDidShow = Notification.Name.UIKeyboardDidShow
            static let keyboardWillHide = Notification.Name.UIKeyboardWillHide
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
    
    static func postLocalNotification(withName name: Notification.Name){
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
        
    }

    
}


enum FileType{
    case video
    case photo
}




