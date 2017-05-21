//
//  GradientBackgroundAnimatedViewController.swift
//  Locus
//
//  Created by Xie kesong on 4/23/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

class GradientBackgroundAnimatedViewController: UIViewController {
    lazy var gradientLayer = CAGradientLayer()
    
    let toColor = [
        UIColor(hexString: "#7D0E73").cgColor,
        UIColor(hexString: "#A2136B").cgColor,
        
        ]
    
    let fromColor = [
        UIColor(hexString: "#175D9A").cgColor,
        UIColor(hexString: "#0E497D").cgColor
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(self.gradientLayer, at: 0)
        self.gradiendStart(fromColor: self.fromColor, toColor: self.toColor)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
    func gradiendStart(fromColor: [CGColor], toColor: [CGColor] ){
        self.gradientLayer.colors = toColor
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromColor
        animation.toValue = toColor
        animation.delegate = self
        animation.duration = 20
        self.gradientLayer.add(animation, forKey: "animateGradient")
    }
    


}



extension GradientBackgroundAnimatedViewController: CAAnimationDelegate{
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
