//
//  StreammingSpotViewController.swift
//  Spottunes
//
//  Created by Xie kesong on 5/12/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

fileprivate let listenerReuseIden = "ListenerCollectionViewCell"
fileprivate let listenerNibName = "ListenerCollectionViewCell"

fileprivate let reuseIden = "SpotPlaylistTableViewCell"
fileprivate let cellNibName = "SpotPlaylistTableViewCell"


fileprivate struct CollectionViewUI{
    static let UIEdgeSpace: CGFloat = 20.0
    static let MinmumLineSpace: CGFloat = 16.0
    static let MinmumInteritemSpace: CGFloat = 16.0
}

class ConnectedSpotViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.alwaysBounceHorizontal = true
            self.collectionView.register(UINib(nibName: listenerNibName, bundle: nil), forCellWithReuseIdentifier: listenerReuseIden)
        }
    }
    @IBOutlet weak var focusTabBtn: UIButton!{
        didSet{
            self.focusTabBtn.layer.cornerRadius = self.focusTabBtn.frame.size.height / 2
            self.focusTabBtn.clipsToBounds = true
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
    
    @IBOutlet weak var spotThumbImageView: UIImageView!
    
    @IBOutlet weak var spotThumbnailWrapper: UIView!{
        didSet{
            self.spotThumbImageView.layer.cornerRadius = 4.0
            self.spotThumbImageView.clipsToBounds = true
        }

    }
    
    var cellWidth: CGFloat = 0
    
    @IBOutlet weak var headerView: UIView!
    
    var spot: TuneSpot!{
        didSet{
            PlaylistPost.fetchPlaylistPostInSpot(spot: self.spot) { (playlistPosts) in
                self.playlistPosts = playlistPosts
            }
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
//    var listeners: [User]?{
//        didSet{
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
//        }
//    }

    var playlistPosts: [PlaylistPost]?{
        didSet{
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if spot != nil{
            self.spotThumbImageView?.image = nil
            if let coverURL = self.spot.coverURL{
                self.spotThumbImageView.loadImageWithURL(coverURL)
            }
            self.nameLabel.text = self.spot.name
        }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.setAndLayoutTableHeaderView(header: self.headerView)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ConnectedSpotViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.playlistPosts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! SpotPlaylistTableViewCell
        cell.playlistPost = self.playlistPosts?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tracks = self.playlistPosts![indexPath.row].playlist!.tracks!.trackList!
        App.playTracks(trackList: tracks, activeTrackIndex: 0)
    }
}










extension ConnectedSpotViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  0 //self.listeners?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listenerReuseIden, for: indexPath) as! ListenerCollectionViewCell
//        cell.listener = self.listeners![indexPath.row]
        cell.updateImageLayerCorner(width: self.cellWidth)
        return cell
    }
}

extension ConnectedSpotViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.size.height - 30
        self.cellWidth = width
        return CGSize(width: width, height: self.collectionView.frame.size.height)
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




