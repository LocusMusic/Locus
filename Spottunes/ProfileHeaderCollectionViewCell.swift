//
//  ProfileHeaderCollectionViewCell.swift
//  Spottunes
//
//  Created by Xie kesong on 4/29/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

class ProfileHeaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var profileImageView: UIImageView!{
        didSet{
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
            self.profileImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var dummy1ImageView: UIImageView!{
        didSet{
            self.dummy1ImageView.layer.cornerRadius = 4.0
            self.dummy1ImageView.clipsToBounds = true

        }
    }
    @IBOutlet weak var mapIconImageView: UIImageView!{
        didSet{
            self.mapIconImageView.setColorOfImage(color: App.backColor)
        }
    }
  
    @IBOutlet weak var listenedAtLabel: UILabel!{
        didSet{
            self.listenedAtLabel.layer.cornerRadius = 6.0
            self.listenedAtLabel.clipsToBounds = true
        }
    }
    @IBOutlet weak var playBtn: UIButton!{
        didSet{
            self.playBtn.layer.cornerRadius = 6.0
            self.playBtn.clipsToBounds = true
        }
    }
    
    @IBAction func playBtnTapped(_ sender: UIButton) {
        sender.animateBounceView()
        //pass additional songs as the key value for dispalying music
        App.postLocalNotification(withName: App.LocalNotification.PlayViewShouldShow.name)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
