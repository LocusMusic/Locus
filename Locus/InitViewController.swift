//
//  InitViewController.swift
//  Locus
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
                User.register(ParseAuthDelegate(), forAuthType: "spotify")
                if let token = session.accessToken {
                    let authData: [String: String] = ["access_token": token, "id" : session.canonicalUsername]
                    User.logInWithAuthType(inBackground: "spotify", authData: authData).continue({ (task) -> AnyObject? in
                        //user is logged in
                        //can use User.current() here bc it's logged in
                        
                        //fetch recently visisted spot
                        guard let currentUser = User.current() else{
                            return nil
                        }
                        currentUser.resetPlayingState()
                        
                        RecentlyVisitedSpot.fetchRecentlyVisitedSpot(forUser: currentUser, completionHandler: { (spots) in
                            if let recentSpots = spots{
                                App.postLocalNotification(withName: App.LocalNotification.Name.recentlyVisitedShouldUpdate)
                                currentUser.recentlyVisitedSpot = recentSpots
                            }
                        })

                        //get the popular tune spot near the current location
                        TuneSpot.getNearbyPopularTuneSpot { (spots) in
                            if let spots = spots{
                                App.delegate?.popularTuneSpot = spots
                                self.view.bringSubview(toFront: self.homeContainerView)
                            }
                        }
                        
                        return nil
                    })
                }else{
                    print("token invalid")
                }
            } else {
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
    
    //Called after logging in with spotify
    func finishedLogin() {
        //Bring either home or onboarding to the front
        self.statusBarShouldHidden = false
        self.statusBarStyle = .default
        if let key = UserDefaults.standard.object(forKey: App.UserDefaultKey.firstTimeUser){
            print(key)
            self.delegate?.homeInit()
            self.view.bringSubview(toFront: self.homeContainerView)
        } else {
            print("DOESNT EXIST")
            if let onboardingVC = App.mainStoryBoard.instantiateViewController(withIdentifier: App.StoryboardIden.onboardViewController) as? OnboardingViewController {
                onboardingVC.onboardingDelegate = self
//                self.navigationController?.pushViewController(onboardingVC, animated: true)
                present(onboardingVC, animated: true, completion: {
                    print("Finished Presenting")
                })
            }
        }
    }
}

extension InitViewController: OnboardingViewControllerDelegate {
    func homeInit() {
        print("Called homeInit")
        self.delegate?.homeInit()
        self.view.bringSubview(toFront: self.homeContainerView)
    }
}

