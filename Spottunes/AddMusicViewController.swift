//
//  AddMusicViewController.swift
//  Spottunes
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
    func closeBtnTapped(playlistPickerContainerView: UIView)
}

class AddMusicViewController: UIViewController {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var searchIconCenterXConstraint: NSLayoutConstraint!
    
   
}



