//
//  GlobalViewController.swift
//  Instagram
//
//  Created by Xie kesong on 3/7/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit


fileprivate let tunesDetailSgueIden = "TunesDetailSgueIden"

protocol HomeWrapperViewControllerDelegate: class{
    func statusBarShouldUpdate(statusBarAnimation:UIStatusBarAnimation, prefersStatusBarHidden: Bool )
    
}

class HomeWrapperViewController: UIViewController {

    @IBOutlet weak var TunesDetailContainerView: UIView!
    
    var tunesDetailVC: TunesDetailsViewController?{
        didSet{
            print("tunes detail set")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let iden = segue.identifier{
            switch iden {
            case tunesDetailSgueIden:
                if let tunesDetailVC = segue.destination as? TunesDetailsViewController{
                    self.tunesDetailVC = tunesDetailVC
                }
            default:
                break
            }
        }
    }
}


