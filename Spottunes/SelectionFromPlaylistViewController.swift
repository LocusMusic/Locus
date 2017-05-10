//
//  SelectionFromPlaylistViewController.swift
//  Spottunes
//
//  Created by Xie kesong on 5/2/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

fileprivate let reuseIden = "PlaylistTableViewCell"
fileprivate let cellNibName = "PlaylistTableViewCell"

class SelectionFromPlaylistViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: reuseIden)
            self.tableView.estimatedRowHeight = 50
            self.tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var spotThumbnailWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var thumbnailImageView: UIImageView!{
        didSet{
            self.thumbnailImageView.layer.cornerRadius = 4.0
            self.thumbnailImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var spotNameLabel: UILabel!
    
    var playlists: [Playlist]?{
        didSet{
            DispatchQueue.main.async {
                self.tableView?.reloadData()
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    var selectedIndex = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(shouldUpdatePlaylistPicker(_:)), name: App.LocalNotification.UpdatePlaylistPickerAfterSpotSelected.name, object: nil)
        self.updateShareBtnState()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.spotThumbnailWidthConstraint.constant = App.Style.PlaylistSelection.spotThumbnailWidth
        self.tableView.setAndLayoutTableHeaderView(header: self.headerView)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBAction func shareBtnTapped(_ sender: UIButton) {
        
    }
    
    func updateShareBtnState(){
        if self.selectedIndex.count > 0{
            self.shareBtn.isEnabled = true
            self.shareBtn.setTitleColor(App.backColor, for: .normal)
        }else{
            self.shareBtn.isEnabled = false
            self.shareBtn.setTitleColor(App.grayColor, for: .normal)
        }
    }
    
    func shouldUpdatePlaylistPicker(_ notification: Notification){
        if let spot = notification.userInfo?[App.LocalNotification.UpdatePlaylistPickerAfterSpotSelected.spotKey] as? TuneSpot{
            self.selectedIndex.removeAll()
//            if let urlString = spot.thumbnailURL{
//                self.thumbnailImageView.image = UIImage(named: urlString)
//            }
            self.spotNameLabel.text = spot.name
            SpotifyClient.fetchCurrentUserPlayList { (playlists) in
                if let playlists = playlists{
                    self.playlists = playlists
                }
            }
            self.tableView.reloadData()
            self.updateShareBtnState()
        }
    }
    
    
    
}


extension SelectionFromPlaylistViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playlists?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! PlaylistTableViewCell
        cell.playlist = self.playlists![indexPath.row]
        if self.selectedIndex.index(of: indexPath.row) != nil{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            cell.tintColor = App.grayColor
            if cell.accessoryType == .checkmark{
                if let index = self.selectedIndex.index(of: indexPath.row){
                    self.selectedIndex.remove(at: index)
                    cell.accessoryType = .none
                }
            }else{
                if self.selectedIndex.index(of: indexPath.row) == nil{
                    self.selectedIndex.append(indexPath.row)
                    cell.accessoryType = .checkmark
                }
            }
            self.updateShareBtnState()
        }
    }
}
