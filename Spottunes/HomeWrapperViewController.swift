//
//  GlobalViewController.swift
//  Instagram
//
//  Created by Xie kesong on 3/7/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

protocol HomeWrapperViewControllerDelegate: class{
    func statusBarShouldUpdate(statusBarAnimation:UIStatusBarAnimation, prefersStatusBarHidden: Bool )
}

class HomeWrapperViewController: UIViewController {

    @IBOutlet weak var mapContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
