//
//  UIImageViewExtension.swift
//  Spottunes
//
//  Created by Xie kesong on 5/2/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

extension UIImageView{
    func setColorOfImage(color: UIColor){
        if self.image != nil{
            self.image = self.image!.withRenderingMode(.alwaysTemplate)
            self.tintColor = color
        }

    }
}
