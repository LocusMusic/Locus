//
//  SpotPlaylistTableViewCell.swift
//  Locus
//
//  Created by Xie kesong on 5/13/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

let SpotPlaylistTableViewCellReuseIden = "SpotPlaylistTableViewCell"
let SpotPlaylistTableViewCellNibName = "SpotPlaylistTableViewCell"


class SpotPlaylistTableViewCell: UITableViewCell {
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var favorBtn: FavorButton!
    
    @IBOutlet weak var favorCountLabel: UILabel!
    
    @IBOutlet weak var palylistThumbnailWrapper: UIView!{
        didSet{
            self.palylistThumbnailWrapper.layer.cornerRadius = 4.0
            self.palylistThumbnailWrapper.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var playlistNameLabel: UILabel!
    
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var placeHolderView: UIView!
    
    var playlistPost: PlaylistPost!{
        didSet{
            self.placeHolderView.isHidden = false
            guard let userId = playlistPost.user?.spotifyId else{
                return
            }
            guard let playlistId = playlistPost?.playlistId else{
                return
            }
            self.coverImageView.image = nil
            self.playlistNameLabel?.text = ""
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
            
            //update the favor count label
            self.updateLikeLabelCount()
            
            //Check if user liked the playlistPost already
            self.favorBtn.updateIsFavorApperanceForButton(playlistPost: self.playlistPost)
        }
    }
    
    @IBAction func favorBtnTapped(_ sender: FavorButton) {
        sender.favorPlaylistPost(playlistPost: self.playlistPost)
        self.updateLikeLabelCount()
    }
    
    func updateLikeLabelCount(){
        self.favorCountLabel.text = String(self.playlistPost.likeUsers?.count ?? 0)
    }

    func updateUIWithPlaylist(playlist: Playlist){
        if let user = self.playlistPost.user{
            self.userLabel.text = "Added by " + (user.displayName ?? "")
        }
        if let coverImage = playlist.getCoverImage(withSize: .small){
            if let coverURL = coverImage.url{
                self.coverImageView.loadImageWithURL(coverURL)
            }
        }
        self.playlistNameLabel.text = playlist.name
        self.placeHolderView.isHidden = true
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
