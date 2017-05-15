//
//  SelectionFromPlaylistViewController.swift
//  Spottunes
//
//  Created by Xie kesong on 5/2/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

fileprivate let reuseIden = "SongsTableViewCell"
fileprivate let cellNibName = "SongsTableViewCell"

class SelectSongsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.contentInset = App.Style.TableView.contentInset
            self.tableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: reuseIden)
            self.tableView.estimatedRowHeight = 50
            self.tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    @IBAction func backBtnTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!{
        didSet{
            self.loadingActivityIndicator.isHidden = true
            self.loadingActivityIndicator.hidesWhenStopped = true
        }
    }

    
    
    @IBAction func shareBtnTapped(_ sender: UIButton) {
        self.loadingActivityIndicator.isHidden = false
        self.loadingActivityIndicator.startAnimating()
        sender.setTitle("", for: .normal)
        guard let currentUser = App.delegate?.currentUser else{
            return
        }
        guard let spot = self.postInfo[App.PostInfoKey.spot] as? TuneSpot else{
            return
        }
        
        if self.selectAll{
            print("select all")
            guard let playlist = self.postInfo[App.PostInfoKey.playlist] as? Playlist else{
                return
            }
            
            //garsp the first song's cover and uplaod together
            if let coverImage = playlist.getCoverImage(withSize: .large) {
                spot.coverURLString = coverImage.url?.absoluteString
            }
            
            let playlistPost = PlaylistPost(user: currentUser, spot: spot, playlistId: playlist.spotifyId)
            
            
//            playlistPost.share { (succeed, error) in
//                if succeed{
//                    print("succeed")
//                    DispatchQueue.main.async {
//                        App.postLocalNotification(withName: App.LocalNotification.Name.recentlyVisitedShouldUpdate)
//                        self.dismiss(animated: true, completion: nil)
//                    }
//                }else{
//                    print("failed to save")
//                }
//            }
        }else{
            print("select individual songs")
        }
    }
    
    
    @IBOutlet weak var selectAllBtn: UIBarButtonItem!
    
    
    @IBAction func selectAllBtnToggle(_ sender: UIBarButtonItem) {
        self.selectAllBtnToggleHelper()
    }
    
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var selectAll = false
    
    
    var trackList: [Track]?{
        didSet{
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    var selectedIndex = [Int]()
    
    var postInfo: [String: Any]!{
        didSet{
            if let playlist = self.postInfo[App.PostInfoKey.playlist] as? Playlist{
                SpotifyClient.getTracksInPlaylist(playlist: playlist, completionHandler: { (tracks) in
                    if let tracks = tracks{
                        self.trackList = tracks
                    }
                })
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateShareBtnState()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateShareBtnState(){
        if self.selectedIndex.count > 0 || self.selectAll{
            self.shareBtn.isEnabled = true
            self.shareBtn.setTitleColor(App.backColor, for: .normal)
        }else{
            self.shareBtn.isEnabled = false
            self.shareBtn.setTitleColor(App.grayColor, for: .normal)
        }
    }
    
    
    func selectAllBtnToggleHelper(){
        self.selectedIndex.removeAll()
        if self.selectAll{
            self.selectAllBtn.image = #imageLiteral(resourceName: "unselect-check-icon")
        }else{
            self.selectAllBtn.image = #imageLiteral(resourceName: "selected-check-icon")
            //add indices
            if let trackList = self.trackList{
                for index in 0 ..< trackList.count{
                    self.selectedIndex.append(index)
                }
            }
        }
        self.selectAll = !self.selectAll
        self.updateShareBtnState()
        self.tableView.reloadData()
    }
    

}


extension SelectSongsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trackList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! SongsTableViewCell
        cell.track = self.trackList![indexPath.row]
        cell.tintColor = App.grayColor
        if self.selectAll || self.selectedIndex.index(of: indexPath.row) != nil{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            if cell.accessoryType == .checkmark{
                if let index = self.selectedIndex.index(of: indexPath.row){
                    self.selectedIndex.remove(at: index)
                    cell.accessoryType = .none
                    self.selectAll = false
                    self.selectAllBtn.image = #imageLiteral(resourceName: "unselect-check-icon")
                }
            }else{
                if self.selectedIndex.index(of: indexPath.row) == nil{
                    self.selectedIndex.append(indexPath.row)
                    cell.accessoryType = .checkmark
                    if self.selectedIndex.count == self.trackList!.count{
                        self.selectAll = true
                        self.selectAllBtn.image = #imageLiteral(resourceName: "selected-check-icon")
                    }
                }
            }
            
            self.updateShareBtnState()
        }
    }
}
