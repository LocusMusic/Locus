//
//  ProfileViewController.swift
//  Enchant
//
//  Created by Xie kesong on 2/10/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!{
        didSet{
            self.headerOriginHeight = UIScreen.main.bounds.size.height / 2.0
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            self.tableView.estimatedRowHeight = self.tableView.rowHeight
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.contentInset = UIEdgeInsets(top: headerOriginHeight, left: 0, bottom: 0, right: 0)
            self.tableView.contentOffset.y = -self.tableView.contentInset.top
            self.tableView.backgroundColor = UIColor.clear
            self.tableView.indicatorStyle = .white
        }
    }
    @IBOutlet weak var tableHeaderView: UIView!
    
    @IBOutlet weak var coverImageView: UIImageView!

    //header constraint
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerViewTopConstraint: NSLayoutConstraint!
    var headerOriginHeight: CGFloat = 0

    @IBOutlet weak var navigationBarView: UIView!{
        didSet{
            self.navigationBarView.alpha = 0
        }
    }
    
    @IBOutlet weak var navigationItemCustom: UINavigationItem!{
        didSet{
            self.navigationItemCustom.title = "Kesong Xie"
        }
    }
    
    @IBOutlet weak var navigationBar: UINavigationBar!{
        didSet{
            self.navigationBar.barTintColor = UIColor.white
            self.navigationBar.titleTextAttributes = App.Style.NavigationBar.titleTextAttribute
        }
    }
    
    
    @IBOutlet weak var statusBtn: UIButton!{
        didSet{
            self.statusBtn.layer.cornerRadius = 4.0
            self.statusBtn.clipsToBounds = true
        }
    }
    
    @IBAction func statusBtnTapped(_ sender: UIButton) {
        sender.animateBounceView(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5)
    }
    
    
    
    //status bar control
    var statusBarStyle: UIStatusBarStyle = .lightContent
    
    private var isViewAppeared = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        App.setStatusBarStyle(style: .lightContent)
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.headerHeightConstraint.constant = UIScreen.main.bounds.size.height / 2.0
        self.headerOriginHeight = self.headerHeightConstraint.constant
        self.tableView.setAndLayoutTableHeaderView(header: self.tableHeaderView)
        self.isViewAppeared = true
    }
    
    
    
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return self.statusBarStyle
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .fade
    }
    

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.isViewAppeared{
            if scrollView == self.tableView{
                //adjust heaer when scrollView is global self.tableView
                let adjustOffset = scrollView.contentOffset.y + headerOriginHeight
                if adjustOffset <= 0{
                    self.headerViewTopConstraint.constant = 0
                    self.headerHeightConstraint.constant = -scrollView.contentOffset.y
                }else{
                    print(adjustOffset)
                    self.headerViewTopConstraint.constant = -adjustOffset * 0.6 //create a parallax effect for the header
                    var shouldSetStatusBarStyleDefault = false
                    let diff = adjustOffset  - (UIScreen.main.bounds.size.height / 2 - self.navigationBarView.frame.size.height)
                    if diff > 0{
                        self.navigationBarView.alpha = min(1, diff * 0.04)
                        if self.navigationBarView.alpha > 0.2{
                            self.statusBarStyle = .default
                            shouldSetStatusBarStyleDefault = true
                        }
                    }else{
                        self.navigationBarView.alpha = 0
                    }
                    
                    let headerRect = self.tableHeaderView.convert(self.tableHeaderView.frame, from: nil)
                    //adjust the scroll bar style
                    if (-headerRect.origin.y) >= adjustOffset{
                        self.tableView.indicatorStyle = .white
                    }else{
                        self.tableView.indicatorStyle = .black
                    }
                    
                    //adjust the status bar style
                    if !shouldSetStatusBarStyleDefault{
                        self.statusBarStyle = .lightContent
                    }
                    App.setStatusBarStyle(style: self.statusBarStyle)
                }
            }
        }
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
}




