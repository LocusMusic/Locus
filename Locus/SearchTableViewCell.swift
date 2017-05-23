//
//  SearchTableViewCell.swift
//  Locus
//
//  Created by Leo Wong on 5/4/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!{
        didSet {
            self.thumbnailImageView.layer.cornerRadius = 4.0
            self.thumbnailImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var data: TuneSpot? {
        didSet {
            if let name = self.data?.name{
                self.titleLabel.text = name
            }
            
            if let address = self.data?.address{
                self.subtitleLabel.text = address
            }

            self.thumbnailImageView?.image = #imageLiteral(resourceName: "location-icon")
            if let coverURL = self.data?.coverURL{
                self.thumbnailImageView.loadImageWithURL(coverURL)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
