//
//  UILabelExtension.swift
//  Locus
//
//  Created by Xie kesong on 5/23/17.
//  Copyright © 2017 ___Locus___. All rights reserved.
//

import UIKit

extension UILabel{
    func styleUsernaneText(username: String){
        guard let text = self.text else{
            return
        }
        let size = self.font.pointSize
        let attributedString = NSMutableAttributedString(string: text)
        let font = UIFont(name: "Avenir-Heavy", size: size)
        let boldAttribute = [NSFontAttributeName: font!]
        let range = (text as NSString).range(of: username)
        attributedString.addAttributes(boldAttribute, range: range)
        self.attributedText = attributedString
    }
}
