//
//  SpotPlaylistTableViewCell.swift
//  Spottunes
//
//  Created by Xie kesong on 5/13/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

class SpotPlaylistTableViewCell: UITableViewCell {
    @IBOutlet weak var coverImageView: UIImageView!{
        didSet{
            self.coverImageView.layer.cornerRadius = 4.0
            self.coverImageView.clipsToBounds = true
        }
    }
    
    
    @IBOutlet weak var palylistThumbnailWrapper: UIView!{
        didSet{
            self.palylistThumbnailWrapper.layer.cornerRadius = 4.0
            self.palylistThumbnailWrapper.clipsToBounds = true
        }
        
    }
    
    
    
    @IBOutlet weak var playlistNameLabel: UILabel!
    
    @IBOutlet weak var userLabel: UILabel!
    
    
    var playlistPost: PlaylistPost!{
        didSet{
            guard let userId = playlistPost.user?.spotifyId else{
                return
            }
            guard let playlistId = playlistPost?.playlistId else{
                return
            }
            if let user = self.playlistPost.user{
                self.userLabel.text = user.displayName
            }
            self.coverImageView.image = nil
            if let playlist = self.playlistPost.playlist{
                //no need to re-fetch
                self.updateUIWithPlaylist(playlist: playlist)
            }else{
                SpotifyClient.fetchPlaylistByUserIdAndPlaylistId(userId: userId, playlistId: playlistId) { (playlist) in
                    DispatchQueue.main.async {
                        if let playlist = playlist{
                            self.playlistPost.playlist = playlist
                            self.updateUIWithPlaylist(playlist: playlist)
                        }
                    }
                }

            }
        }
    }
    
    func updateUIWithPlaylist(playlist: Playlist){
        if let coverImage = playlist.getCoverImage(withSize: .small){
            if let coverURL = coverImage.url{
                self.coverImageView.loadImageWithURL(coverURL)
            }
        }
        
        self.playlistNameLabel.text = playlist.name

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
