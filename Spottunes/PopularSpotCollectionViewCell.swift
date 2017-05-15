//
//  PopularSpotCollectionViewCell.swift
//  Spottunes
//
//  Created by Xie kesong on 5/11/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

class PopularSpotCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!{
        didSet{
            self.thumbnailImageView.layer.cornerRadius = 4.0
            self.thumbnailImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var spot: TuneSpot!{
        didSet{
            if let name = self.spot?.name{
                self.nameLabel.text = name
            }
            self.thumbnailImageView?.image = #imageLiteral(resourceName: "location-icon")
            if let coverURL = self.spot?.coverURL{
                self.thumbnailImageView.loadImageWithURL(coverURL)
            }
        }
    }
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }}
