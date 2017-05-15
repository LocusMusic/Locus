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
            if let song = self.data as? Track {
                
                if let name = song.name{
                    self.titleLabel.text = name
                }
                
                if let authorName = song.artists?.first?.name {
                    self.subtitleLabel.text = authorName
                }
                
                if let coverImage = song.getCoverImage(withSize: .small) {
                    if let coverURL = coverImage.url {
                        self.thumbnailImageView.loadImageWithURL(coverURL)
                    }
                }
                
            } else if let artist = self.data as? Artist {
                
                if let name = artist.name {
                    self.titleLabel.text = name
                }
                
                self.subtitleLabel.text = "\(artist.followers) Followers"
                
                if let artistImage = artist.getArtistImage(withSize: .small) {
                    if let imageURL = artistImage.url {
                        self.thumbnailImageView.loadImageWithURL(imageURL)
                    }
                }
                
            } else if let playlist = self.data as? Playlist {
                
                if let name = playlist.name {
                    self.titleLabel.text = name
                }
                
                self.subtitleLabel.text = "\(playlist.trackCount!) Tracks"
                
                if let playlistImage = playlist.getCoverImage(withSize: .small) {
                    if let imageURL = playlistImage.url {
                        self.thumbnailImageView.loadImageWithURL(imageURL)
                    }
                }

            } else if let spots = self.data as? TuneSpot {
                print(spots)
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
