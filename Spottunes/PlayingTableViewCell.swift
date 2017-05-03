//
//  PlayingTableViewCell.swift
//  Spottunes
//
//  Created by Xie kesong on 4/27/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

class PlayingTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!{
        didSet{
            self.thumbnailImageView.layer.cornerRadius = 4.0
            self.thumbnailImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var songNameLabel: UILabel!
    

    @IBOutlet weak var artistNameLabel: UILabel!
    
    var song: Song!{
        didSet{
            if let name = self.song.name{
                self.songNameLabel.text = name
            }
            
            if let authorName = self.song.author{
                self.artistNameLabel.text = authorName
            }

            let Playlist = self.song.Playlist
//            if let thumbnailURL = Playlist.coverURL{
//                self.thumbnailImageView.image = UIImage(named: thumbnailURL)
//            }
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
