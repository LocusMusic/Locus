//
//  TunesDetailsViewController.swift
//  Spottunes
//
//  Created by Xie kesong on 4/15/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit
import Parse

fileprivate let resueIden = "ListsCell"

class TunesDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.estimatedRowHeight = self.tableView.rowHeight
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.backgroundColor = UIColor.clear
            let edge = UIEdgeInsets(top: self.headerOriginHeight, left: 0, bottom: 0, right: 0)
            self.tableView.contentInset = edge
        }
    }
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var headerViewTopConstraint: NSLayoutConstraint!
    
    var topLists = [PlayList]()
    
    var headerOriginHeight: CGFloat = UIScreen.main.bounds.size.width
    
    var statusBarStyle: UIStatusBarStyle = .lightContent

    
    @IBOutlet weak var navigationBarView: UIView!{
        didSet{
            self.navigationBarView.alpha = 0
        }
    }

    @IBOutlet weak var navigationItemCustom: UINavigationItem!{
        didSet{
            self.navigationItemCustom.title = "GEISEL LIBRARY"
        }
    }

    @IBOutlet weak var navigationBar: UINavigationBar!{
        didSet{
            self.navigationBar.barTintColor = UIColor.white
            self.navigationBar.titleTextAttributes = App.Style.navigationBar.titleTextAttribute
        }
    }
    
    @IBAction func shuffleBtnTapped(_ sender: UIButton) {
        let color = UIColor(hexString: "#D0A021")
        
        //D0A021
        sender.imageBtnActivateWithColor(color: color)
    }
    
    
    @IBAction func likeBtnTapped(_ sender: UIButton) {
        let color = UIColor(hexString: "#B70C1F")
        sender.imageBtnActivateWithColor(color: color)
    }
    
    
    @IBAction func playBtnTapped(_ sender: UIButton) {
        let color = UIColor(hexString: "#0F53B6")
        let image = #imageLiteral(resourceName: "playing-icon")
        sender.imageBtnActivateWithColor(color: color, usingImage: image)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        let playList_1 = PlayList(coverURL: "images-1", name: "EI Ten Eleven", hits: 142, username: "kesongxie")
        let playList_2 = PlayList(coverURL: "images-2", name: "Superior Focus Tunes", hits: 108, username: "leow")
        let playList_3 = PlayList(coverURL: "images-3", name: "Radio Music Station", hits: 98, username: "edison")
        let playList_4 = PlayList(coverURL: "images-4", name: "Nothing Was The Same", hits: 36, username: "leow")
        let playList_5 = PlayList(coverURL: "images-5", name: "Answer With An Album Cover", hits: 27, username: "leow")



        self.topLists = [playList_1, playList_2, playList_3, playList_4, playList_5, playList_1, playList_2, playList_3, playList_4, playList_5]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.headerViewHeightConstraint.constant = self.headerOriginHeight
        self.headerOriginHeight =  self.headerViewHeightConstraint.constant
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // self.animateZoomHeader()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func animateZoomHeader(){
        let transfrom = CGAffineTransform(scaleX: 2.0, y: 2.0)
        self.headerView.transform = transfrom
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
            self.headerView.transform = .identity
        }, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return self.statusBarStyle
    }
    
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //adjust heaer when scrollView is global self.tableView
        let adjustOffset = scrollView.contentOffset.y + headerOriginHeight
        if adjustOffset <= 0{
            self.headerViewTopConstraint.constant = 0
            self.headerViewHeightConstraint.constant = -scrollView.contentOffset.y
        }else{
            self.headerViewTopConstraint.constant = -adjustOffset * 0.6 //create a parallax effect for the header
            var shouldSetStatusBarStyleDefault = false
            let diff = adjustOffset - (self.headerOriginHeight - self.navigationBarView.frame.size.height)
            
            if diff > 0{
                self.navigationBarView.alpha = min(1, diff * 0.04)
                if self.navigationBarView.alpha > 0.2{
                    self.statusBarStyle = .default
                    shouldSetStatusBarStyleDefault = true
                }
            }else{
                self.navigationBarView.alpha = 0
            }
            
            //adjust the status bar style
            if !shouldSetStatusBarStyleDefault{
                self.statusBarStyle = .lightContent
            }
            self.setNeedsStatusBarAppearanceUpdate()
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

extension TunesDetailsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.topLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: resueIden, for: indexPath) as! ListTableViewCell
        cell.item = self.topLists[indexPath.row]
        return cell
    }

}
