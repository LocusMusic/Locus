//
//  UITabBarExtension.swift
//  Spottunes
//
//  Created by Xie kesong on 5/11/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//



import UIKit

extension UITabBar{
    func updateTabBarAppearance(){
        self.unselectedItemTintColor = App.grayColor
        self.tintColor = App.Style.TabBar.tintColor
        self.barTintColor = App.Style.TabBar.barTintColor
        self.isTranslucent = App.Style.TabBar.isTranslucent
        self.layer.borderWidth = 0.50
        self.layer.borderColor = App.grayColor.cgColor.copy(alpha: 0.3)
        self.clipsToBounds = true
    }
}

