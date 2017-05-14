//
//  SearchViewController.swift
//  Spottunes
//
//  Created by Leo Wong on 5/3/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

//fileprivate let collectionViewReuseIden = "HomePagingCell"

enum SearchPageType {
    case songs
    case artists
    case playlists
    case spots
}

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            self.searchBar.delegate = self
            self.searchBar.tintColor = UIColor(hexString: "#323335")
            for subView in self.searchBar.subviews  {
                for subsubView in subView.subviews  {
                    if let textField = subsubView as? UITextField{
                        self.searchBarTextField = textField
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var homeHeaderView: UIView!
    
    @IBOutlet weak var songsButton: UIButton!
    
    @IBOutlet weak var artistsButton: UIButton!
    
    @IBOutlet weak var playlistsButton: UIButton!
    
    @IBOutlet weak var spotsButton: UIButton!
    
    //tab model
    var pages: [SearchPageType] = [.songs, .artists, .playlists, .spots]
    
    var searchEmbedPageVC: SearchEmbedViewController?
    
    var searchBarTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VIEW DID LOAD")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.adjustSearchBarAppearance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func adjustSearchBarAppearance(){
        self.searchBarTextField.tintColor = App.grayColor
        self.searchBarTextField.layer.cornerRadius = self.searchBarTextField.frame.size.height / 2
        self.searchBarTextField.clipsToBounds = true
        let font = UIFont(name: "Avenir-Book", size:15.0)
        self.searchBarTextField.font = font
    }
    
    func setSongsBtnActive(){
        self.songsButton.setTitleColor(App.Style.SliderMenue.activeColor, for: .normal)
        self.artistsButton.setTitleColor(App.Style.SliderMenue.deactiveColor, for: .normal)
        self.playlistsButton.setTitleColor(App.Style.SliderMenue.deactiveColor, for: .normal)
        self.spotsButton.setTitleColor(App.Style.SliderMenue.deactiveColor, for: .normal)
    }
    
    func setArtistsBtnActive(){
        self.songsButton.setTitleColor(App.Style.SliderMenue.deactiveColor, for: .normal)
        self.artistsButton.setTitleColor(App.Style.SliderMenue.activeColor, for: .normal)
        self.playlistsButton.setTitleColor(App.Style.SliderMenue.deactiveColor, for: .normal)
        self.spotsButton.setTitleColor(App.Style.SliderMenue.deactiveColor, for: .normal)
    }
    
    func setPlaylistsBtnActive(){
        self.songsButton.setTitleColor(App.Style.SliderMenue.deactiveColor, for: .normal)
        self.artistsButton.setTitleColor(App.Style.SliderMenue.deactiveColor, for: .normal)
        self.playlistsButton.setTitleColor(App.Style.SliderMenue.activeColor, for: .normal)
        self.spotsButton.setTitleColor(App.Style.SliderMenue.deactiveColor, for: .normal)
    }
    
    func setSpotsBtnActive(){
        self.songsButton.setTitleColor(App.Style.SliderMenue.deactiveColor, for: .normal)
        self.artistsButton.setTitleColor(App.Style.SliderMenue.deactiveColor, for: .normal)
        self.playlistsButton.setTitleColor(App.Style.SliderMenue.deactiveColor, for: .normal)
        self.spotsButton.setTitleColor(App.Style.SliderMenue.activeColor, for: .normal)
    }
    
    @IBAction func songsBtnTapped(_ sender: UIButton) {
        self.setSongsBtnActive()
        sender.animateBounceView()
        let notification = Notification(name: App.LocalNotification.Name.searchSongShouldBecomeActive)
        NotificationCenter.default.post(notification)
    }
    
    @IBAction func artistsBtnTapped(_ sender: UIButton) {
        self.setArtistsBtnActive()
        sender.animateBounceView()
        let notification = Notification(name: App.LocalNotification.Name.searchArtistsShouldBecomeActive)
        NotificationCenter.default.post(notification)
    }
    
    @IBAction func playlistsBtnTapped(_ sender: UIButton) {
        self.setPlaylistsBtnActive()
        sender.animateBounceView()
        let notification = Notification(name: App.LocalNotification.Name.searchPlaylistsShouldBecomeActive)
        NotificationCenter.default.post(notification)
    }
    
    @IBAction func spotsBtnTapped(_ sender: UIButton) {
        self.setSpotsBtnActive()
        sender.animateBounceView()
        let notification = Notification(name: App.LocalNotification.Name.searchSpotsShouldBecomeActive)
        NotificationCenter.default.post(notification)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("PREPARE CALLED")
        if let iden = segue.identifier {
            switch iden {
                case App.SegueIden.embedSearchPageVCIden:
                    if let searchEmbedPageVC = segue.destination as? SearchEmbedViewController {
                        searchEmbedPageVC.customDelegate = self
                        self.searchEmbedPageVC = searchEmbedPageVC
                        self.searchBar.delegate = searchEmbedPageVC
                        print("SET THE SEARCH BAR DELEGATE TO EMBEDDED SEARCH PAGE VC")
                    }
                default:
                    break
                }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

extension SearchViewController: HomeEmbedPageViewControllerDelegate {
    func willTransitionToPage(viewController: UIViewController, pageIndex: Int) {
//        print("IS CALLED WITH INDEX: \(pageIndex)")
        if pageIndex == 0 {
            self.setSongsBtnActive()
        } else if pageIndex == 1 {
            self.setArtistsBtnActive()
        } else if pageIndex == 2 {
            self.setPlaylistsBtnActive()
        } else if pageIndex == 3 {
            self.setSpotsBtnActive()
        } else {
            print("CASE NOT HANDLED")
        }
    }
}

