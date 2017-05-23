
//
//  NotificationTableViewCell.swift
//  Locus
//
//  Created by Xie kesong on 5/23/17.
//  Copyright © 2017 ___Locus___. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    var notification: PushNotification!{
        didSet{
            //update UI
            guard let sender = self.notification.sender else{
                return
            }
            sender.loadUserProfileImage { (image, error) in
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
            }
            self.detailDescriptionLabel.text = self.notification.detailDescription
            guard let displayName = sender.displayName else{
                return
            }
            self.detailDescriptionLabel.styleUsernaneText(username: displayName)
        }
    }
    @IBOutlet weak var profileImageView: UIImageView!{
        didSet{
            self.profileImageView.layer.cornerRadius = 24.0
            self.profileImageView.layer.borderColor = App.grayColor.cgColor.copy(alpha: 0.2)
            self.profileImageView.layer.borderWidth = 1.0
            self.profileImageView.clipsToBounds = true
        }
    }
    
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
