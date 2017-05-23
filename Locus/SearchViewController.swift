//
//  SearchViewController.swift
//  Locus
//
//  Created by Leo Wong on 5/3/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

fileprivate let reuseIden = "SearchTableViewCell"
fileprivate let nibbName = "SearchTableViewCell"

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
    
    @IBOutlet weak var tableView: UITableView!
    
    var data: [Spot]?
    
    var searchBarTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SEARCHVIEW DID LOAD")
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
        let font = UIFont(name: "Avenir-Book", size:15.0)
        self.searchBarTextField.tintColor = App.grayColor
        self.searchBarTextField.layer.cornerRadius = self.searchBarTextField.frame.size.height / 2
        self.searchBarTextField.clipsToBounds = true
        self.searchBarTextField.font = font
    }
    
}


extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        print("Am I here Search Button Clicked - SearchViewController")
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Am I here Begin Editing - SearchViewController")
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("Am I here End Editing - SearchViewController")
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        print("Am I here Search Bar Cancel Button - SearchViewController")
        self.dismiss(animated: false) {
            print("done dismissing")
        }
    }
    
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0//self.data?.playlists?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! SearchTableViewCell
        //cell.data = self.data?.playlists?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("TODO")
        //        let userInfo: [String: Any] = [
        //            App.LocalNotification.PlayViewShouldShow.tracksKey: self.trackList!,
        //            App.LocalNotification.PlayViewShouldShow.activeTrackIndex: indexPath.row
        //        ]
        //        App.postLocalNotification(withName: App.LocalNotification.PlayViewShouldShow.name, object: self, userInfo: userInfo)
    }
    
}

