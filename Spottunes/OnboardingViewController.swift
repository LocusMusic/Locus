//
//  OnboardingViewController.swift
//  Spottunes
//
//  Created by Xie kesong on 4/23/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

class OnboardingViewController: GradientBackgroundAnimatedViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            self.scrollView.delegate = self
            self.scrollView.isPagingEnabled = true
        }
    }
    
    @IBOutlet weak var pagingControl: UIPageControl!
    
    lazy var scenes = [OnboardingView]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let onboardDiscoverView = OnboardingView.instanceFromNib()
        onboardDiscoverView.backgroundImageView.image = App.Style.Onboard.Discover.backgroundImage
        onboardDiscoverView.actionBtn.setTitle(App.Style.Onboard.Discover.actionBtnTitle, for: .normal)
        
        
//        let recommendedSpotView = RecommendedSpotView.instanceFromNib()
//        onboardDiscoverView.scrollView.contentSize = CGSize(width: App.screenWidth, height: App.screenHeight * 2)
//

//        recommendedSpotView.frame.origin = CGPoint(x: 0, y: App.screenHeight)
//        recommendedSpotView.backgroundColor = UIColor.white
//        print(recommendedSpotView.frame)
//        onboardDiscoverView.scrollView.addSubview(recommendedSpotView)
//        
        
        
        
        let onboardShareView = OnboardingView.instanceFromNib()
        onboardShareView.backgroundImageView.image = App.Style.Onboard.Share.backgroundImage
        onboardShareView.actionBtn.setTitle(App.Style.Onboard.Share.actionBtnTitle, for: .normal)
        
        let onboardListenView = OnboardingView.instanceFromNib()
        onboardListenView.backgroundImageView.image = App.Style.Onboard.Listen.backgroundImage
        onboardListenView.actionBtn.setTitle(App.Style.Onboard.Listen.actionBtnTitle, for: .normal)
        
        scenes.append(onboardDiscoverView)
        scenes.append(onboardShareView)
        scenes.append(onboardListenView)
        
        for (index, promptView) in self.scenes.enumerated(){
            promptView.frame.origin = CGPoint(x: CGFloat(index) * App.screenWidth, y: 0)
            scrollView.addSubview(promptView)
        }
        self.pagingControl.numberOfPages = self.scenes.count
        self.scrollView.contentSize = CGSize(width: App.screenWidth * CGFloat(self.scenes.count), height: App.screenHeight)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension OnboardingViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(round(scrollView.contentOffset.x / App.screenWidth))
        self.pagingControl.currentPage = index
    }
}
