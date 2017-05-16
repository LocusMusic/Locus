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
    
    @IBOutlet weak var likeButton: UIButton!
    
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
            
            //Check if user liked the playlistPost already
            guard let isFavored = self.playlistPost.isFavored else{
                return
            }
            
            if isFavored {
                self.likeButton.imageBtnActivateWithColor(color: App.Style.Color.heartActiveColor)
            } else {
                self.likeButton.imageBtnActivateWithColor(color: App.Style.Color.heartInactiveColor)
            }
        }
    }
    
    @IBAction func likeBtnTapped(_ sender: UIButton) {
        //Save to ParseDB
        //Add likes key, where likes key = [User]
        //Change the button color (depends on if User likes/unlikes)
        sender.isEnabled = false
        
        guard let currentUser = App.delegate?.currentUser else{
            return
        }
        
        guard let currenrtLikeUser = self.playlistPost.likeUsers else {
            return
        }
        
        guard let isFavored = self.playlistPost.isFavored else{
            return
        }
        
        
        if isFavored {
            print("Contains current user")
            //remove from like user
            
            sender.imageBtnActivateWithColor(color: App.Style.Color.heartInactiveColor)
            
            let newUsers = currenrtLikeUser.filter({ (user) -> Bool in
                return user != currentUser
            })
            print(newUsers)
            
            self.playlistPost.likeUsers = newUsers
            
            
            self.playlistPost.saveInBackground(block: { (success, error) in
                if !success {
                    print(error)
                } else {
                    print("SUCCESSFUL SAVE")
                    sender.isEnabled = true
                }
            })
            
        } else {
        
            print("Doesnt contain current user")
            print( currenrtLikeUser)
            self.playlistPost.likeUsers?.append(currentUser)
            print("after")
            print(self.playlistPost.likeUsers)
            
            sender.imageBtnActivateWithColor(color: App.Style.Color.heartActiveColor)
            
            self.playlistPost.saveInBackground(block: { (success, error) in
                if !success {
                    print(error ?? "")
                } else {
                    print("SUCCESSFUL SAVE")
                    sender.isEnabled = true
                }
            })

        }
    }
    
    func updateUIWithPlaylist(playlist: Playlist){
        if let user = self.playlistPost.user{
            self.userLabel.text = user.displayName
        }
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
