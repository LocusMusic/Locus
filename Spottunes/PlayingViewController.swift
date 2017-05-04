//
//  PlayingViewController.swift
//  Spottunes
//
//  Created by Xie kesong on 4/26/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

fileprivate let reuseIden = "PlayingTableViewCell"
fileprivate let cellNibName = "PlayingTableViewCell"

class PlayingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.alwaysBounceVertical = true
            self.tableView.estimatedRowHeight = self.tableView.rowHeight
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0)
            self.tableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: reuseIden)
        }
    }
    
    @IBOutlet weak var shuffleBtn: UIButton!{
        didSet{
//            let color = UIColor(hexString: "#0F53B6")
//            self.shuffleBtn.imageBtnActivateWithColor(color: color)
        }
    }
      
    @IBOutlet weak var thumbnailImageView: UIImageView!{
        didSet{
            self.thumbnailImageView.layer.cornerRadius = 4.0
            self.thumbnailImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var headerView: UIView!
    
    var trackList: [Track]?{
        didSet{
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    
    
    @IBAction func listenTapped(_ sender: UIButton) {
        if let listenerVC = App.mainStoryBoard.instantiateViewController(withIdentifier: App.StoryboardIden.listenerViewController) as? ListenerViewController{
            self.navigationController?.pushViewController(listenerVC, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SpotifyClient.fetchCurrentUserPlayList { (playlists) in
            if let playlists =  playlists{
                if let playlist = playlists.first{
                    if let href = playlist.tracks?.href{
                        SpotifyClient.getTracksInPlaylist(tracksHref: href, completionHandler: { (trackList) in
                            if let trackList = trackList{
                                self.trackList = trackList
                            }else{
                                print("track list is nil")
                            }
                        })
                    }
                }
            }
        }
            
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.setAndLayoutTableHeaderView(header: self.headerView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PlayingViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.trackList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! PlayingTableViewCell
        cell.track = self.trackList?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userInfo: [String: Any] = [
                App.LocalNotification.PlayViewShouldShow.tracksKey: self.trackList!,
                App.LocalNotification.PlayViewShouldShow.activeTrackIndex: indexPath.row
        ]
        App.postLocalNotification(withName: App.LocalNotification.PlayViewShouldShow.name, object: self, userInfo: userInfo)
    }
}





