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

class LogInViewController: UIViewController {
    
    lazy var gradientLayer = CAGradientLayer()
    
    
    let fromColor = [
        UIColor(hexString: "#7D0E73").cgColor,
        UIColor(hexString: "#A2136B").cgColor,
        ]
    
    let toColor = [
        UIColor(hexString: "#175D9A").cgColor,
        UIColor(hexString: "#0E497D").cgColor
    ]
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            self.scrollView.delegate = self
            self.scrollView.alwaysBounceVertical = true
        }
    }
    
    
    @IBOutlet weak var loginBtn: UIButton!
    
    
    weak var delegate: LogInViewControllerDelegate?
   
    
    
    @IBAction func loginTapped(_ sender: UIButton) {
        //login with spotify
        UIApplication.shared.openURL(SpotifyClient.auth.spotifyWebAuthenticationURL())
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(self.gradientLayer, at: 0)
        self.gradiendStart(fromColor: self.fromColor, toColor: self.toColor)
        
        //set up
        NotificationCenter.default.addObserver(self, selector: #selector(LogInViewController.onLoginSuccessful), name: App.LocalNotification.Name.onLoginSuccessful, object: nil)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func login(username: String, password: String){
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            //segeu to home
            if user != nil{
                self.delegate?.finishedLogin()
            }
        }
    }
    
    func gradiendStart(fromColor: [CGColor], toColor: [CGColor] ){
        self.gradientLayer.colors = toColor
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromColor
        animation.toValue = toColor
        animation.delegate = self
        animation.duration = 10
        self.gradientLayer.add(animation, forKey: "animateGradient")
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    func onLoginSuccessful(){
        self.delegate?.finishedLogin()
    }
    
    
}


extension LogInViewController: CAAnimationDelegate{
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let caAnimation = anim as? CABasicAnimation{
            guard let newFromColor = caAnimation.toValue as? [CGColor] else{
                return
            }
            guard let newToColor = caAnimation.fromValue as? [CGColor] else{
                return
            }
            self.gradiendStart(fromColor: newFromColor, toColor: newToColor)
        }
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

