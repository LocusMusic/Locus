//
//  InitViewController.swift
//  Spottunes
//
//  Created by Xie kesong on 4/19/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

fileprivate let loginEmbedSegueIden = "LoginEmbedSegue"
fileprivate let homeEmbedSegueIden = "HomeWrapperEmbedSegue"

class InitViewController: UIViewController {

    
    //container view
    @IBOutlet weak var loginContainerView: UIView!
    @IBOutlet weak var homeContainerView: UIView!
    
    //embed view controller
    var loginViewController: LogInViewController?{
        didSet{
            self.loginViewController?.delegate = self
        }
    }
    var homeWrapperViewController: HomeWrapperViewController?
    
    var statusBarShouldHideen = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SpotifyClient.updateSession { (session) in
            if session != nil{
                self.statusBarShouldHideen = false
                print("session exsited")
                self.setNeedsStatusBarAppearanceUpdate()
                self.view.bringSubview(toFront: self.homeContainerView)
            }else{
                print("GO TO LOGIN PAGE")
                self.statusBarShouldHideen = true
            }
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    override var prefersStatusBarHidden: Bool{
        return self.statusBarShouldHideen
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let iden = segue.identifier{
            switch iden {
            case loginEmbedSegueIden:
                if let loginVC = segue.destination as? LogInViewController{
                self.loginViewController = loginVC
                }
            case homeEmbedSegueIden:
                if let homeWrapperVC = segue.destination as? HomeWrapperViewController{
                    self.homeWrapperViewController = homeWrapperVC
                }
            default:
                break
            }
        }
    }
    
    
}

extension InitViewController: LogInViewControllerDelegate{
    func finishedLogin() {
        //bring home to the front
        self.setNeedsStatusBarAppearanceUpdate()
        print("finished after logining")
        self.view.bringSubview(toFront: self.homeContainerView)
    }
}
