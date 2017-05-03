//
//  ListenerTableViewCell.swift
//  Spottunes
//
//  Created by Xie kesong on 4/29/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

class ListenerTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!{
        didSet{
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
            self.profileImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var usernameLebel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
