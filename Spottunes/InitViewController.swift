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
            print(loginViewController)
        }
    }
    var homeWrapperViewController: HomeWrapperViewController?{
        didSet{
            print(homeWrapperViewController)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if SpotifyClient.session != nil {
            print("session exsited")
            
        } else {
            print("GO TO LOGIN PAGE")
            //TODO Go to login page
        }
        // Do any additional setup after loading the view.
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
