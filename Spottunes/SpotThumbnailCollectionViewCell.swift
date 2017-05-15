//
//  SpotThumbnailCollectionViewCell.swift
//  Spottunes
//
//  Created by Xie kesong on 4/25/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

protocol SpotThumbnailCollectionViewCellDelegate: class {
    func spotThumbnailImageViewImageTapped(spot: TuneSpot)
}

class SpotThumbnailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!{
        didSet{
            self.thumbnailImageView.layer.cornerRadius = 4.0
            self.thumbnailImageView.clipsToBounds = true
            self.thumbnailImageView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(spotThumnailTapped(_:)))
            self.thumbnailImageView.addGestureRecognizer(tapGesture)
        }
    }

    
    @IBOutlet weak var nameLabel: UILabel!
    
    weak var delegate: SpotThumbnailCollectionViewCellDelegate?
    
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
    }
    
    func spotThumnailTapped(_ gesture: UITapGestureRecognizer){
        self.delegate?.spotThumbnailImageViewImageTapped(spot: self.spot)
    }
    


}
