//
//  ReusableViewAllFooterView.swift
//  Locus
//
//  Created by Xie kesong on 5/15/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit


fileprivate let xibName = "ReusableViewAllFooterView"

class ReusableViewAllFooterView: UIView {
    class func instanceFromNib() -> ReusableViewAllFooterView {
        let view = UINib(nibName: xibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ReusableViewAllFooterView
        return view
    }
}
