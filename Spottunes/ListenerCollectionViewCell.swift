//
//  ListenerCollectionViewCell.swift
//  Spottunes
//
//  Created by Xie kesong on 5/8/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

class ListenerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImageView: UIImageView!{
        didSet{
            self.profileImageView.layer.borderColor = App.grayColor.cgColor.copy(alpha: 0.2)
            self.profileImageView.layer.borderWidth = 1.0
            self.profileImageView.layer.cornerRadius = 24
            self.profileImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var songNameLabel: UILabel!

    @IBOutlet weak var authorNameLabel: UILabel!
    
    var listener: User?{
        didSet{
            if let url = listener?.avatorURL{
                self.profileImageView.image = UIImage(named: url)
            }
            if let name = listener?.name{
                self.nameLabel.text = name
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
