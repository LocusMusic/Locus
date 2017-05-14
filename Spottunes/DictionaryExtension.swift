//
//  DictionaryExtension.swift
//  Spottunes
//
//  Created by Leo Wong on 5/12/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

extension Dictionary {
    func stringFromHttpParams() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).addPercentEncodingForURLQueryVal()!
            let percentEscapedValue = (value as! String).addPercentEncodingForURLQueryVal()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joined(separator: "&")
    }
}
