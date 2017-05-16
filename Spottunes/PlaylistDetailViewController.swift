//
//  PlaylistDetailViewController.swift
//  Spottunes
//
//  Created by Xie kesong on 4/26/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

fileprivate let reuseIden = "SongTableViewCell"
fileprivate let cellNibName = "SongTableViewCell"

class PlaylistDetailViewController: UIViewController {
    
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
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!{
        didSet{
            self.activityIndicatorView.hidesWhenStopped = true
        }
    }
    @IBOutlet weak var playlistCoverThumbnailImageView: UIImageView!
    @IBOutlet weak var playlistCoverWrapper: UIView!{
        didSet{
            self.playlistCoverWrapper.layer.cornerRadius = 4.0
            self.playlistCoverWrapper.clipsToBounds = true
            self.playlistCoverWrapper.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(playlistThumbnailCoverTapped(_:)) )
            self.playlistCoverWrapper.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak var navigationBar: UINavigationBar!{
        didSet{
            self.navigationBar.updateNavigationBarAppearance()
        }
    }
    @IBAction func backBtnTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var playlistNameLabel: UILabel!
    @IBOutlet weak var ownerLabel: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var playBtn: UIButton!{
        didSet{
            self.playBtn.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var songsCountLabel: UILabel!
    var playlistPost: PlaylistPost!
    
    var trackList: [Track]?{
        return self.playlistPost.playlist?.tracks?.trackList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.setAndLayoutTableHeaderView(header: self.headerView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func playlistThumbnailCoverTapped(_ gesture: UIGestureRecognizer){
        //play the playlist
        if let trakList = self.trackList{
            App.playTracks(trackList: trakList, activeTrackIndex: 0)
        }
    }
    
    func updateUI(){
        if let playlistPost = self.playlistPost{
            //update playlist cover
            if let playlist = playlistPost.playlist{
                if let coverImage = playlist.getCoverImage(withSize: .medium){
                    if let url = coverImage.url{
                        self.playlistCoverThumbnailImageView.loadImageWithURL(url)
                    }
                }
                //update playlist name
                if let name = playlist.name{
                    self.playlistNameLabel.text = name
                }
                
                //update playlist author name
                if let name = playlistPost.user?.displayName{
                    self.ownerLabel.setTitle(name, for: .normal)
                }
                
                //update songs count
                self.songsCountLabel.text = playlist.trackCountString
            }
            //reload data
            self.tableView.reloadData()

        }
    }
    
  
}

extension PlaylistDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.trackList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! SongTableViewCell
        cell.track = self.trackList?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let trackList = self.trackList{
            App.playTracks(trackList:trackList, activeTrackIndex: indexPath.row)
        }
    }
}





