//
//  NavigationViewControllerExtension.swift
//  Locus
//
//  Created by Leo Wong on 5/22/17.
//  Copyright © 2017 ___Locus___. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    public func pushViewController(viewController: UIViewController,
                                   animated: Bool,
                                   completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    public func popViewControllerWithHandler(animated: Bool, completion:  (()-> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewController(animated: animated)
        CATransaction.commit()
    }
    
}
