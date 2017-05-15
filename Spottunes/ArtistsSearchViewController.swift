//
//  ArtistsSearchViewController.swift
//  Spottunes
//
//  Created by Leo Wong on 5/10/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

fileprivate let reuseIden = "SearchTableViewCell"
fileprivate let nibbName = "SearchTableViewCell"

class ArtistsSearchViewController: UIViewController {
    
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
    
    var data : Artists? {
        didSet {
            DispatchQueue.main.async {
                if let table = self.tableView {
                    table.reloadData()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

extension ArtistsSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data?.artistList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! SearchTableViewCell
        cell.data = self.data?.artistList?[indexPath.row]
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
