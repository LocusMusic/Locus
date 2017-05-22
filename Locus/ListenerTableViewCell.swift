//
//  ListenerTableViewCell.swift
//  Locus
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
    
    
    @IBOutlet weak var playingStatusStackView: UIStackView!
    
    var spot: TuneSpot!
    
    @IBOutlet weak var listenStatusLabel: UILabel!
    
    
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
                    if self.isListening(){
                        self.onlineIndicatorView.isHidden = false
                    }else{
                        self.onlineIndicatorView.isHidden = true
                    }
                }
                
                SpotifyClient.fetchPlaylistByUserIdAndPlaylistId(userId: userId, playlistId: playlistId) { (playlist) in
                    DispatchQueue.main.async {
                        self.currentPlaylistLabel.text = (playlist?.name ?? "")
                        if self.isListening(){
                            self.setListenStatus(status: .listening)
                        }else{
                            self.setListenStatus(status: .listened)
                        }
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
    
    
    private enum ListenStatus: String{
        case listening = "Listening: "
        case listened = "Listened to: "
    }

    private func setListenStatus(status: ListenStatus){
        self.listenStatusLabel.text = status.rawValue
    }
    
    func isListening() -> Bool{
        if let currentActiveIndex = self.listenerLikePair?.key.currentActiveTrackIndex, currentActiveIndex != -1 {
            return true
        }
        return false
    }
    
}
