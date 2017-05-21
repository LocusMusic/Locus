//
//  PlaylistTableViewCell.swift
//  Locus
//
//  Created by Xie kesong on 5/4/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

class PlaylistTableViewCell: UITableViewCell {

    @IBOutlet weak var coverImageView: UIImageView!{
        didSet{
            self.coverImageView.layer.cornerRadius = 4.0
            self.coverImageView.clipsToBounds = true
        }
    }
    
    
    @IBOutlet weak var playlistNameLabel: UILabel!

    @IBOutlet weak var numberOfSongsLabel: UILabel!


    var playlist: Playlist!{
        didSet{
            self.coverImageView.image = nil
            if let coverImage = self.playlist.getCoverImage(withSize: .small){
                if let coverURL = coverImage.url{
                    self.coverImageView.loadImageWithURL(coverURL)
                }
            }
            self.numberOfSongsLabel.text = playlist.trackCountString
            self.playlistNameLabel.text = self.playlist.name
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
