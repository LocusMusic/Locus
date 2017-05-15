//
//  PlayingViewController.swift
//  Spottunes
//
//  Created by Xie kesong on 4/26/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

fileprivate let reuseIden = "QueueTableViewCell"
fileprivate let cellNibName = "QueueTableViewCell"

class QueueViewController: UIViewController {

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
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!{
        didSet{
            self.activityIndicatorView.hidesWhenStopped = true
        }
    }
      
    @IBOutlet weak var currentTrackThumbnailImageView: UIImageView!{
        didSet{
            self.currentTrackThumbnailImageView.layer.cornerRadius = 4.0
            self.currentTrackThumbnailImageView.clipsToBounds = true
        }
    }
    
    
    @IBOutlet weak var currentTrackNameLabel: UILabel!
    
    @IBOutlet weak var currentTrackArtistNameLabel: UIButton!
    @IBOutlet weak var headerView: UIView!
    
    
    
    var queue: [Track]?
    
    @IBAction func listenTapped(_ sender: UIButton) {
        if let listenerVC = App.mainStoryBoard.instantiateViewController(withIdentifier: App.StoryboardIden.listenerViewController) as? ListenerViewController{
            self.navigationController?.pushViewController(listenerVC, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view will appear")
        NotificationCenter.default.addObserver(self, selector: #selector(queueShouldUpdate(_:)), name: App.LocalNotification.Name.queueShouldUpdate, object: nil)
        self.updateQueueState()
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
    
    func updateQueueState(){
        self.queue = App.delegate?.queue
        DispatchQueue.main.async {
            if let currentTrack = self.queue?.first{
                if let coverImage = currentTrack.getCoverImage(withSize: .medium){
                    if let url = coverImage.url{
                        self.currentTrackThumbnailImageView.loadImageWithURL(url)
                    }
                }
                if let name = currentTrack.name{
                    self.currentTrackNameLabel.text = name
                }
                if let artistName = currentTrack.artists?.first?.name{
                    self.currentTrackArtistNameLabel.setTitle(artistName, for: .normal)
                }
                self.queue?.remove(at: 0)
            }
            self.tableView?.reloadData()
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    func queueShouldUpdate(_ notification: Notification){
       self.updateQueueState()
    }
    
    
}

extension QueueViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.queue?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! QueueTableViewCell
        cell.track = self.queue?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userInfo: [String: Any] = [
                App.LocalNotification.PlayViewShouldShow.tracksKey: self.queue!,
                App.LocalNotification.PlayViewShouldShow.activeTrackIndex: indexPath.row
        ]
        App.postLocalNotification(withName: App.LocalNotification.PlayViewShouldShow.name, object: self, userInfo: userInfo)
    }
}





