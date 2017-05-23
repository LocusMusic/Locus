//
//  OnboardingView.swift
//  Locus
//
//  Created by Xie kesong on 4/23/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit
import Parse

protocol OnboardingViewDelegate: class {
    func onActionBtnTapped(_ sender: UIButton)
}

fileprivate let xibName = "OnboardingView"

class OnboardingView: UIView {
    
    weak var customDelegate: OnboardingViewDelegate?

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var actionBtn: UIButton!
    
    @IBAction func actionBtnTapped(_ sender: UIButton) {
        if actionBtn.titleLabel?.text == App.Style.Onboard.Discover.actionBtnTitle {
            PFGeoPoint.geoPointForCurrentLocation { (point, error) in
                self.customDelegate?.onActionBtnTapped(sender)
            }
        } else {
            self.customDelegate?.onActionBtnTapped(sender)
        }
    }
    
    class func instanceFromNib() -> OnboardingView {
        let view = UINib(nibName: xibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! OnboardingView
        return view
    }

    
}
