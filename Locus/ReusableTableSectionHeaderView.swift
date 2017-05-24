//
//  ReusableTableSectionHeaderView.swift
//  Locus
//
//  Created by Xie kesong on 5/12/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

fileprivate let xibName = "ReusableTableSectionHeaderView"

class ReusableTableSectionHeaderView: UIView {

    @IBOutlet weak var headerLabel: UILabel!
    
    var title: String!{
        didSet{
            self.headerLabel.text = title
        }
    }
    
    class func instanceFromNib(withTitle title: String) -> ReusableTableSectionHeaderView {
        let view = UINib(nibName: xibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ReusableTableSectionHeaderView
        view.headerLabel.text = ""
        view.headerLabel.text = title
        return view
    }

}
