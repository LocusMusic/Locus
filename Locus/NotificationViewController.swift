//
//  NotificationViewController.swift
//  Locus
//
//  Created by Xie kesong on 5/22/17.
//  Copyright © 2017 ___Locus___. All rights reserved.
//

import UIKit
import Parse


fileprivate let reuseIden = "NotificationTableViewCell"
fileprivate let cellNibName = "NotificationTableViewCell"

fileprivate let unreadNotificationHeaderTitle = "New"
fileprivate let readNotificationHeaderTitle = "History"
fileprivate let sectionHeaderHeight: CGFloat = 60.0

class NotificationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.alwaysBounceVertical = true
            self.tableView.estimatedRowHeight = 60
            self.tableView.refreshControl = self.refreshControl
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0)
            self.tableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: reuseIden)
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl =  UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshDragged(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    var unread: [PushNotification]?
    
    var read: [PushNotification]?
    
    var shouldShowNewSession: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        App.setStatusBarStyle(style: .default)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshNotification()
    }
    
    
    var finishedFecthingUnread = false
    var finishedFetchingRead = false
    
    func refreshNotification(){
        self.finishedFecthingUnread  = false
        self.finishedFetchingRead  = false
        PushNotification.fetch(readStatus: .unread) { (notifications) in
            self.finishedFecthingUnread = true
            self.unread = notifications
            if let unreadNotification = self.unread, unreadNotification.count > 0{
                self.shouldShowNewSession = true
                self.updateUnreadToRead()
            }else{
                print("unread count is nil")
            }
        }
        PushNotification.fetch(readStatus: .read) { (notifications) in
            self.finishedFetchingRead = true
            self.read = notifications
            self.updateUnreadToRead()
        }
    }
    
    func refreshDragged(_ refreshControl: UIRefreshControl){
        self.refreshNotification()
    }
    
    
    func updateUnreadToRead(){
        if self.finishedFecthingUnread && self.finishedFetchingRead{
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
            PushNotification.updateAllUnreadToRead(completionHandler: { (succeed, error) in
                if succeed{
                    print("changing should shoud new session to false")
                    self.shouldShowNewSession = false
                }
            })

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


extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //show new notification session when there is new unread
        print("shoud show new session \(self.shouldShowNewSession)")
        return self.shouldShowNewSession ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.shouldShowNewSession{
            if section == 0{
                //display the unread
                return self.unread?.count ?? 0
            }
        }
        return self.read?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! NotificationTableViewCell
        if self.shouldShowNewSession && indexPath.section == 0{
            cell.notification = self.unread?[indexPath.row]
        }else{
            cell.notification = self.read?[indexPath.row]
        }
        return cell
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.shouldShowNewSession{
            if section == 0{
                return ReusableTableSectionHeaderView.instanceFromNib(withTitle: unreadNotificationHeaderTitle)
            }
        }
        return ReusableTableSectionHeaderView.instanceFromNib(withTitle: readNotificationHeaderTitle)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }
}


