//
//  PlayView.swift
//  Locus
//
//  Created by Xie kesong on 4/30/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit
import Parse
import AVFoundation


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
    
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    @IBOutlet weak var minTrackNameLabel: UILabel!
    @IBOutlet weak var minAuthorNameLabel: UILabel!

    @IBAction func sliderDragging(_ sender: UISlider) {
        let position = TimeInterval(sender.value) * self.trackList[activeTrackIndex].duration //seconds
        self.currentTimeLabel.text = formatTimeInterval(timeInterval: position)

        self.streamController.seek(to: position) { (error) in
            if let error = error{
                print("error dragging \(error.localizedDescription)")
            }
        }
    }
    
    
    var currentPlayingState = false{
        didSet{
            if currentPlayingState{
                self.playBtn.imageBtnActivateWithColor(color: App.backColor, usingImage: #imageLiteral(resourceName: "playing-icon"), withBounceAnimation: true)
                self.minPlayBtn.imageBtnActivateWithColor(color: App.backColor, usingImage: #imageLiteral(resourceName: "playing-icon"), withBounceAnimation: true)
            }else{
                self.playBtn.imageBtnActivateWithColor(color: App.grayColor, usingImage: #imageLiteral(resourceName: "play-icon"), withBounceAnimation: true)
                self.minPlayBtn.imageBtnActivateWithColor(color: App.grayColor, usingImage: #imageLiteral(resourceName: "play-icon"), withBounceAnimation: true)
            }
        }
    }
    
    @IBOutlet weak var sliderControl: UISlider!{
        didSet{
            self.sliderControl.isContinuous = false
        }
    }
    
    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var minPlayBtn: UIButton!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var endingTimeLabel: UILabel!
    
    @IBOutlet weak var minProgressView: UIProgressView!
    
    lazy var streamController: SPTAudioStreamingController = SPTAudioStreamingController.sharedInstance()
    
    
    @IBAction func favorBtnTapped(_ sender: UIButton) {
        sender.imageBtnActivateWithColor(color: App.Style.Color.heartActiveColor)
    }

    @IBAction func playToggle(_ sender: UIButton) {
        sender.animateBounceView()
        self.streamController.setIsPlaying(!self.currentPlayingState) { (error) in
            if let error = error{
                print(error.localizedDescription)
            }else{
                if self.currentPlayingState{
                    User.current()?.resetPlayingState()
                }else{
                    User.current()?.currentActiveTrackIndex = self.activeTrackIndex
                }
                self.currentPlayingState = !self.currentPlayingState
            }
        }
    }
    
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        sender.animateBounceView()
        self.playNextTrack()
    }
    
    var delegate: PlayViewDelegate?
    var state: PlayViewUIState = .hidden
    var delta: CGFloat = 0
    var originalCenter: CGPoint!
    var minimizedCenter:CGPoint!
    var maximizedCenter:CGPoint!
    var trackList: [Track]!
    var activeTrackIndex: Int!{
        didSet{
           User.current()?.currentActiveTrackIndex = self.activeTrackIndex
        }
    }
    
    //true when the user is playing music from spot
    var playerPlaying = false

    @IBAction func prevBtnTapped(_ sender: UIButton) {
        sender.animateBounceView()
        print(self.activeTrackIndex)

        guard let currentActiveIndex = self.activeTrackIndex else{
            return
        }
        
        if currentActiveIndex < 1{
            return
        }
        
        self.activeTrackIndex = currentActiveIndex - 1
        App.playTracks(trackList: self.trackList, activeTrackIndex: self.activeTrackIndex)
    }
    
    
    func updateTracksState(){
        DispatchQueue.main.async {
            self.thumbnailImageView.image = nil
            if let image = self.trackList[self.activeTrackIndex] .getCoverImage(withSize: .large) {
                if let url = image.url{
                    self.thumbnailImageView.loadImageWithURL(url)
                }
            }
            if let authorName = self.trackList[self.activeTrackIndex].artists?.first?.name{
                self.authorNameLabel.text = authorName
                self.minAuthorNameLabel.text = authorName
            }
            if let trackName = self.trackList[self.activeTrackIndex].name{
                self.trackNameLabel.text = trackName
                self.minTrackNameLabel.text = trackName
            }
            self.endingTimeLabel.text =  formatTimeInterval(timeInterval: self.trackList[self.activeTrackIndex].duration)
            self.playActiveTrack()
            let audioSession = AVAudioSession.sharedInstance()
            do{
                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            }catch{
                print("can't play in the background")
            }
        }
    }

    class func instanceFromNib() -> PlayView {
        let playView = UINib(nibName: xibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PlayView
        //add pan gesture
        let pan = UIPanGestureRecognizer(target: playView, action: #selector(playViewPanning(_:)))
        playView.addGestureRecognizer(pan)
        playView.isUserInteractionEnabled = true
        playView.initPlayer()
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
                if self.delta < 0.8{
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
                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 6, options: .curveEaseInOut, animations: {
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
                let newCenterY = max(self.maximizedCenter.y, self.originalCenter.y + translation.y)
                self.delta = 1 - abs((newCenterY - destinationCenterY)) / (destinationCenterY - self.originalCenter.y) //maps from 0 to 1 //change
                self.minPlayerView.alpha = self.delta
                self.center.y = newCenterY
                self.delegate?.panning(playView: self, delta: self.delta)
            case .ended:
                print(self.delta)
                if self.delta < 0.2{
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
    
    func playActiveTrack(){
        guard let activeTrackURI = self.trackList[activeTrackIndex].uri else{
            return
        }
        
        //save the current user listening track to the database
        guard let currentUser = User.current() else{
            return
        }
        
        currentUser.currentActiveTrackIndex = self.activeTrackIndex
        self.streamController.playSpotifyURI(activeTrackURI, startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if let error = error {
                print(error.localizedDescription)
            }else{
                self.currentPlayingState = true
            }
        })
    }
    
    func playNextTrack(){
        guard let totalTracks = self.trackList?.count else{
            return
        }
        guard let currentActiveIndex = self.activeTrackIndex else{
            return
        }
        
        if currentActiveIndex == totalTracks - 1{
            return
        }
        self.activeTrackIndex = currentActiveIndex + 1
        App.playTracks(trackList: self.trackList, activeTrackIndex: self.activeTrackIndex)
    }
    

}

extension PlayView: SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    func initPlayer() {
        self.streamController.playbackDelegate = self
        self.streamController.delegate = self
        do{
            try streamController.start(withClientId:  SpotifyClient.auth.clientID)
            let currentSession = SpotifyClient.auth.session
            if currentSession != nil && currentSession!.isValid(){
                print("session is valid ...")
                self.streamController.login(withAccessToken: currentSession?.accessToken)
            }else{
                SpotifyClient.auth.renewSession(currentSession, callback: { (error, session) in
                    if let session = session{
                        print("renewing session...")
                        //login after retrieving new access token
                        self.streamController.login(withAccessToken: session.accessToken)
                    }else if let error = error{
                        print(error.localizedDescription)
                    }
                })
            }
        }catch{
            print("can't start streaming view controller")
        }
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePosition position: TimeInterval) {
        self.currentTimeLabel.text = formatTimeInterval(timeInterval: position)
        let percentage = position / self.trackList[activeTrackIndex].duration
        self.sliderControl.value = Float(percentage)
        self.minProgressView.progress = self.sliderControl.value
    }
    
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStopPlayingTrack trackUri: String!) {
        //go to the next song in the play queue
        self.playNextTrack()
    }
}


