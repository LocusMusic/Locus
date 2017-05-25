//
//  PlayingViewController.swift
//  Locus
//
//  Created by Xie kesong on 4/26/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

fileprivate let reuseIden = "SongTableViewCell"
fileprivate let cellNibName = "SongTableViewCell"

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
      
    @IBOutlet weak var currentTrackThumbnailImageView: UIImageView!
    
    
    @IBOutlet weak var currentTrackCoverThumbnailWrapper: UIView!{
        didSet{
            self.currentTrackCoverThumbnailWrapper.layer.cornerRadius = 4.0
            self.currentTrackCoverThumbnailWrapper.clipsToBounds = true
            self.currentTrackCoverThumbnailWrapper.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(currentTrackThumbnailTapped(_:)) )
            self.currentTrackCoverThumbnailWrapper.addGestureRecognizer(tap)
        }

    }
        
    @IBOutlet weak var currentTrackNameLabel: UILabel!
    @IBOutlet weak var currentTrackArtistNameLabel: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var placeholderView: UIView!
    
    @IBOutlet weak var playBtn: UIButton!{
        didSet{
            self.playBtn.isUserInteractionEnabled = false
        }
    }
    
    var queue: [Track]? = App.delegate?.queue
    
    @IBAction func listenTapped(_ sender: UIButton) {
        if let listenerVC = App.mainStoryBoard.instantiateViewController(withIdentifier: App.StoryboardIden.listenerViewController) as? ListenerViewController{
            self.navigationController?.pushViewController(listenerVC, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(queueShouldUpdate(_:)), name: App.LocalNotification.Name.queueShouldUpdate, object: nil)
        self.updateQueueState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        App.setStatusBarStyle(style: .default)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.setAndLayoutTableHeaderView(header: self.headerView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func currentTrackThumbnailTapped(_ gesture: UITapGestureRecognizer){
        self.playBtn.imageBtnActivateWithColor(color: App.backColor, usingImage: #imageLiteral(resourceName: "playing-icon-small-white"),  withBounceAnimation: true)
        UIView.animate(withDuration: 0.3, animations: {
            self.playBtn.alpha = 0
        }) { (finished) in
            if finished{
                self.playBtn.isHidden = true
                self.currentTrackCoverThumbnailWrapper.isUserInteractionEnabled = false
            }
        }
        if let queue = App.delegate?.queue{
            App.playTracks(trackList: queue, activeTrackIndex: 0)
        }
    }
    
    func updateQueueState(){
        self.queue = App.delegate?.queue
        if let playQueue = self.queue, playQueue.count > 0{
            self.placeholderView.isHidden = true
            self.tableView.isHidden = false
            //queue is not nil
            DispatchQueue.main.async {
                if let currentTrack = playQueue.first{
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
        }else{
            self.placeholderView.isHidden = false
            self.tableView.isHidden = true
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
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! SongTableViewCell
        cell.track = self.queue?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let trackList = self.queue{
            App.playTracks(trackList:trackList, activeTrackIndex: indexPath.row)
        }
    }
}





