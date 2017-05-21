//
//  SpotViewController.swift
//  Spottunes
//
//  Created by Xie kesong on 5/20/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

class SpotViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!{
        didSet{
            self.navigationBar.updateNavigationBarAppearance()
        }
    }
    @IBOutlet weak var spotNameLabel: UILabel!
    
    @IBOutlet weak var spotCoverImageView: UIImageView!
    
    
    @IBAction func backBtnTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var spot: TuneSpot!
    
    @IBOutlet weak var topPlaylistPostBtn: UIButton!
    
    @IBOutlet weak var listenerBtn: UIButton!
    
    var spotEmbedVC: SpotEmbedPagingViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if spot != nil{
            self.spotCoverImageView?.image = nil
            if let coverURL = self.spot.coverURL{
                self.spotCoverImageView.loadImageWithURL(coverURL)
            }
            self.spotNameLabel.text = self.spot.name
            PlaylistPost.fetchPlaylistPostInSpot(spot: self.spot) { (playlistPosts) in
                self.spotEmbedVC?.playlistsPost = playlistPosts
            }
            PlaylistPost.fetchListenersListBasedOnFavoredCount(forSpot: self.spot) { (listenerLikeReceivedPairs: [(key: User, value: Int)]?) in
                self.spotEmbedVC?.listenerLikeReceivedPairs = listenerLikeReceivedPairs
            }
        }

    }
    
    @IBOutlet weak var coverWrapperView: UIView!{
        didSet{
            self.coverWrapperView.layer.cornerRadius = 4.0
            self.coverWrapperView.clipsToBounds = true
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let iden = segue.identifier{
            switch iden{
            case App.SegueIden.spotEmbedSegueIden:
                if let spotEmbedVC = segue.destination as? SpotEmbedPagingViewController{
                    spotEmbedVC.customDelegate = self
                    self.spotEmbedVC = spotEmbedVC
                    self.spotEmbedVC?.parentScrollView = self.scrollView
                }
            default:
                break
            }
        }
    }
    
    func setTopPostListBtnActive(){
        self.topPlaylistPostBtn.setTitleColor(App.Style.SliderMenue.activeColor, for: .normal)
        self.listenerBtn.setTitleColor(App.Style.SliderMenue.deactiveColor, for: .normal)
    }


    func setListenerBtnActive(){
        self.listenerBtn.setTitleColor(App.Style.SliderMenue.activeColor, for: .normal)
        self.topPlaylistPostBtn.setTitleColor(App.Style.SliderMenue.deactiveColor, for: .normal)
    }
    
}

extension SpotViewController: SpotEmbedPagingViewControllerDelegate{
    func willTransitionToPage(viewController: UIViewController, pageIndex: Int) {
        if pageIndex == 0{
            self.setTopPostListBtnActive()
        }else if pageIndex == 1{
            self.setListenerBtnActive()
        }
    }
}

