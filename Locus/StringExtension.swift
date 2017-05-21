//
//  StringExtension.swift
//  Locus
//
//  Created by Leo Wong on 5/12/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

extension String {
    func addPercentEncodingForURLQueryVal() -> String? {
        let allowedChars = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        return self.addingPercentEncoding(withAllowedCharacters: allowedChars)
    }
}
