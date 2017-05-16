//
//  UIButtonExtension.swift
//  Spottunes
//
//  Created by Xie kesong on 4/15/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

extension UIButton{
    func imageBtnActivateWithColor(color: UIColor, usingImage image: UIImage? = nil, withBounceAnimation animated: Bool = true){
        let image = image ?? self.image(for: .normal)
        let tintedImage =  image?.withRenderingMode(.alwaysTemplate)
        self.setImage(tintedImage, for: .normal)
        self.tintColor = color
        if animated {
            self.animateBounceView()
        }
    }
}
