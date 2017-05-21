//
//  SelecSpotTableViewCell
//  Locus
//
//  Created by Xie kesong on 5/9/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit


class SelectSpotTableViewCell: UITableViewCell {
    
    @IBOutlet weak var locationImageView: UIImageView!{
        didSet{
            self.locationImageView.layer.cornerRadius = 4.0
            self.locationImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var spotNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var spot: TuneSpot?{
        didSet{
            if let name = self.spot?.name{
                self.spotNameLabel.text = name
            }
            if let address = self.spot?.address{
                self.addressLabel.text = address
            }
            self.locationImageView?.image = #imageLiteral(resourceName: "location-icon")
            if let coverURL = self.spot?.coverURL{
                self.locationImageView.loadImageWithURL(coverURL)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
