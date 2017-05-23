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
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.alwaysBounceVertical = true
            self.tableView.estimatedRowHeight = 60
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0)
            self.tableView.register(UINib(nibName: nibbName, bundle: nil), forCellReuseIdentifier: reuseIden)
        }
    }

    var data : [TuneSpot]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    
    var searchBarTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.adjustSearchBarAppearance()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchBar.becomeFirstResponder()
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
        self.searchBarTextField.layoutIfNeeded()
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
        self.dismiss(animated: false) {
            print("done dismissing")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        TuneSpot.searchNearbyTuneSpot(query: searchText) { (tuneSpots) in
            print("Finished")
            if let spots = tuneSpots {
                print("Here")
                self.data = spots
            } else {
                print("Nil Here")
                self.data = nil
            }
        }
    }
    
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! SearchTableViewCell
        cell.data = self.data?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: SAFE UNWRAPPING 
        if let spotVC = App.spotStoryBoard.instantiateViewController(withIdentifier: App.SpotStoryboardIden.spotViewController) as? SpotViewController {
            spotVC.spot = self.data?[indexPath.row]
            self.searchBar.resignFirstResponder()
            self.dismiss(animated: true, completion: {
                
            })
        }
    }
    
}

