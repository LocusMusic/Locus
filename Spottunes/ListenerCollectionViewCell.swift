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
            self.profileImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var listener: User?{
        didSet{
            if let name = self.listener?.displayName{
                self.nameLabel.text = name
            }
//            if let image = self.listener?.images?.first{
//                if let url = image.url{
//                    self.profileImageView.loadImageWithURL(url)
//                }
//            }
        }
    }
    
    
    func updateImageLayerCorner(width: CGFloat){
        print("update ui")
        self.profileImageView.layer.cornerRadius = width / 2
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
