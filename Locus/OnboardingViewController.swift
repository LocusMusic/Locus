//
//  OnboardingViewController.swift
//  Locus
//
//  Created by Xie kesong on 4/23/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

protocol OnboardingViewControllerDelegate: class {
    func homeInit()
}

class OnboardingViewController: GradientBackgroundAnimatedViewController {
    
    weak var onboardingDelegate: OnboardingViewControllerDelegate?
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            self.scrollView.delegate = self
            self.scrollView.isPagingEnabled = true
        }
    }
    
    @IBOutlet weak var pagingControl: UIPageControl!
    
    weak var initViewControllerDelegate: InitViewControllerDelegate?
    
    lazy var scenes = [OnboardingView]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let onboardDiscoverView = OnboardingView.instanceFromNib()
        onboardDiscoverView.backgroundImageView.image = App.Style.Onboard.Discover.backgroundImage
        onboardDiscoverView.actionBtn.setTitle(App.Style.Onboard.Discover.actionBtnTitle, for: .normal)
        onboardDiscoverView.customDelegate = self
        
        let onboardShareView = OnboardingView.instanceFromNib()
        onboardShareView.backgroundImageView.image = App.Style.Onboard.Share.backgroundImage
        onboardShareView.actionBtn.setTitle(App.Style.Onboard.Share.actionBtnTitle, for: .normal)
        onboardShareView.customDelegate = self
        
        let onboardListenView = OnboardingView.instanceFromNib()
        onboardListenView.backgroundImageView.image = App.Style.Onboard.Listen.backgroundImage
        onboardListenView.actionBtn.setTitle(App.Style.Onboard.Listen.actionBtnTitle, for: .normal)
        onboardListenView.customDelegate = self
        
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
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(round(scrollView.contentOffset.x / App.screenWidth))
        self.pagingControl.currentPage = index
    }
}

extension OnboardingViewController: OnboardingViewDelegate {
    
    func onActionBtnTapped(_ sender: UIButton) {
        if sender.titleLabel?.text == App.Style.Onboard.Discover.actionBtnTitle {
            print("Discover")
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.scrollView.contentOffset.x = self.scrollView.contentOffset.x + App.screenWidth
            })
        } else if sender.titleLabel?.text == App.Style.Onboard.Share.actionBtnTitle {
            print("Share")
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.scrollView.contentOffset.x = self.scrollView.contentOffset.x + App.screenWidth
            })
        } else {
            if let key = UserDefaults.standard.object(forKey: App.UserDefaultKey.firstTimeUser){
                print(key)
            } else {
                print("Setting key to false")
                UserDefaults.standard.set(false, forKey: App.UserDefaultKey.firstTimeUser)
            }

            dismiss(animated: true, completion: {
                print("Dismissed onboarding view controller")
                self.onboardingDelegate?.homeInit()
            })
        }
    }
}
