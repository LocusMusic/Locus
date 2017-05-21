//
//  AddMusicViewController.swift
//  Locus
//
//  Created by Xie kesong on 5/4/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

fileprivate let addMusicEmbedSegueIden = "AddMusicEmbedSegueIden"
fileprivate let globalTabBarEmbedSegueIden = "GlobalTabBarEmbedSegueIden"
fileprivate let spotThumbnailReuseIden = "SpotThumbnailReuseIden"
fileprivate let spotThumbnailNibName = "SpotThumbnailCollectionViewCell"


protocol AddMusicViewControllerDelegate : class {
    func keyboardDidShow(keyboardSize: CGSize)
    func keyboardWillHide()
    func didSelectSpot(spot: TuneSpot)
    func addMusicBoxShouldClose()
}

class AddMusicViewController: UIViewController {
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!{
        didSet{
            self.navigationBar.updateNavigationBarAppearance()
            let titleFont = UIFont(name: "Avenir-Medium", size: 17.0)!
            self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: App.grayColor, NSFontAttributeName: titleFont]
        }
    }
    
    weak var delegate: AddMusicViewControllerDelegate?

    @IBAction func crossIconTapped(_ sender: UIBarButtonItem) {
        self.delegate?.addMusicBoxShouldClose()
    }

    @IBAction func createBtnTapped(_ sender: UIButton) {
        self.delegate?.addMusicBoxShouldClose()
        self.performSegue(withIdentifier: App.SegueIden.selectSpotSegue, sender: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var searchIconCenterXConstraint: NSLayoutConstraint!
    
   
}



