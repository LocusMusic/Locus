//
//  AppDelegate.swift
//  Spottunes
//
//  Created by Xie kesong on 4/15/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var currentUser: User?{
        didSet{
            if let count = self.currentUser?.recentlyVisitedSpot?.count, count > 0{
                App.postLocalNotification(withName: App.LocalNotification.Name.recentlyVisitedShouldUpdate)
            }
        }
    }
    
    var queue: [Track]?
    
    var popularTuneSpot: [TuneSpot]?{
        didSet{
            //post notification for updates
            App.postLocalNotification(withName: App.LocalNotification.Name.popularSpotShouldUpdate)
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //remote notification
//        let userNotificationTypes: UIUserNotificationType = [.alert, .badge, .sound]
//        let settings = UIUserNotificationSettings(types: userNotificationTypes, categories: nil)
//        application.registerUserNotificationSettings(settings)
//        application.registerForRemoteNotifications()

        self.queue = App.retrivingQueueFromDisk()
        
        Parse.initialize(
            with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
                
                configuration.applicationId = "SpotTunes"
                configuration.clientKey = "SpotTunesIsGucciJKLDFSDJLKJFLAJFKLDSHLJASKLD"
                configuration.server = "https://spottunes.herokuapp.com/parse"
                configuration.isLocalDatastoreEnabled = true
            })
        )
        self.configureParse()
        SpotifyClient.authInit()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    //Called after returning from fetchRequestToken (user either enters credentials or cancels the operation)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return SpotifyClient.fetchAccessTokenHandler(withURL: url)
    }
    
    func configureParse() {
        TuneSpot.registerSubclass()
        Playlist.registerSubclass()
        User.registerSubclass()
    }

}

