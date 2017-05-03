//
//  NavigationHeaderView.swift
//  Spottunes
//
//  Created by Xie kesong on 4/29/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

fileprivate let xibName = "NavigationHeaderView"

protocol NavigationHeaderViewDelegate: class {
    func backBtnTapped(header: NavigationHeaderView)
}

class NavigationHeaderView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var backBtn: UIButton!{
        didSet{
            self.backBtn.imageBtnActivateWithColor(color: App.backColor)
            self.backBtn.animateBounceView(scale: 0.6)
        }
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.delegate?.backBtnTapped(header: self)
    }
    
    weak var delegate: NavigationHeaderViewDelegate?

    
    class func instanceFromNib(withTitle title: String) -> NavigationHeaderView {
        let view = UINib(nibName: xibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! NavigationHeaderView
        view.titleLabel.text = title
        return view
    }
}
