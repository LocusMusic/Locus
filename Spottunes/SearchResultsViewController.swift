//
//  SearchResultsViewController.swift
//  Spottunes
//
//  Created by Leo Wong on 5/4/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

fileprivate let reuseIden = "SearchTableViewCell"

class SearchResultsViewController: UIViewController {
    
    var data : [Any]?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! SearchTableViewCell
        
        //cell.titleLabel.text = self.data?[indexPath.row]

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
