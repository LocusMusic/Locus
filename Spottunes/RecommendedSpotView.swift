//
//  RecommendedSpotView.swift
//  Spottunes
//
//  Created by Xie kesong on 4/24/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit


fileprivate let xibName = "RecommendedSpotView"

class RecommendedSpotView: UIView {
    
    class func instanceFromNib() -> RecommendedSpotView {
        let view = UINib(nibName: xibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RecommendedSpotView
        return view
    }
    


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
