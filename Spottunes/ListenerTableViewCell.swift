//
//  ListenerTableViewCell.swift
//  Spottunes
//
//  Created by Xie kesong on 5/21/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

class ListenerTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!{
        didSet{
            self.profileImageView.layer.cornerRadius = 24.0
            self.profileImageView.layer.borderColor = App.grayColor.cgColor.copy(alpha: 0.2)
            self.profileImageView.layer.borderWidth = 1.0
            self.profileImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var currentPlaylistLabel: UILabel!
    
    @IBOutlet weak var onlineIndicatorView: UIImageView!
    
    var spot: TuneSpot!
    
    var listenerLikePair: (key: User, value: Int)?{
        didSet{
            if let name = self.listenerLikePair?.key.displayName{
                self.nameLabel.text = name
            }
            self.listenerLikePair?.key.loadUserProfileImage(withCompletion: { (userImage, error) in
                DispatchQueue.main.async {
                    if let image = userImage{
                        self.profileImageView.image = image
                    }
                }
            })
            
            
            guard let userId = self.listenerLikePair?.key.spotifyId else{
                return
            }
            
            self.listenerLikePair?.key.currentListeningPlaylistPost?.refetchPost(completionHandler: { (playlistPost) in
                guard let playlistId = playlistPost?.playlistId else{
                    return
                }
                
                guard let userCurrentListeningSpot = playlistPost?.spot else{
                    return
                }
                
                guard let spotObjectId = self.spot.objectId else{
                    return
                }

                
                guard let userCurrentListeningSpotObjectId = userCurrentListeningSpot.objectId else{
                    return
                }

                
                if spotObjectId == userCurrentListeningSpotObjectId{
                    self.onlineIndicatorView.isHidden = false
                }else{
                    self.onlineIndicatorView.isHidden = true
                }
                
                SpotifyClient.fetchPlaylistByUserIdAndPlaylistId(userId: userId, playlistId: playlistId) { (playlist) in
                    DispatchQueue.main.async {
                        self.currentPlaylistLabel.text = (playlist?.name ?? "")
                    }
                }
            })
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
