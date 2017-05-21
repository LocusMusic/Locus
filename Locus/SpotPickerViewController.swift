//
//  SpotPickerViewController.swift
//  Locus
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
    
    var searchSpots: [TuneSpot]?{
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
            self.searchBar.tintColor = App.backColor
            for subView in self.searchBar.subviews  {
                for subsubView in subView.subviews  {
                    if let textField = subsubView as? UITextField{
                        self.searchBarTextField = textField
                    }
                }
            }
        }
    }
    
    var searchBarTextField: UITextField!{
        didSet{
            self.searchBarTextField.clearButtonMode = .never
        }
    }
    
    let adjustSearchIconOffset: CGFloat = App.screenWidth / 2 - 30
    
    lazy var postInfo = [String: Any]()
    
    @IBOutlet weak var searchIconCenterXConstraint: NSLayoutConstraint!
    
    @IBAction func cancelBtnTapped(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var footerViewBottomConstraint: NSLayoutConstraint!
    
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: App.LocalNotification.Name.keyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: App.LocalNotification.Name.keyboardWillHide, object: nil)
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
    
    
    
    func keyboardDidShow(_ notification: Notification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size{
             self.footerViewBottomConstraint.constant = keyboardSize.height
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func keyboardWillHide(_ notification: Notification){
        self.footerViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
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
        if let searchText = self.searchBar.text, !searchText.isEmpty{
            return self.searchSpots?.count ?? 0
        }
        return  self.spots?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! SelectSpotTableViewCell
        if let searchText = self.searchBar.text, !searchText.isEmpty{
            cell.spot = self.searchSpots?[indexPath.row]
        }else{
            cell.spot = self.spots?[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var spot: TuneSpot!
        if let searchText = self.searchBar.text, !searchText.isEmpty{
            spot = self.searchSpots?[indexPath.row]
        }else{
            spot = self.spots?[indexPath.row]
        }
        self.performSegue(withIdentifier: App.SegueIden.selectPlayListSegue, sender: spot)
    }
    
}



extension SpotPickerViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty{
            TuneSpot.searchNearbyTuneSpotInclusive(query: searchText) { (spots) in
                if let spots = spots{
                    self.searchSpots = spots
                }
            }
        }
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        self.searchIconCenterXConstraint.constant = self.searchIconCenterXConstraint.constant - adjustSearchIconOffset
        UIView.animate(withDuration: 0.3, delay: 0.4, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        self.searchIconCenterXConstraint.constant = self.searchIconCenterXConstraint.constant + adjustSearchIconOffset
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        self.footerViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        self.tableView.reloadData()

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
