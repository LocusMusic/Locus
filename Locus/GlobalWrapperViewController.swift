//
//  GlobalWrapperViewController.swift
//  Locus
//
//  Created by Xie kesong on 5/4/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit
import Parse


class GlobalWrapperViewController: UIViewController {

    @IBOutlet weak var addMusicConatainerView: UIView!{
        didSet{
            self.addMusicConatainerView.layer.cornerRadius = App.Style.AddMusicConatainerView.minimizedCornerRadius
            self.addMusicConatainerView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var tabBarContainerView: UIView!
    
    @IBOutlet weak var overlayView: UIView!
    
    @IBAction func overlayViewTapped(_ sender: UITapGestureRecognizer) {
       self.closeAddMusicBox()
    }
    
    var addMusicConatinerViewOriginalFrame: CGRect!
    
    var addMusicOpenOriginalY: CGFloat = 0
    
    var addMusicVC: AddMusicViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.addMusicConatainerView.frame = CGRect(x: 0, y: App.screenHeight, width: App.screenWidth, height: App.screenHeight)
        self.addMusicConatinerViewOriginalFrame = self.addMusicConatainerView.frame
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let iden = segue.identifier{
            switch iden{
            case App.SegueIden.addMusicEmbedSegueIden:
                if let addMusicVC = segue.destination as? AddMusicViewController{
                    addMusicVC.delegate = self
                    self.addMusicVC = addMusicVC
                }
            case App.SegueIden.globalTabBarEmbedSegueIden:
                if let globalTabBarVC = segue.destination as? GlobalTabBarController{
                    globalTabBarVC.customDelegate = self
                }

            default:
                break
            }
        }
    }
    
    func closeAddMusicBox(){
        //dismiss the add music box
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.addMusicConatainerView.frame = self.addMusicConatinerViewOriginalFrame
            self.overlayView.alpha = 0
            self.tabBarContainerView.transform = .identity
        }, completion: { finished in
            if finished{
                self.addMusicConatainerView.layer.cornerRadius = App.Style.AddMusicConatainerView.minimizedCornerRadius
                self.overlayView.isHidden = true
                self.addMusicConatainerView.isHidden = true
            }
        })
    }
    
    func openAddMusicBox(){
        //bring up the add music container view
        self.addMusicConatainerView.isHidden = false
        self.overlayView.isHidden = false
        self.overlayView.alpha = 0
        let zoomOutTransform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.addMusicConatainerView.frame = CGRect(x: 0, y: App.screenHeight - 190, width: App.screenWidth, height:190)
            self.overlayView.alpha = 0.8
            self.tabBarContainerView.transform = zoomOutTransform
        }, completion: {
            finished in
            if finished{
                self.addMusicOpenOriginalY = self.addMusicConatainerView.frame.origin.y
            }
        })
    }
}


extension GlobalWrapperViewController: AddMusicViewControllerDelegate{
    func keyboardDidShow(keyboardSize: CGSize) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.addMusicConatainerView?.frame.origin.y = self.addMusicOpenOriginalY - keyboardSize.height
        }, completion: nil)
    }
    
    func keyboardWillHide() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.addMusicConatainerView?.frame.origin.y = self.addMusicConatinerViewOriginalFrame.origin.y
        }, completion: nil)
    }
    
    func didSelectSpot(spot: TuneSpot) {
        let userInfo: [String : Any] = [
            App.LocalNotification.UpdatePlaylistPickerAfterSpotSelected.spotKey: spot
        ]
        App.postLocalNotification(withName: App.LocalNotification.UpdatePlaylistPickerAfterSpotSelected.name, object: self, userInfo: userInfo)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.addMusicConatainerView.frame = CGRect(x: 0, y: 0, width: App.screenWidth, height: App.screenHeight)
            self.addMusicConatainerView.layer.cornerRadius = 0
        }, completion: nil)
    }
    
    func addMusicBoxShouldClose() {
        self.closeAddMusicBox()
    }
}

extension GlobalWrapperViewController: CustomGlobalTabBarControllerDelegate{
    func addMusicTapped() {
        self.openAddMusicBox()
    }
}

extension GlobalWrapperViewController: InitViewControllerDelegate{
    func homeInit() {
//        self.tunesDetailVC?.initPlayer()
    }
}



