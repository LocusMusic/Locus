//
//  ListenerViewController.swift
//  Locus
//
//  Created by Xie kesong on 5/20/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit
import Parse

fileprivate let reuseIden = "ListenerTableViewCell"
fileprivate let cellNibName = "ListenerTableViewCell"

class ListenerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.allowsSelection = false
            self.tableView.alwaysBounceVertical = false
            self.tableView.estimatedRowHeight = 60
            self.tableView.refreshControl = self.refreshControl
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0)
            self.tableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: reuseIden)
        }
    }
    
    var spot: TuneSpot!
    
    var listenerLikeReceivedPairs: [(key: User, value: Int)]?{
        didSet{
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.tableView?.reloadData()
            }
        }
    }

    var parentScrollView: UIScrollView?
    
    
    
    var myQuery: PFQuery<User> {
        return (User.query()?
            .whereKey("username", equalTo: "yMnPS8VHdiufkQjckzUzPOtK7"))! as! PFQuery<User>
    }

    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl =  UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshDragged(_:)), for: .valueChanged)
        return refreshControl
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshData()

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.parentScrollView?.contentOffset.y = scrollView.contentOffset.y
    }
    
    func refreshData(){
        PlaylistPost.fetchListenersListBasedOnFavoredCount(forSpot: self.spot) { (listenerLikeReceivedPairs: [(key: User, value: Int)]?) in
            self.listenerLikeReceivedPairs = listenerLikeReceivedPairs
        }
    }
    
    func refreshDragged(_ refreshControl: UIRefreshControl){
        self.refreshData()
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
        if let cell = gesture.view as? ListenerTableViewCell{
            //make sure the user in this cell is actually listening to some music
            guard cell.isListening() else{
                print("not listening")
                return
            }
            
            //make sure the listener is not nil
            guard let listener = cell.listenerLikePair?.key else{
                return
            }
            
            //get the playlist post from the listener
            guard let playlistPost = listener.currentListeningPlaylistPost else{
                print("playlist post is nil")
                return
            }
            
            print(listener)
            
            //get the current track index
            guard let activeTrackIndex = listener.currentActiveTrackIndex else{
                print("active track index is nil")
                return
            }
            
            //make sure the track index is none-negative
            guard activeTrackIndex >= 0 else{
                print("the listener is currently not playing music")
                return
            }
            
            
            
            //fetch the entire playlist post object incase the platlistPost has no data about
            //its columns yet
            //play the playlist from the listener
            playlistPost.refetchPost(completionHandler: { (fetchedPlaylistPost) in
                //using the newly fecthedPlaylistPost and ensure all columns have data
                if let fetchedPlaylistPost = fetchedPlaylistPost{
                    guard let userId = fetchedPlaylistPost.user?.spotifyId else{
                        return
                    }
                    guard let playlistId = fetchedPlaylistPost.playlistId else{
                        return
                    }
                    SpotifyClient.fetchPlaylistByUserIdAndPlaylistId(userId: userId, playlistId: playlistId) { (playlist) in
                        DispatchQueue.main.async {
                            if let playlist = playlist{
                                fetchedPlaylistPost.playlist = playlist
                                
                                guard let trackList = fetchedPlaylistPost.trackList else{
                                    return
                                }
                                
                                //play the current track that the listener is listening to
                                App.playTracks(trackList: trackList, activeTrackIndex: activeTrackIndex)
                                PushNotification.sendRemoteNotificationAfterSyncing(playlistPost: fetchedPlaylistPost)
                                User.current()?.subscribeTo(listener)
                            }
                        }
                    }
                }
            })
        }
    }
}

extension ListenerViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listenerLikeReceivedPairs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! ListenerTableViewCell
        cell.listenerLikePair = self.listenerLikeReceivedPairs?[indexPath.row]
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
        cell.addGestureRecognizer(tapGesture)
        cell.spot = spot
        return cell
    }
}


