//
//  NotificationViewController.swift
//  Locus
//
//  Created by Xie kesong on 5/22/17.
//  Copyright © 2017 ___Locus___. All rights reserved.
//

import UIKit
import Parse

class NotificationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    class func instantiateFromStoryboard() -> NotificationViewController?{
        if let notificationVC = App.notificationStoryboard.instantiateViewController(withIdentifier: App.NotificationStoryboardIden.notificationViewController) as? NotificationViewController{
            notificationVC.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "heart-icon"), selectedImage: nil)
            notificationVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
            
            notificationVC.tabBarItem.badgeColor = App.Style.Color.heartActiveColor
            notificationVC.tabBarItem.badgeValue = "1"
            notificationVC.tabBarItem.setBadgeTextAttributes([NSFontAttributeName: App.Style.Font.regular], for: .normal)
            
            return notificationVC
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
