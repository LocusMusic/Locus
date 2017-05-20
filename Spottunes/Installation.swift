//
//  Installation.swift
//  Spottunes
//
//  Created by Xie kesong on 5/20/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import Parse

fileprivate let UserKey = "user"

extension PFInstallation{
    class func saveUserPointerToCurrentInstallation(user: User, completionHandler: @escaping PFBooleanResultBlock){
        guard let installation =  PFInstallation.current() else{
            return
        }
        //save the user pointer to the installation class for remote notificaiton deliver
        installation[UserKey] = user
        installation.saveInBackground(block: completionHandler)
    }
}
