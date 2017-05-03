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

protocol InitViewControllerDelegate: class {
    func homeInit()
}

class InitViewController: UIViewController {
    
    var statusBarShouldHideen = true

    //container view
    @IBOutlet weak var loginContainerView: UIView!
    @IBOutlet weak var homeContainerView: UIView!
    
    //embed view controller
    var loginViewController: LogInViewController?{
        didSet{
            self.loginViewController?.delegate = self
        }
    }
    var homeWrapperViewController: HomeWrapperViewController?{
        didSet{
            self.delegate = homeWrapperViewController
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
        SpotifyClient.updateSession { (session) in

            if session != nil{
                print("session exsited")
                SpotifyClient.fetchCurrentUserPlayList({ (playlists) in
                    if let playlists = playlists{
//                        playlists.first?.savePlaylist()
                    }else{
                        print("play list is empty")
                    }
                })
                print("GO TO LOGIN PAGE")
                self.statusBarShouldHidden = true
            }
        }
    }

    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return self.statusBarStyle
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

extension InitViewController: LogInViewControllerDelegate {
    func finishedLogin() {
        
        //bring home to the front
        self.statusBarShouldHidden = false
        self.statusBarStyle = .lightContent
        self.delegate?.homeInit()
//        self.view.bringSubview(toFront: self.homeContainerView)
    }
}
