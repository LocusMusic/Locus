//
//  SearchTableViewCell.swift
//  Spottunes
//
//  Created by Leo Wong on 5/4/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!{
        didSet {
            self.thumbnailImageView.layer.cornerRadius = 4.0
            self.thumbnailImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var data: Any! {
        didSet {
            if let songs = self.data as? Track {
                print(songs)
            } else if let artists = self.data as? Artist {
                print(artists)
            } else if let playlists = self.data as? Playlist {
                print(playlists)
            } else if let spots = self.data as? TuneSpot {
                print(spots)
            }
        }
    }
    
    var track: Track!{
        didSet{
            if let name = self.track.name{
                self.titleLabel.text = name
            }
            
            if let authorName = self.track.artists?.first?.name {
                self.subtitleLabel.text = authorName
            }
            
            if let coverImage = self.track.getCoverImage(withSize: .small) {
                if let coverURL = coverImage.url {
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
    }
}
