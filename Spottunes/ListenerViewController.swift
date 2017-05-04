//
//  ListenerViewController.swift
//  Spottunes
//
//  Created by Xie kesong on 4/29/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

fileprivate let reuseIden = "ListenerCellIden"
fileprivate let xibName = "ListenerTableViewCell"

class ListenerViewController: UIViewController {
    
    @IBOutlet weak var navigationHeaderViewWrapper: UIView!{
        didSet{
            let navigationHeaderView = NavigationHeaderView.instanceFromNib(withTitle: "Listeners")
            navigationHeaderView.delegate = self
            self.navigationHeaderViewWrapper.addSubview(navigationHeaderView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.alwaysBounceVertical = true
            self.tableView.estimatedRowHeight = self.tableView.rowHeight
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.register(UINib(nibName: xibName, bundle: nil), forCellReuseIdentifier: reuseIden)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ListenerViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! ListenerTableViewCell
        return cell
        
    }
}

extension ListenerViewController: NavigationHeaderViewDelegate{
    func backBtnTapped(header: NavigationHeaderView) {
        self.navigationController?.popViewController(animated: true)
    }
}
