//
//  ParseAuthDelegate.swift
//  Spottunes
//
//  Created by Xie kesong on 5/19/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import Foundation
import Parse

class ParseAuthDelegate:NSObject, PFUserAuthenticationDelegate {
    func restoreAuthentication(withAuthData authData: [String : String]?) -> Bool {
        return true
    }
}
