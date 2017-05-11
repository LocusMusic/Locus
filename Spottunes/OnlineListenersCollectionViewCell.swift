//
//  OnlineListenersCollectionViewCell.swift
//  Spottunes
//
//  Created by Xie kesong on 5/7/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

//fileprivate let onlineListenersReuseIden = "OnlineListenersReuseIden"
//fileprivate let onlineListenersNibName = "OnlineListenersTableViewCell"

class OnlineListenersCollectionViewCell: UICollectionViewCell {

//    @IBOutlet weak var tableView: UITableView!{
//        didSet{
//            self.tableView.delegate = self
//            self.tableView.dataSource = self
//            self.tableView.estimatedRowHeight = 60
//            self.tableView.rowHeight = UITableViewAutomaticDimension
//            let nib = UINib(nibName: onlineListenersNibName, bundle: nil)
//            self.tableView.register(nib, forCellReuseIdentifier: onlineListenersReuseIden)
//        }
//    }
    
    @IBOutlet weak var profileImageView: UIImageView!{
        didSet{
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
            self.profileImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var usernameLebel: UILabel!
    
    @IBOutlet weak var currentSongLabel: UILabel!
    
    var user: User?{
        didSet{
            
        }
    }

    
    
    
    
//    var users: [User]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}


//extension OnlineListenersCollectionViewCell : UITableViewDelegate, UITableViewDataSource{
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: onlineListenersReuseIden, for: indexPath) as! OnlineListenersTableViewCell
//        cell.user = self.users?[indexPath.row]
//        return cell
//    }
//    
//}
