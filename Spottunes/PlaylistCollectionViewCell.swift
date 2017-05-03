//
//  PlaylistCollectionViewCell.swift
//  Spottunes
//
//  Created by Xie kesong on 4/29/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

class PlaylistCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!{
        didSet{
            self.thumbnailImageView.layer.cornerRadius = 4.0
            self.thumbnailImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var playListNameLabel: UILabel!
    
    var Playlist: Playlist!{
        didSet{
//            self.thumbnailImageView.image = nil
//            if let thumbURL = self.Playlist.coverURL{
//                self.thumbnailImageView.image = UIImage(named: thumbURL)
//            }
//            if let genreName = self.Playlist.name{
//                self.playListNameLabel.text = genreName
//            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}


