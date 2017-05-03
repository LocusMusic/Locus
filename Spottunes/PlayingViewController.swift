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
    
    var currentPlayingQueue: [Song]?{
        didSet{
            self.tableView?.reloadData()
        }
    }
    
    
    @IBAction func listenTapped(_ sender: UIButton) {
        if let listenerVC = App.mainStoryBoard.instantiateViewController(withIdentifier: App.StoryboardIden.listenerViewController) as? ListenerViewController{
            self.navigationController?.pushViewController(listenerVC, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //current playing queue
        //playerList 1
//        let playList_1 = Playlist(coverURL: "images-1", name: "EI Ten Eleven", username: "kesongxie")
//        let song_1 = Song(name: "My only swerving", author: "EI Ten Eleven", Playlist: playList_1, hits: 142)
//        playList_1.songs = [song_1]
//        
//        
//        //playerList 2
//        let playList_2 = Playlist(coverURL: "images-2", name: "Superior Focus Tunes", username: "leow")
//        let song_4 = Song(name: "Logic of a dream", author: "Explosion in the Sky", Playlist: playList_2, hits: 100)
//        playList_2.songs = [song_4]
//        
//        
//        //playerList 3
//        let playList_3 = Playlist(coverURL: "images-3", name: "Radio Music Station", username: "edison")
//        
//        let song_7 = Song(name: "Breath and start", author: "Heinali", Playlist: playList_3, hits: 44)
//        playList_3.songs = [song_7]
//        
//        //playerList 4
//        let playList_4 = Playlist(coverURL: "images-4", name: "Nothing Was The Same", username: "edison")
//        let song_9 = Song(name: "Ninth wake", author: "Trifonic", Playlist: playList_4, hits: 36)
//        playList_4.songs = [song_9]
//        
//        //playerList 5
//        let playList_5 = Playlist(coverURL: "images-5", name: "Answer With An Album Cover", username: "leow")
//        let song_11 = Song(name: "Colors in stearo", author: "Com Truise", Playlist: playList_5, hits: 39)
//        playList_5.songs = [song_11]
        
        self.currentPlayingQueue = []
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
        return  self.currentPlayingQueue?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! PlayingTableViewCell
        cell.song = self.currentPlayingQueue?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        App.postLocalNotification(withName: App.LocalNotification.Name.playViewShouldShow)
    }
}





