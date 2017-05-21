//
//  UINavigationBarExtension.swift
//  Locus
//
//  Created by Xie kesong on 5/8/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

extension UINavigationBar{
    func updateNavigationBarAppearance(){
        self.barTintColor = App.Style.NavigationBar.barTintColor
        self.titleTextAttributes = App.Style.NavigationBar.titleTextAttribute
        self.clipsToBounds = App.Style.NavigationBar.clipsToBounds
        self.isTranslucent = App.Style.NavigationBar.isTranslucent
    }
}

