//
//  MapViewController.swift
//  Spottunes
//
//  Created by Xie kesong on 4/15/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    
    @IBOutlet weak var suggestSpotListView: UIView!{
        didSet{
            self.suggestListViewCenterXConstraint.constant = UIScreen.main.bounds.size.width
        }
    }
    
    @IBOutlet weak var suggestListViewCenterXConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggingInMapView(_:)))
//        self.view.addGestureRecognizer(panGesture)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
