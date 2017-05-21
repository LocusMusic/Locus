//
//  CoreNavigationViewController.swift
//  Locus
//
//  Created by Xie kesong on 5/7/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

class CoreNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = App.Style.NavigationBar.barTintColor
        self.navigationBar.clipsToBounds = App.Style.NavigationBar.clipsToBounds
        self.navigationBar.titleTextAttributes = App.Style.NavigationBar.titleTextAttribute
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
