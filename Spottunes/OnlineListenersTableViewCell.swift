//
//  OnlineListenersTableViewCell.swift
//  Spottunes
//
//  Created by Xie kesong on 5/7/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit


class OnlineListenersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!{
        didSet{
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
            self.profileImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var usernameLebel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    var user: User?{
        didSet{
            
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
