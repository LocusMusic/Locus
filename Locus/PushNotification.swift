//
//  Notification.swift
//  Locus
//
//  Created by Xie kesong on 5/22/17.
//  Copyright © 2017 ___Locus___. All rights reserved.
//

import Parse


import Parse

fileprivate let ClassName = "Notification"
fileprivate let SenderKey = "sender"
fileprivate let ReceiverKey = "receiver"
fileprivate let TypeKey = "type" //reserve for later use, 0 for syncing music by other people
fileprivate let TargetIdKey = "targetId"
fileprivate let ReadStatusKey = "readStatus"
fileprivate let DetailDescriptionKey = "detailDescription"

enum NotificationType: Int{
    case sync = 0
    case playlistPostLike
}


class PushNotification: PFObject {
    
    var sender: User?{
        get{
            return self[SenderKey] as? User
        }
        set{
            return self[SenderKey] = newValue
        }
    }
    
    
    var receiver: User?{
        get{
            return self[ReceiverKey] as? User
        }
        set{
            self[ReceiverKey] = newValue
        }
    }
    
    var type: Int?{
        get{
            return self[TypeKey] as? Int
        }
        set{
             return self[TypeKey] = newValue
        }

    }
    
    //the id that associated with a given type of notification
    var targetId: String?{
        get{
            return self[TargetIdKey] as? String
        }
        set{
            self[TargetIdKey] = newValue
        }
    }

    //the read status for the receiever
    var readStatus: Int?{
        get{
            return self[ReadStatusKey] as? Int
        }
        set{
            self[ReadStatusKey] = newValue
        }
    }
    
    var detailDescription: String?{
        get{
            return self[DetailDescriptionKey] as? String
        }
        set{
            self[DetailDescriptionKey] = newValue
        }
    }
    
    init(sender: User, receiver: User, detailDescription: String, targetId: String, type: NotificationType, readStatus: Int = 0) {
        super.init()
        self.sender = sender
        self.receiver = receiver
        self.detailDescription = detailDescription
        self.targetId = targetId
        self.type = type.rawValue
        self.readStatus = readStatus
    }
    
    class func saveNotification(sender: User, receiver: User, detailDescription: String, targetId: String, type: NotificationType){
        let notification = PushNotification(sender: sender, receiver: receiver, detailDescription: detailDescription, targetId: targetId, type: type, readStatus: 0)
        notification.saveInBackground()
    }
}


extension PushNotification: PFSubclassing {
    static func parseClassName() -> String {
        return ClassName
    }
}
