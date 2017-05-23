//
//  NotificationCenterNavigationController.swift
//  Locus
//
//  Created by Xie kesong on 5/23/17.
//  Copyright © 2017 ___Locus___. All rights reserved.
//

import UIKit
import Parse

class NotificationCenterNavigationController: CoreNavigationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func instantiateFromStoryboard() -> NotificationCenterNavigationController?{
        if let notificationNVC = App.notificationStoryboard.instantiateViewController(withIdentifier: App.NotificationStoryboardIden.notificationCenterNavigationController) as? NotificationCenterNavigationController{
            notificationNVC.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "heart-icon"), selectedImage: nil)
            notificationNVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
            notificationNVC.tabBarItem.badgeColor = App.Style.Color.heartActiveColor
            let font =  App.Style.Font.regular.withSize(12.0)
            notificationNVC.tabBarItem.setBadgeTextAttributes([NSFontAttributeName: font], for: .normal)
            return notificationNVC
        }
        return nil
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
