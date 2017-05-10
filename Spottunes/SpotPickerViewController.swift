//
//  SpotPickerViewController.swift
//  Spottunes
//
//  Created by Xie kesong on 5/9/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

fileprivate let reuseIden = "SelectSpotTableViewCell"
fileprivate let cellNibName = "SelectSpotTableViewCell"


class SpotPickerViewController: UIViewController {

    var spots: [TuneSpot]?{
        didSet{
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            self.searchBar.backgroundImage = UIImage() //remove the search bar border
            self.searchBar.delegate = self
            for subView in self.searchBar.subviews  {
                for subsubView in subView.subviews  {
                    if let textField = subsubView as? UITextField{
                        self.searchBarTextField = textField
                    }
                }
            }
        }
    }
    
    var searchBarTextField: UITextField!
    
    let adjustSearchIconOffset: CGFloat = App.screenWidth / 2 - 30
    
    lazy var postInfo = [String: Any]()
    
    @IBOutlet weak var searchIconCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBAction func shareBtnTapped(_ sender: UIButton) {
    }
    
    @IBAction func cancelBtnTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.alwaysBounceVertical = true
            self.tableView.estimatedRowHeight = 60
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: reuseIden)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TuneSpot.getNearByTuneSpots { (spots) in
            if let spots = spots{
                self.spots = spots
            }
        }

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchBarTextField.leftViewMode = .never //don't show the magnify icon
        self.searchBarTextField.tintColor = App.grayColor

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let iden = segue.identifier{
            switch iden{
            case App.SegueIden.selectPlayListSegue:
                if let selectionPlaylistVC = segue.destination as? SelectionFromPlaylistViewController{
                    guard let spot = (sender as? TuneSpot) else{
                        return
                    }
                    self.postInfo[App.PostInfoKey.spot] = spot
                    selectionPlaylistVC.postInfo = postInfo
                }
            default:
                break
            }
        }
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


extension SpotPickerViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.spots?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! SelectSpotTableViewCell
        cell.spot = self.spots?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let spot = self.spots?[indexPath.row]
        self.performSegue(withIdentifier: App.SegueIden.selectPlayListSegue, sender: spot)
    }
    
}



extension SpotPickerViewController: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchIconCenterXConstraint.constant = self.searchIconCenterXConstraint.constant - adjustSearchIconOffset
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchIconCenterXConstraint.constant = self.searchIconCenterXConstraint.constant + adjustSearchIconOffset
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
