//
//  HomePageViewController.swift
//  Locus
//
//  Created by Xie kesong on 4/28/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit



protocol HomeEmbedPageViewControllerDelegate: UIPageViewControllerDelegate {
    func willTransitionToPage(viewController: UIViewController, pageIndex: Int)
}

class HomeEmbedPageViewController: UIPageViewController{

    lazy var childControllers: [UIViewController] = {
        let overViewVC = App.mainStoryBoard.instantiateViewController(withIdentifier: App.StoryboardIden.overviewViewController)
        return [overViewVC]
    }()
    
    weak var customDelegate: HomeEmbedPageViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        
        
        
        //add notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.overviewPageShouldBecomeActive(_:)), name: App.LocalNotification.Name.homeOverviewShouldBecomeActive, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.playingPageShouldBecomeActive(_:)), name: App.LocalNotification.Name.homePlayingShouldBecomeActive, object: nil)
        
        self.setOverviewPageActive()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setOverviewPageActive(){
        if let overViewVC = self.childControllers.first{
            self.setViewControllers([overViewVC], direction: .reverse, animated: true, completion: nil)
        }
    }
    
//    func setPlayingPageActive(){
//        let playingVC = self.childControllers[1]
//        self.setViewControllers([playingVC], direction: .forward, animated: true, completion: nil)
//    }

    
    func overviewPageShouldBecomeActive(_ notification: Notification){
       self.setOverviewPageActive()
    }

//    func playingPageShouldBecomeActive(_ notification: Notification){
//        self.setPlayingPageActive()
//    }
}

extension HomeEmbedPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
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

