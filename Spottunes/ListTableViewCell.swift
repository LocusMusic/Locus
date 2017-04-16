//
//  ListTableViewCell.swift
//  Spottunes
//
//  Created by Xie kesong on 4/15/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var coverImageView: UIImageView!{
        didSet{
            self.coverImageView.layer.cornerRadius = 6.0
            self.coverImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var listenerLabel: UILabel!
    
    var item: PlayList?{
        didSet{
            if let coverURL = self.item?.coverURL{
                self.coverImageView.image = UIImage(named: coverURL)
            }
            if let name = self.item?.name{
                self.nameLabel.text = name
            }
            if let username = self.item?.username{
                self.authorLabel.text = username

            }
            if let listenrsCount = self.item?.hits{
                self.listenerLabel.text = "· \(listenrsCount) listeners"
            }
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
