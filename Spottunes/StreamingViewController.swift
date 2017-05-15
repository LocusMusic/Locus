//
//  StreamingViewController.swift
//  Spottunes
//
//  Created by Xie kesong on 5/12/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

class StreamingViewController: UIViewController {
    
    @IBOutlet weak var spotBtn: UIButton!
    
    @IBAction func spotBtnTapped(_ sender: UIButton) {
        self.setSpotBtnActive()
        sender.animateBounceView()
        let notification = Notification(name: App.LocalNotification.Name.streamingSpotShouldBecomeActive)
        NotificationCenter.default.post(notification)
    }
    
    @IBOutlet weak var queueBtn: UIButton!
    
    
    @IBAction func queueBtnTapped(_ sender: UIButton) {
        self.setQueueViewBtnActive()
        sender.animateBounceView()
        let notification = Notification(name: App.LocalNotification.Name.streamingQueueShouldBecomeActive)
        NotificationCenter.default.post(notification)
    }
    
    var streamingEmbedPageVC: StreamingEmbedViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    class func instantiateFromStoryboard() -> StreamingViewController?{
        if let streammingVC = App.streammingStoryBoard.instantiateViewController(withIdentifier: App.StreammingStoryboradIden.streamingViewController) as? StreamingViewController{
            streammingVC.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "music-symbol-tab"), selectedImage: nil)
            streammingVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
            return streammingVC
        }
        return nil
    }
    
    func setSpotBtnActive(){
        self.spotBtn.setTitleColor(App.Style.SliderMenue.activeColor, for: .normal)
        self.queueBtn.setTitleColor(App.Style.SliderMenue.deactiveColor, for: .normal)
    }
    func setQueueViewBtnActive(){
        self.spotBtn.setTitleColor(App.Style.SliderMenue.deactiveColor, for: .normal)
        self.queueBtn.setTitleColor(App.Style.SliderMenue.activeColor, for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let iden = segue.identifier{
            switch iden{
            case App.SegueIden.streamEmbedPageVCIden:
                if let streamingEmbedPageVC = segue.destination as? StreamingEmbedViewController{
                    streamingEmbedPageVC.customDelegate = self
                    self.streamingEmbedPageVC = streamingEmbedPageVC
                }
            default:
                break
            }
        }
    }
}


extension StreamingViewController: StreamingEmbedViewControllerDelegate{
    func willTransitionToPage(viewController: UIViewController, pageIndex: Int) {
        if pageIndex == 0 {
            self.setSpotBtnActive()
        }else{
            self.setQueueViewBtnActive()
        }
        
    }
}
