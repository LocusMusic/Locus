//
//  SpotViewController.swift
//  Spottunes
//
//  Created by Xie kesong on 5/7/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

fileprivate let reuseIden = "PlayingTableViewCell"
fileprivate let cellNibName = "PlayingTableViewCell"


fileprivate let smartGenreReuseIden = "SmartGenreReuseIden"
fileprivate let smartGenreNibName = "SmartGenreCollectionViewCell"


fileprivate let listenerReuseIden = "ListenerCollectionViewCell"
fileprivate let listenerNibName = "ListenerCollectionViewCell"

fileprivate struct CollectionViewUI{
    static let UIEdgeSpace: CGFloat = 14.0
    static let MinmumLineSpace: CGFloat = 16.0
    static let MinmumInteritemSpace: CGFloat = 16.0
}


class SpotViewController: UIViewController {
    
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var headerViewTopConstraint: NSLayoutConstraint!
    
    var headerOriginHeight: CGFloat = App.screenWidth

    
    @IBOutlet weak var navigationBar: UINavigationBar!{
        didSet{
            self.navigationBar.updateNavigationBarAppearance()
            self.navigationBar.alpha = 0
        }
    }
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.alwaysBounceVertical = true
            self.tableView.estimatedRowHeight = 60
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0)
            self.tableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: reuseIden)
        }
        
    }
    
    
    
//    @IBOutlet weak var shuffleBtn: UIButton!{
//        didSet{
//            //            let color = UIColor(hexString: "#0F53B6")
//            //            self.shuffleBtn.imageBtnActivateWithColor(color: color)
//        }
//    }
//    
    
    @IBOutlet weak var headerView: UIView!
    
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.alwaysBounceHorizontal = true
            //register for smart genre cell and reuse
            self.collectionView.register(UINib(nibName: listenerNibName, bundle: nil), forCellWithReuseIdentifier: listenerReuseIden)
        }
    }
    

    
    
    var trackList: [Track]?{
        didSet{
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    
    var listeners: [User]?

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
//        let user_1 = User(name: "Kesong Xie", avatorURL: "profile")
//        let user_2 = User(name: "Edison Huang", avatorURL: "sunset")
//        self.listeners = [user_1, user_2]
        

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
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.headerViewHeightConstraint.constant = self.headerOriginHeight
        self.headerOriginHeight =  self.headerViewHeightConstraint.constant
        self.updateNavigationBarVisible(self.tableView)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.setAndLayoutTableHeaderView(header: self.headerView)
    }


    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateNavigationBarVisible(scrollView)
    }

    
    func updateNavigationBarVisible(_ scrollView: UIScrollView){
        let scrollOffSetY = scrollView.contentOffset.y
        if scrollOffSetY < 0{
            self.headerViewTopConstraint.constant = scrollOffSetY
            self.headerViewHeightConstraint.constant =  self.headerOriginHeight - scrollOffSetY
        }else{
            let diff = scrollOffSetY - (self.headerOriginHeight - self.navigationBar.frame.size.height)
            if diff > 0{
                self.navigationBar.alpha = min(1, diff / self.navigationBar.frame.size.height)
                App.setStatusBarStyle(style: .default)
            }else{
                self.navigationBar.alpha = 0
                App.setStatusBarStyle(style: .lightContent)
            }
        }
    }

}

extension SpotViewController: UITableViewDelegate, UITableViewDataSource{
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



extension SpotViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listeners?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listenerReuseIden, for: indexPath) as! ListenerCollectionViewCell
        cell.listener = self.listeners![indexPath.row]
        return cell
    }
}

extension SpotViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: App.screenWidth - 48 - CollectionViewUI.UIEdgeSpace  , height: self.collectionView.frame.size.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CollectionViewUI.MinmumLineSpace
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return  UIEdgeInsetsMake( 0, CollectionViewUI.UIEdgeSpace,  0,  CollectionViewUI.UIEdgeSpace)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CollectionViewUI.MinmumInteritemSpace
    }
}




