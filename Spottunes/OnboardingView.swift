//
//  OnboardingView.swift
//  Spottunes
//
//  Created by Xie kesong on 4/23/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

protocol OnboardingViewDelegate: class {
    func onActionBtnTapped()
}

fileprivate let xibName = "OnboardingView"

class OnboardingView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var actionBtn: UIButton!
    
    @IBAction func actionBtnTapped(_ sender: UIButton) {
        
    }
  
    class func instanceFromNib() -> OnboardingView {
        let view = UINib(nibName: xibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! OnboardingView
        return view
    }

    
}
