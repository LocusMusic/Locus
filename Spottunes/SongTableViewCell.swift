//
//  SongTableViewCell.swift
//  Spottunes
//
//  Created by Xie kesong on 4/27/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!{
        didSet{
            self.thumbnailImageView.layer.cornerRadius = 4.0
            self.thumbnailImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var songNameLabel: UILabel!
    

    @IBOutlet weak var artistNameLabel: UILabel!
    
    var track: Track!{
        didSet{
            if let name = self.track.name{
                self.songNameLabel.text = name
            }
            
            if let authorName = self.track.artists?.first?.name{
                self.artistNameLabel.text = authorName
            }
            self.thumbnailImageView.image = nil
            if let coverImage = self.track.getCoverImage(withSize: .small){
                if let coverURL = coverImage.url{
                    self.thumbnailImageView.loadImageWithURL(coverURL)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
