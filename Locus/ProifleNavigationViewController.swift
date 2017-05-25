//
//  ProifleNavigationControllerViewController.swift
//  Locus
//
//  Created by Xie kesong on 5/25/17.
//  Copyright © 2017 ___Locus___. All rights reserved.
//

import UIKit

class ProifleNavigationViewController: CoreNavigationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    class func instantiateFromStoryboard() -> ProifleNavigationViewController?{
        if let profileNVC = App.profileStoryboard.instantiateViewController(withIdentifier: App.ProfileStoryboardIden.ProifleNavigationViewController) as? ProifleNavigationViewController{
            profileNVC.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "profile-icon"), selectedImage: nil)
            profileNVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
            return profileNVC
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
