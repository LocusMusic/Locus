//
//  PlayView.swift
//  Spottunes
//
//  Created by Xie kesong on 4/30/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit


fileprivate let xibName = "PlayView"

enum PlayViewUIState{
    case hidden
    case minimized
    case maximized
}

protocol PlayViewDelegate : class{
    func panning(playView : PlayView, delta: CGFloat)
    
    func playViewBecomeMaximized(playView : PlayView)
    func playViewBecomeMinimized(playView : PlayView)

}

class PlayView: UIView {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!{
        didSet{
            self.thumbnailImageView.layer.cornerRadius = 4.0
            self.thumbnailImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var minPlayerView: UIView!
    
    var delegate: PlayViewDelegate?
    var Playlist: Playlist!
    var state: PlayViewUIState = .hidden
    var delta: CGFloat = 0
    var originalCenter: CGPoint!

    var minimizedCenter:CGPoint!
    var maximizedCenter:CGPoint!

    
    
    class func instanceFromNib() -> PlayView {
        let playView = UINib(nibName: xibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PlayView
        //add pan gesture
        let pan = UIPanGestureRecognizer(target: playView, action: #selector(playViewPanning(_:)))
        playView.addGestureRecognizer(pan)
        playView.isUserInteractionEnabled = true
        return playView
    }
    
    
    func playViewPanning(_ gesture: UIPanGestureRecognizer){
        switch self.state{
        case .minimized:
            let translation = gesture.translation(in: nil)
            let destinationCenterY = 0.5 * App.screenHeight
            switch gesture.state{
            case .began:
                self.minimizedCenter = self.center
                self.originalCenter = self.center
            case .changed:
                let newCenterY = max(min(self.originalCenter.y, self.originalCenter.y + translation.y), destinationCenterY)
                self.delta = abs((newCenterY - destinationCenterY)) / (self.originalCenter.y - destinationCenterY) //maps from 1 to 0
                self.minPlayerView.alpha = self.delta
                self.center.y = newCenterY
                self.delegate?.panning(playView: self, delta: self.delta)
            case .ended:
                if self.delta < 0.9{
                    //set to open position
                    self.delegate?.playViewBecomeMaximized(playView: self)
                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 6, options: .curveEaseInOut, animations: {
                        self.center.y = destinationCenterY
                        self.minPlayerView.alpha = 0
                    }, completion: {
                        finished in
                        if finished{
                            self.state = .maximized
                        }
                    })
                }else{
                    self.delegate?.playViewBecomeMinimized(playView: self)
                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 6, options: .curveEaseInOut, animations: {
                        self.center.y = self.originalCenter.y
                        self.minPlayerView.alpha = 1
                    }, completion: {
                        finished in
                        if finished{
                            self.state = .minimized
                        }
                    })
                }
            default:
                break
            }
        case .maximized:
            let translation = gesture.translation(in: nil)
            let destinationCenterY = self.minimizedCenter.y
            switch gesture.state{
            case .began:
                self.maximizedCenter = self.center
                self.originalCenter = self.center
            case .changed:
                let newCenterY = self.originalCenter.y + translation.y
                self.delta = 1 - abs((newCenterY - destinationCenterY)) / (destinationCenterY - self.originalCenter.y) //maps from 0 to 1 //change
                self.minPlayerView.alpha = self.delta
                self.center.y = newCenterY
                self.delegate?.panning(playView: self, delta: self.delta)
            case .ended:
                if self.delta > 0.9{
                    //set to open position
                    self.delegate?.playViewBecomeMaximized(playView: self)

                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 6, options: .curveEaseInOut, animations: {
                        self.center.y = self.originalCenter.y
                        self.minPlayerView.alpha = 0
                    }, completion: {
                        finished in
                        if finished{
                            self.state = .maximized
                        }
                    })
                }else{
                    self.delegate?.playViewBecomeMinimized(playView: self)
                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 6, options: .curveEaseInOut, animations: {
                        self.center.y = destinationCenterY
                        self.minPlayerView.alpha = 1
                    }, completion: {
                        finished in
                        if finished{
                            self.state = .minimized
                        }
                    })
                }
            default:
                break
            }

        default:
            break
        }
    }
    
    
    
    
}
