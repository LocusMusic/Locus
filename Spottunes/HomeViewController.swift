//
//  HomeViewController.swift
//  Spottunes
//
//  Created by Xie kesong on 4/25/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

fileprivate let collectionViewReuseIden = "HomePagingCell"

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
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            self.scrollView.showsHorizontalScrollIndicator = false
            self.scrollView.alwaysBounceHorizontal = true
            self.scrollView.isPagingEnabled = true
        }
    }

    @IBOutlet weak var secondPageCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var homeHeaderView: UIView!

    var searchBarTextField: UITextField!
    
    
    //tab model
    var pages: [PageType] = [.overview, .playing]
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        // customize the search bar
        self.adjustSearchBarAppearance()
        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 0
        let scrollViewHeight = App.screenHeight - self.homeHeaderView.frame.size.height - tabBarHeight
        self.scrollView.contentSize = CGSize(width: CGFloat(self.pages.count) * App.screenWidth, height: scrollViewHeight)
        self.secondPageCenterConstraint.constant = App.screenWidth
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

