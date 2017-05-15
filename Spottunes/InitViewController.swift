//
//  InitViewController.swift
//  Spottunes
//
//  Created by Xie kesong on 4/19/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit


protocol InitViewControllerDelegate: class {
    func homeInit()
}

class InitViewController: UIViewController {
    
    
    //container view
    @IBOutlet weak var loginContainerView: UIView!
    @IBOutlet weak var homeContainerView: UIView!
    @IBOutlet weak var placeholderContainerView: UIView!
    
    
    //embed view controller
    var loginViewController: LogInViewController?{
        didSet{
            self.loginViewController?.delegate = self
        }
    }
    var globalWrapperViewController: GlobalWrapperViewController?{
        didSet{
            self.delegate = globalWrapperViewController
        }
    }
    
    var statusBarShouldHidden = true{
        didSet{
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    var statusBarStyle: UIStatusBarStyle = .lightContent{
        didSet{
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    weak var delegate: InitViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(statusBarShouldUpdate(_:)), name: App.LocalNotification.StatusBarStyleUpdate.name, object: nil)
        self.statusBarShouldHidden = false
        self.statusBarStyle = .default

        SpotifyClient.updateSession { (session) in
            if let session = session{
                self.view.bringSubview(toFront: self.placeholderContainerView)
                User.fetchUserByUsername(username: session.canonicalUsername, completionHandler: { (user) in
                    if let user = user{
                        print("finsihed fetching user")
                        App.delegate?.currentUser = user
                        
                        //get the popular tune spot near the current location
                        TuneSpot.getNearbyPopularTuneSpot { (spots) in
                            if let spots = spots{
                                App.delegate?.popularTuneSpot = spots
                                self.view.bringSubview(toFront: self.homeContainerView)
                            }
                        }
                    }
                })
            }else{
                print("GO TO LOGIN PAGE")
                self.statusBarShouldHidden = true
                self.view.bringSubview(toFront: self.loginContainerView)
            }
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    override var prefersStatusBarHidden: Bool{
        return self.statusBarShouldHidden
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return self.statusBarStyle
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let iden = segue.identifier{
            switch iden {
            case App.SegueIden.LoginEmbedSegueIden:
                if let loginVC = segue.destination as? LogInViewController{
                    self.loginViewController = loginVC
                }
            case App.SegueIden.globalWrapperEmbedSegueIden:
                if let globalWrapperVC = segue.destination as? GlobalWrapperViewController{
                    self.globalWrapperViewController = globalWrapperVC
                }
            default:
                break
            }
        }
    }
    
    func statusBarShouldUpdate(_ notification: Notification){
        if let statusBarStyle = notification.userInfo?[App.LocalNotification.StatusBarStyleUpdate.styleKey] as? UIStatusBarStyle{
            self.statusBarStyle = statusBarStyle
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    
}

extension InitViewController: LogInViewControllerDelegate {
    func finishedLogin() {
        //bring home to the front
        self.statusBarShouldHidden = false
        self.statusBarStyle = .default
        self.delegate?.homeInit()
        self.view.bringSubview(toFront: self.homeContainerView)
    }
}
