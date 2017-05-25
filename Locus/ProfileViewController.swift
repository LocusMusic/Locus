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
            
            self.tableView.register(UINib(nibName: RecentlyVisitedCollectionTableViewCellNibName, bundle: nil), forCellReuseIdentifier: RecentlyVisitedCollectionTableViewCellReuseIden)

            self.tableView.register(UINib(nibName: SpotPlaylistTableViewCellNibName, bundle: nil), forCellReuseIdentifier: SpotPlaylistTableViewCellReuseIden)
        }
    }
    @IBOutlet weak var tableHeaderView: UIView!
    
    @IBOutlet weak var coverImageView: UIImageView!
    
    
    @IBOutlet weak var visitedCountLabel: UILabel!
    
    @IBOutlet weak var postsCountLabel: UILabel!
    
    @IBOutlet weak var fullnameLabel: UILabel!{
        didSet{
            self.fullnameLabel?.text = User.current()?.displayName
        }
    }

    
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
    
    var shouldShowRecentlyVisistedSection = false{
        didSet{
            self.tableView?.reloadData()
        }
    }
    
    var playlistPosts: [PlaylistPost]?{
        didSet{
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    
    
    //status bar control
    var statusBarStyle: UIStatusBarStyle = .lightContent
    
    private var isViewAppeared = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        App.setStatusBarStyle(style: .lightContent)
        NotificationCenter.default.addObserver(self, selector: #selector(recentlyVisitedShouldUpdate(_:)), name: App.LocalNotification.Name.recentlyVisitedShouldUpdate, object: nil)
        
        self.shouldShowRecentlyVisistedSection = (User.current()?.recentlyVisitedSpot?.spots.count ??  0) > 0
        
        self.visitedCountLabel.text = String(User.current()?.recentlyVisitedSpot?.spots.count ?? 0)
        self.visitedCountLabel.alpha = 1.0

        //fetch playlist posts
        PlaylistPost.fetchCurrentUserPlaylistPosts { (playlistPosts) in
            self.playlistPosts = playlistPosts
            DispatchQueue.main.async {
                self.postsCountLabel.text = String(self.playlistPosts?.count ?? 0)
                self.postsCountLabel.alpha = 1.0
            }
        }
        
        //Load the profile image
        User.current()?.loadUserProfileImage(withCompletion: { (image, error) in
            DispatchQueue.main.async {
                self.coverImageView.image = image
            }
        })
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.headerHeightConstraint.constant = UIScreen.main.bounds.size.height / 2.0
        self.adjustNavigationApperance()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    
    func recentlyVisitedShouldUpdate(_ notification: Notification){
        DispatchQueue.main.async {
            self.shouldShowRecentlyVisistedSection = true
            self.tableView?.reloadData()
        }
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
    
    
    func adjustNavigationApperance(){
        let adjustOffset = self.tableView.contentOffset.y + headerOriginHeight
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

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.shouldShowRecentlyVisistedSection ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.shouldShowRecentlyVisistedSection{
            if section == 0{
                //return the number of recently visited spot
                return 1
            }
        }
        return self.playlistPosts?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.shouldShowRecentlyVisistedSection{
            if indexPath.section == 0{
                //return the number of recently visited spot
                let cell = tableView.dequeueReusableCell(withIdentifier: RecentlyVisitedCollectionTableViewCellReuseIden, for: indexPath) as!RecentlyVisitedCollectionTableViewCell
                cell.spots = User.current()?.recentlyVisitedSpot?.spots
                return cell
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: SpotPlaylistTableViewCellReuseIden, for: indexPath) as! SpotPlaylistTableViewCell
        cell.playlistPost = self.playlistPosts?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.shouldShowRecentlyVisistedSection{
            if indexPath.section == 0{
                return App.Style.RecentlyVisistCollectionSession.height
            }
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.shouldShowRecentlyVisistedSection{
            if section == 0{
                return ReusableTableSectionHeaderView.instanceFromNib(withTitle: App.Style.TableSessionHeader.recentlyVisitSpotHeaderTitle)
            }
        }
        return ReusableTableSectionHeaderView.instanceFromNib(withTitle: App.Style.TableSessionHeader.playlistPostHeaderTitle)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return App.Style.TableSessionHeader.height
    }
}




