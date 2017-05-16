//
//  FavorButton.swift
//  Spottunes
//
//  Created by Xie kesong on 5/16/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

class FavorButton: UIButton {

    //update favor button appearance based on isFavored or not
    func updateIsFavorApperanceForButton(playlistPost: PlaylistPost){
        //Check if user liked the playlistPost already
        guard let isFavored = playlistPost.isFavored else{
            return
        }
        if isFavored {
            self.imageBtnActivateWithColor(color: App.Style.Color.heartActiveColor)
        } else {
            self.imageBtnActivateWithColor(color: App.Style.Color.heartInactiveColor)
        }
    }
    
    //favor list post button
    func favorPlaylistPost(playlistPost: PlaylistPost){
        self.isEnabled = false
        guard let currentUser = App.delegate?.currentUser else{
            return
        }
        
        guard let currenrtLikeUser = playlistPost.likeUsers else {
            return
        }
        
        guard let isFavored = playlistPost.isFavored else{
            return
        }
        if isFavored {
            self.imageBtnActivateWithColor(color: App.Style.Color.heartInactiveColor)
            let newUsers = currenrtLikeUser.filter({ (user) -> Bool in
                return user != currentUser
            })
            playlistPost.likeUsers = newUsers
            playlistPost.saveInBackground(block: { (success, error) in
                if !success {
                    print(error ?? "")
                } else {
                    self.isEnabled = true
                }
            })
            
        } else {
            playlistPost.likeUsers?.append(currentUser)
            self.imageBtnActivateWithColor(color: App.Style.Color.heartActiveColor)
            playlistPost.saveInBackground(block: { (success, error) in
                if !success {
                    print(error ?? "")
                } else {
                    self.isEnabled = true
                }
            })
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
