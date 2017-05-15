//
//  StreamingEmbedViewController.swift
//  Spottunes
//
//  Created by Xie kesong on 5/12/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

protocol StreamingEmbedViewControllerDelegate: UIPageViewControllerDelegate {
    func willTransitionToPage(viewController: UIViewController, pageIndex: Int)
}

class StreamingEmbedViewController: UIPageViewController {

    lazy var childControllers: [UIViewController] = {
        let queueVC = App.streammingStoryBoard.instantiateViewController(withIdentifier: App.StreammingStoryboradIden.queueViewController)
        
        let spotVC = App.streammingStoryBoard.instantiateViewController(withIdentifier: App.StreammingStoryboradIden.connectedSpotViewController)
        
        return [queueVC, spotVC]
    }()
    
    weak var customDelegate: StreamingEmbedViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.spotPageShouldBecomeActive(_:)), name: App.LocalNotification.Name.streamingSpotShouldBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.queuePageShouldBecomeActive(_:)), name: App.LocalNotification.Name.streamingQueueShouldBecomeActive, object: nil)
        self.setSpotPageActive()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setSpotPageActive(){
        if let spotVC = self.childControllers.first{
            self.setViewControllers([spotVC], direction: .reverse, animated: true, completion: nil)
        }
    }
    
    func setQueuePageActive(){
        let queueVC = self.childControllers[1]
        self.setViewControllers([queueVC], direction: .forward, animated: true, completion: nil)
    }
    
    func spotPageShouldBecomeActive(_ notification: Notification){
        self.setSpotPageActive()
    }
    
    func queuePageShouldBecomeActive(_ notification: Notification){
        self.setQueuePageActive()
    }
}

extension StreamingEmbedViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
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
