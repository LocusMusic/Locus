//
//  TopPlaylistViewController.swift
//  Locus
//
//  Created by Xie kesong on 5/20/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

class TopPlaylistViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.allowsSelection = false
            self.tableView.refreshControl = self.refreshControl
            self.tableView.estimatedRowHeight = 60
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0)
            self.tableView.register(UINib(nibName: SpotPlaylistTableViewCellNibName, bundle: nil), forCellReuseIdentifier: SpotPlaylistTableViewCellReuseIden)
        }
    }
    
    var playlistPosts: [PlaylistPost]?{
        didSet{
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.tableView?.reloadData()
            }
        }
    }
    
    var spot: TuneSpot!
    
    var parentScrollView: UIScrollView?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl =  UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshDragged(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(finishedSharingPlaylists(_:)), name: App.LocalNotification.finishSharingPlaylist.name, object: nil)
        self.refreshData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
    }
    
    func refreshDragged(_ refreshControl: UIRefreshControl){
        self.refreshData()
    }
    
    func finishedSharingPlaylists(_ notification: Notification){
        if let tuneSpot = notification.userInfo?[App.LocalNotification.finishSharingPlaylist.spotKey] as? TuneSpot{
            guard let currentSpotId = self.spot.objectId else{
                return
            }
            guard let spotForPosting = tuneSpot.objectId else{
                return
            }
            
            if currentSpotId == spotForPosting{
                self.refreshData()
            }
        }
    }
    
    private func refreshData(){
        guard let tuneSpot = self.spot else{
            return
        }
        PlaylistPost.fetchPlaylistPostInSpot(spot: tuneSpot) { (playlistPosts) in
            self.playlistPosts = playlistPosts
        }
    }

    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func cellTapped(_ gesture: UITapGestureRecognizer){
        if let cell = gesture.view as? SpotPlaylistTableViewCell{
            if let playlistDetailVC = App.mainStoryBoard.instantiateViewController(withIdentifier: App.StoryboardIden.playlistDetailViewController) as? PlaylistDetailViewController{
                playlistDetailVC.playlistPost = cell.playlistPost
                self.navigationController?.pushViewController(playlistDetailVC, animated: true)
            }
        }
    }
}

extension TopPlaylistViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playlistPosts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SpotPlaylistTableViewCellReuseIden, for: indexPath) as! SpotPlaylistTableViewCell
        cell.playlistPost = self.playlistPosts?[indexPath.row]
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
        cell.addGestureRecognizer(tapGesture)
        return cell
    }
    
}


