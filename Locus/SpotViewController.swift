//
//  SpotViewController.swift
//  Locus
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
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            self.scrollView.alwaysBounceVertical = false
            self.scrollView.isScrollEnabled = false
            self.scrollView.showsVerticalScrollIndicator = false
        }
    }
    
    var spot: TuneSpot!
    
    @IBAction func topPlaylistBtnTapped(_ sender: UIButton) {
        self.setTopPostListBtnActive()
        sender.animateBounceView()
        App.postLocalNotification(withName: App.LocalNotification.Name.topPlaylistListShouldBecomeActive)
    }
    
    
    @IBAction func listenerBtnTapped(_ sender: UIButton) {
        self.setListenerBtnActive()
        sender.animateBounceView()
        App.postLocalNotification(withName: App.LocalNotification.Name.listenerListShouldBecomeActive)

    }
    
    @IBOutlet weak var topPlaylistPostBtn: UIButton!
    
    @IBOutlet weak var listenerBtn: UIButton!
    
    var spotEmbedVC: SpotEmbedPagingViewController?
    
    //add music to spot button tapped
    @IBAction func addMusicBtnTapped(_ sender: UIBarButtonItem) {
        if let selectionPlaylistVC = App.mainStoryBoard.instantiateViewController(withIdentifier: App.StoryboardIden.selectionFromPlaylistViewController) as? SelectionFromPlaylistViewController{
            if let spot = self.spot{
                let postInfo = [App.PostInfoKey.spot: spot]
                let navigationVC = UINavigationController()
                navigationVC.view.backgroundColor = UIColor.white
                navigationVC.viewControllers = [selectionPlaylistVC]
                navigationVC.navigationBar.updateNavigationBarAppearance()
                let cancelBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "close-icon"), style: .plain, target: self, action: #selector(cancelBtnTapped(_:)))
                cancelBtn.tintColor = App.backColor
                selectionPlaylistVC.navigationItem.leftBarButtonItem = cancelBtn
                selectionPlaylistVC.postInfo = postInfo
                self.present(navigationVC, animated: true, completion: nil)
            }
        }
    }
    
    func cancelBtnTapped(_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        App.setStatusBarStyle(style: .default)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if spot != nil{
            self.spotCoverImageView?.image = nil
            if let coverURL = self.spot.coverURL{
                self.spotCoverImageView.loadImageWithURL(coverURL)
            }
            self.spotNameLabel.text = self.spot.name
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
                    self.spotEmbedVC?.spot = spot
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


