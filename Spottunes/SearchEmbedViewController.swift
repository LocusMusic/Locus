//
//  SearchEmbedViewController.swift
//  Spottunes
//
//  Created by Leo Wong on 5/3/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

class SearchEmbedViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    lazy var childControllers: [UIViewController] = {
        let overViewVC = App.mainStoryBoard.instantiateViewController(withIdentifier: App.StoryboardIden.overviewViewController)
        
        let playingVC = App.mainStoryBoard.instantiateViewController(withIdentifier: App.StoryboardIden.playingViewController)
        
        return [overViewVC, playingVC]
    }()
    
    weak var customDelegate: HomeEmbedPageViewControllerDelegate?
    
    var currentPageIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        //add notifications
        NotificationCenter.default.addObserver(self, selector: #selector(self.songPageShouldBecomeActive(_:)), name: App.LocalNotification.Name.searchSongShouldBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.artistPageShouldBecomeActive(_:)), name: App.LocalNotification.Name.searchArtistsShouldBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playlistPageShouldBecomeActive(_:)), name: App.LocalNotification.Name.searchPlaylistsShouldBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.spotPageShouldBeActive(_:)), name: App.LocalNotification.Name.searchSpotsShouldBecomeActive, object: nil)
        
        self.setSongPageActive()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setSongPageActive(){
        if let songVC = self.childControllers.first {
            self.setViewControllers([songVC], direction: .reverse, animated: true, completion: nil)
        }
    }
    
    func setArtistPageActive(){
        let artistVC = self.childControllers[1]
        self.setViewControllers([artistVC], direction: .forward, animated: true, completion: nil)
    }
    
    func setPlaylistPageActive(){
        let playlistVC = self.childControllers[2]
        self.setViewControllers([playlistVC], direction: .forward, animated: true, completion: nil)
    }
    
    func setSpotPageActive(){
        let spotVC = self.childControllers[3]
        self.setViewControllers([spotVC], direction: .forward, animated: true, completion: nil)
    }
    
    func songPageShouldBecomeActive(_ notification: Notification){
        self.setSongPageActive()
    }
    
    func artistPageShouldBecomeActive(_ notification: Notification){
        self.setArtistPageActive()
    }
    
    func playlistPageShouldBecomeActive(_ notification: Notification){
        self.setPlaylistPageActive()
    }

    func spotPageShouldBeActive(_ notification: Notification){
        self.setSpotPageActive()
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = self.childControllers.index(of: viewController) else{
            return nil
        }
        let prevIndex = max(currentIndex - 1, 0)
        return currentIndex == prevIndex ? nil : self.childControllers[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = self.childControllers.index(of: viewController) else{
            return nil
        }
        let nextIndex = min(currentIndex + 1, self.childControllers.count - 1)
        return  currentIndex == nextIndex ? nil : self.childControllers[nextIndex]
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed{
            if let prevVC = previousViewControllers.first{
                if let index = self.childControllers.index(of: prevVC){
                    self.currentPageIndex = (index + 1)%2
                    self.customDelegate?.willTransitionToPage(viewController: self.childControllers[self.currentPageIndex], pageIndex: self.currentPageIndex)
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
