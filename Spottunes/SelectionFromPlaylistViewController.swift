//
//  SelectionFromPlaylistViewController.swift
//  Spottunes
//
//  Created by Xie kesong on 5/2/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

fileprivate let reuseIden = "PlaylistTableViewCell"
fileprivate let cellNibName = "PlaylistTableViewCell"

class SelectionFromPlaylistViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: reuseIden)
            self.tableView.estimatedRowHeight = 50
            self.tableView.contentInset = App.Style.TableView.contentInset
            self.tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    
    @IBAction func backBtnTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    var playlists: [Playlist]?{
        didSet{
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.tableView?.reloadData()
                
            }
        }
    }
    
    var postInfo: [String: Any]!
    
    var selectedIndex = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SpotifyClient.fetchCurrentUserPlayList { (playlists) in
            if let playlists = playlists{
                self.playlists = playlists
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let iden = segue.identifier{
            switch iden{
            case App.SegueIden.selectSongsSegue:
                if let selectSongsVC = segue.destination as? SelectSongsViewController{
                    guard let playlist = (sender as? Playlist) else{
                        return
                    }
                    self.postInfo[App.PostInfoKey.playlist] = playlist
                    selectSongsVC.postInfo = self.postInfo
                }
            default:
                break
            }
        }

    }

}


extension SelectionFromPlaylistViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playlists?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! PlaylistTableViewCell
        cell.playlist = self.playlists![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //segue to select songs
        let playlist = self.playlists?[indexPath.row]
        self.performSegue(withIdentifier: App.SegueIden.selectSongsSegue, sender: playlist)
    }
}
