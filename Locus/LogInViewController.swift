//
//  ViewController.swift
//  Instagram
//
//  Created by Xie kesong on 1/20/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.

import UIKit
import Parse

protocol LogInViewControllerDelegate: class {
    func finishedLogin()
}

class LogInViewController: GradientBackgroundAnimatedViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            self.scrollView.delegate = self
            self.scrollView.alwaysBounceVertical = true
        }
    }
    
    
    @IBOutlet weak var loginBtn: UIButton!{
        didSet{
            self.loginBtn.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!{
        didSet{
            self.loadingActivityIndicator.isHidden = true
            self.loadingActivityIndicator.hidesWhenStopped = true
        }
    }
    
    weak var delegate: LogInViewControllerDelegate?
    
    @IBAction func loginTapped(_ sender: UIButton) {
        //login with spotify
        sender.isEnabled = false
        guard let autheticateURL = SpotifyClient.auth.spotifyWebAuthenticationURL() else{
            return
        }
        self.startActivityIndicatorLoading()
        UIApplication.shared.open(autheticateURL, options: [:], completionHandler: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(LogInViewController.onLoginSuccessful), name: App.LocalNotification.Name.onLoginSuccessful, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    func startActivityIndicatorLoading(){
        self.loadingActivityIndicator.isHidden = false
        self.loadingActivityIndicator.startAnimating()
        self.loginBtn.setTitle("", for: .normal)
        self.loginBtn.setImage(nil, for: .normal)
    }
    
    func stopActivityIndicatorLoading(){
        self.loadingActivityIndicator.stopAnimating()
        self.loginBtn.imageView?.isHidden = false
        self.loginBtn.setImage(#imageLiteral(resourceName: "login-with-spotify"), for: .normal)
        self.loginBtn.setTitle(App.Style.LoginBtn.activeTitle, for: .normal)
    }
    
    func onLoginSuccessful(){
        print("onLoginSuccessful!!")
        self.delegate?.finishedLogin()
    }
    
}


extension LogInViewController: UIScrollViewDelegate{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y < 60{
            self.view.endEditing(true)
        }
    }
}

extension LogInViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

