//
//  SpotThumbnailCollectionViewCell.swift
//  Spottunes
//
//  Created by Xie kesong on 4/25/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

class SpotThumbnailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!{
        didSet{
            self.thumbImageView.layer.cornerRadius = 4.0
            self.thumbImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var spotNameLabel: UILabel!
    
    var spot: TuneSpot!{
        didSet{
//            self.thumbImageView.image = nil
//            if let thumbURL = spot.thumbnailURL{
//                self.thumbImageView.image = UIImage(named: thumbURL)
//            }
            if let spotName = spot.name{
                self.spotNameLabel.text = spotName
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
