//
//  SpotEmbedPagingViewController.swift
//  Spottunes
//
//  Created by Xie kesong on 5/15/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit


protocol SpotEmbedPagingViewControllerDelegate: UIPageViewControllerDelegate {
    func willTransitionToPage(viewController: UIViewController, pageIndex: Int)
}

class SpotEmbedPagingViewController: UIPageViewController {
    
    lazy var childControllers: [UIViewController] = {
       return [self.topPlaylistVC, self.listenerVC]
    }()
    
    lazy var topPlaylistVC : TopPlaylistViewController = {
        return App.spotStoryBoard.instantiateViewController(withIdentifier: App.SpotStoryboardIden.topPlaylistViewController) as! TopPlaylistViewController
    }()
    
    
    lazy var listenerVC : ListenerViewController = {
        return App.spotStoryBoard.instantiateViewController(withIdentifier: App.SpotStoryboardIden.listenerViewController) as! ListenerViewController
    }()

    
    var parentScrollView: UIScrollView?{
        didSet{
            self.topPlaylistVC.parentScrollView = parentScrollView
        }
    }
    
    var playlistsPost: [PlaylistPost]?{
        didSet{
            self.topPlaylistVC.playlistPosts = playlistsPost
        }
    }
    
    var listenerLikeReceivedPairs:  [(key: User, value: Int)]?{
        didSet{
            self.listenerVC.listenerLikeReceivedPairs = listenerLikeReceivedPairs
        }

    }
    
    
    
    weak var customDelegate: SpotEmbedPagingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        self.setTopPlaylistPageActive()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTopPlaylistPageActive(){
        if let topPlaylistVC = self.childControllers.first{
            self.setViewControllers([topPlaylistVC], direction: .reverse, animated: true, completion: nil)
        }
    }
    
    func setListenerPageActive(){
        let listenerVC = self.childControllers[1]
        self.setViewControllers([listenerVC], direction: .forward, animated: true, completion: nil)
    }
    
    func topPlaylistPageShouldBecomeActive(_ notification: Notification){
        self.setTopPlaylistPageActive()
    }
    
    func listenerPageShouldBecomeActive(_ notification: Notification){
        self.setListenerPageActive()
    }
}

extension SpotEmbedPagingViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
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
            if let selectedVC = self.viewControllers?.first{
                if let inedex = self.childControllers.index(of: selectedVC){
                    self.customDelegate?.willTransitionToPage(viewController: self.childControllers[inedex], pageIndex: inedex)
                }
            }
        }
    }
}

