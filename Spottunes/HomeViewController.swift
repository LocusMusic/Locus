//
//  HomeViewController.swift
//  Spottunes
//
//  Created by Xie kesong on 4/25/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

fileprivate let collectionViewReuseIden = "HomePagingCell"
fileprivate let playingEmbedSegueIden="PlayingEmbedSegueIden"

enum PageType{
    case overview
    case playing
}

class HomeViewController: UIViewController {

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

    @IBOutlet weak var overviewBtn: UIButton!
    
    @IBAction func overviewBtnTapped(_ sender: UIButton) {
        self.setOverViewBtnActive()
        sender.animateBounceView()
        let notification = Notification(name: App.LocalNotification.Name.homeOverviewShouldBecomeActive)
        NotificationCenter.default.post(notification)
    }
    
    @IBAction func playingBtnTapped(_ sender: UIButton) {
        self.setPlayingViewBtnActive()
        sender.animateBounceView()
        let notification = Notification(name: App.LocalNotification.Name.homePlayingShouldBecomeActive)
        NotificationCenter.default.post(notification)
    }
    
    @IBOutlet weak var playingBtn: UIButton!
    
    //tab model
    var pages: [PageType] = [.overview, .playing]
    
    
    var homeEmbedPageVC: HomeEmbedPageViewController?
    
    var searchBarTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        self.adjustSearchBarAppearance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func adjustSearchBarAppearance(){
        self.searchBarTextField.tintColor = App.grayColor
        self.searchBarTextField.layer.cornerRadius = self.searchBarTextField.frame.size.height / 2
        self.searchBarTextField.clipsToBounds = true
        let font = UIFont(name: "Avenir-Book", size:15.0)
        self.searchBarTextField.font = font
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let iden = segue.identifier{
            switch iden{
            case App.SegueIden.embedPageVCIden:
                if let homeEmbedPageVC = segue.destination as? HomeEmbedPageViewController{
                    homeEmbedPageVC.customDelegate = self
                    self.homeEmbedPageVC = homeEmbedPageVC
                }
            default:
                break
            }
        }
    }
    
    func setOverViewBtnActive(){
        self.overviewBtn.setTitleColor(App.Style.SliderMenue.activeColor, for: .normal)
        self.playingBtn.setTitleColor(App.Style.SliderMenue.deactiveColor, for: .normal)
    }
    func setPlayingViewBtnActive(){
        self.overviewBtn.setTitleColor(App.Style.SliderMenue.deactiveColor, for: .normal)
        self.playingBtn.setTitleColor(App.Style.SliderMenue.activeColor, for: .normal)
    }
}



extension HomeViewController: UISearchBarDelegate{
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


extension HomeViewController: HomeEmbedPageViewControllerDelegate{
    func willTransitionToPage(viewController: UIViewController, pageIndex: Int) {
        if pageIndex == 0 {
            self.setOverViewBtnActive()
        }else{
            //swipe to palying view controller
            self.setPlayingViewBtnActive()
        }

    }
}

