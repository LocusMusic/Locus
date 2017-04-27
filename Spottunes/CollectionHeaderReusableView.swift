//
//  RecommendationCollectionReusableView.swift
//  Spottunes
//
//  Created by Xie kesong on 4/25/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

class CollectionHeaderReusableView: UICollectionReusableView {
    @IBOutlet weak var headerLabel: UILabel!

    var title: String!{
        didSet{
            self.headerLabel.text = title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
}
