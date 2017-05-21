//
//  ListenerViewController.swift
//  Spottunes
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
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0)
            self.tableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: reuseIden)
        }
    }
    
    var spot: TuneSpot!
    
    var listenerLikeReceivedPairs: [(key: User, value: Int)]?

    var parentScrollView: UIScrollView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.listenerLikeReceivedPairs != nil{
            self.tableView?.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.parentScrollView?.contentOffset.y = scrollView.contentOffset.y
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
            //play user's music and send out a remote notification
            guard let playlistPost = cell.listenerLikePair?.key.currentListeningPlaylistPost else{
                return
            }
            
            guard let activeTrackIndex = cell.listenerLikePair?.key.currentActiveTrackIndex else{
                return
            }

            playlistPost.refetchPost(completionHandler: { (fetchedPlaylistPost) in
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
                                App.playTracks(trackList: trackList, activeTrackIndex: activeTrackIndex)
                            
                                //send out a remote notification for someone that is playing yoru song
                                
                                guard let senderUserName = User.current()?.displayName else{
                                    print("senderUserName is empty")
                                    return
                                }
                                
                                guard let receiverUsername = User.current()?.username else{
                                    print("receiverUsername is empty")
                                    return
                                }
                                
                                guard let playlistName = fetchedPlaylistPost.playlist?.name else{
                                    print("playlist name is empty")
                                    return
                                }

                                guard let playlistPostId = fetchedPlaylistPost.objectId else{
                                    print("playlistPostId is empty")
                                    return
                                }
                                
                                guard let spotName = fetchedPlaylistPost.spot?.name else{
                                    print("spot name is empty")
                                    return
                                }
                                
                                
                                let param = [
                                    "senderUsername": senderUserName,
                                    "receiverUsername": receiverUsername,
                                    "playlistPostId": playlistPostId,
                                    "spotName": spotName
                                ]
                                PFCloud.callFunction(inBackground: "sendNotificaionAfterSongPlayedByOthers", withParameters: param, block: { (response, error) in
                                    print(response)
                                })
                                                        
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


