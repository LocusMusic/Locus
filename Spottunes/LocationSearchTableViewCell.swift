//
//  LocationSearchTableViewCell.swift
//  Spottunes
//
//  Created by Huang Edison on 5/3/17.
//  Copyright © 2017 Edison. All rights reserved.
//

import UIKit

class LocationSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    var location: Location! {
        didSet{
            locationNameLabel.text = location.name!
            addressLabel.text = location.address
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
