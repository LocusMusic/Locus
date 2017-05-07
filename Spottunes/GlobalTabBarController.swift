//
//  GlobalTabBarController.swift
//  Spottunes
//
//  Created by Xie kesong on 4/25/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

protocol CustomGlobalTabBarControllerDelegate : class {
    func addMusicTapped()
}

class GlobalTabBarController: UITabBarController {
    lazy var playView: PlayView = PlayView.instanceFromNib()
    
    var tabBarOriginalY: CGFloat = 0
    
    weak var customDelegate: CustomGlobalTabBarControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.tintColor = App.Style.TabBar.tintColor
        self.tabBar.barTintColor = App.Style.TabBar.barTintColor
        self.tabBar.isTranslucent = App.Style.TabBar.isTranslucent
        
        UISearchBar.appearance().setImage(#imageLiteral(resourceName: "search-icon"), for: .search, state: .normal)
        
        self.tabBar.layer.borderWidth = 0.50
        self.tabBar.layer.borderColor = App.grayColor.cgColor.copy(alpha: 0.3)
        self.tabBar.clipsToBounds = true
        self.tabBarOriginalY = self.tabBar.frame.origin.y
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playViewShouldShow(_:)), name: App.LocalNotification.PlayViewShouldShow.name, object: nil)
        
        self.playView.frame = CGRect(x: 0, y: App.screenHeight, width: App.screenWidth, height: App.screenHeight)
        self.playView.delegate = self
        self.view.addSubview(playView)
        self.view.bringSubview(toFront: self.tabBar)
    }
    
    func playViewShouldShow(_ notification: Notification){
        guard let trackList = notification.userInfo?[App.LocalNotification.PlayViewShouldShow.tracksKey] as? [Track] else{
            return
        }

        guard let activeTrackIndex = notification.userInfo?[App.LocalNotification.PlayViewShouldShow.activeTrackIndex] as? Int else{
            return
        }
        
        self.playView.trackList = trackList
        self.playView.activeTrackIndex = activeTrackIndex
        self.playView.updateTracksState()
        
        if self.playView.state == .hidden{
            let destinationOriginY = App.screenHeight - 2 * App.Style.MinPlayerView.height
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 6, options: .curveEaseInOut, animations: {
                self.playView.frame.origin.y = destinationOriginY
            }, completion: { (finished) in
                if finished{
                    self.playView.state = .minimized
                }
            })
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}



extension GlobalTabBarController: PlayViewDelegate{
    func panning(playView: PlayView, delta: CGFloat) {
        self.tabBar.frame.origin.y = self.tabBarOriginalY + (1 - delta) * self.tabBar.frame.size.height
    }
    
    func playViewBecomeMaximized(playView: PlayView) {
        self.tabBar.frame.origin.y =  self.tabBarOriginalY +  self.tabBar.frame.size.height
    }
    
    func playViewBecomeMinimized(playView: PlayView) {
        self.tabBar.frame.origin.y =  self.tabBarOriginalY
    }
}

extension GlobalTabBarController: UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if self.viewControllers?.index(of: viewController) == 1{
            //bring up the picker view
            self.customDelegate?.addMusicTapped()
            return false
        }
        return true
    }
}


