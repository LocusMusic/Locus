//
//  SmartGenreCollectionViewCell.swift
//  Locus
//
//  Created by Xie kesong on 4/25/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

class SmartGenreCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var thumbnailImageView: UIImageView!{
        didSet{
            self.thumbnailImageView.layer.cornerRadius = 4.0
            self.thumbnailImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var genreNameLabel: UILabel!
    
    var genre: Genre!{
        didSet{
            self.thumbnailImageView.image = nil
            if let thumbURL = self.genre.thumbnailURL{
                self.thumbnailImageView.image = UIImage(named: thumbURL)
            }
            if let genreName = self.genre.name{
                self.genreNameLabel.text = genreName
            }

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
