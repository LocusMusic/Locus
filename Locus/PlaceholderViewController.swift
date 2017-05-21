//
//  PlaceholderViewController.swift
//  Locus
//
//  Created by Xie kesong on 5/11/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

class PlaceholderViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!{
        didSet{
            self.navigationBar.updateNavigationBarAppearance()
        }
    }

    @IBOutlet weak var tabBar: UITabBar!{
        didSet{
            self.tabBar.updateTabBarAppearance()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
