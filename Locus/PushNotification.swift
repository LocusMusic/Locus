//
//  Notification.swift
//  Locus
//
//  Created by Xie kesong on 5/22/17.
//  Copyright © 2017 ___Locus___. All rights reserved.
//

import Parse
import ParseLiveQuery

fileprivate let ClassName = "PushNotification"
fileprivate let SenderKey = "sender"
fileprivate let ReceiverIdKey = "receiverId"
fileprivate let TypeKey = "type" //reserve for later use, 0 for syncing music by other people
fileprivate let TargetIdKey = "targetId"
fileprivate let ReadStatusKey = "readStatus"
fileprivate let DetailDescriptionKey = "detailDescription"
fileprivate let CreatedAtKey = "_created_at"

enum NotificationType: Int{
    case subscribe = 0 //user subscribe to other listener's music
    case playlistPostLike //user favor a playlist post
}

enum ReadStatus{
    case read
    case unread
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
    
    
    var receiverId: String?{
        get{
            return self[ReceiverIdKey] as? String
        }
        set{
            self[ReceiverIdKey] = newValue
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
    
    override init() {
        super.init()
    }
    
    init(receiver: User, detailDescription: String, targetId: String, type: NotificationType, readStatus: Int = 0) {
        super.init()
        guard let currentUser = User.current() else{
            return
        }
        self.sender = currentUser
        self.receiverId = receiver.objectId
        self.detailDescription = detailDescription
        self.targetId = targetId
        self.type = type.rawValue
        self.readStatus = readStatus
    }
    
    class func addParseNotification(receiver: User, detailDescription: String, targetId: String, type: NotificationType){
        let notification = PushNotification(receiver: receiver, detailDescription: detailDescription, targetId: targetId, type: type, readStatus: 0)
        notification.saveInBackground()
    }
    
    class func addParseSubscriberNotification(receiver: User, detailDescription: String, targetId: String){
        let type: NotificationType = .subscribe
        PushNotification.addParseNotification(receiver: receiver, detailDescription: detailDescription, targetId: targetId, type: type)
    }
    
    
    //make sure playlistPost has all the data we want
    class func sendRemoteNotificationAfterSyncing(playlistPost: PlaylistPost){
        guard let subscriber = User.current() else{
            print("current user is nil")
            return
        }
        
        //get the subscriber display name
        var subscriberDisplayName: String! = subscriber.displayName
        
        //get the subscriber username in Parse
        let subscriberUsername = subscriber.username!
        
        guard let receiver = playlistPost.user else{
            return
        }
        
        //get the listener's username
        guard let receiverUsername = receiver.username else{
            print("receiver username is nil")
            return
        }
        
        //get the playlist name
        guard let playlistName = playlistPost.playlist?.name else{
            print("playlist name is empty")
            return
        }
        
        //get the playlist post id
        guard let playlistPostId = playlistPost.objectId else{
            print("playlistPostId is empty")
            return
        }
        
        //get the spot where this subscription happened
        guard let spotName = playlistPost.spot?.name else{
            print("spot name is empty")
            return
        }
        
        
        let param: [String: Any] = [
            "subscriberDisplayName": subscriberDisplayName,
            "subscriberUsername": subscriberUsername,
            "receiverUsername": receiverUsername,
            "playlistPostId": playlistPostId,
            "playlistName": playlistName,
            "spotName": spotName
        ]
        
        
        let detailDescription = subscriberDisplayName + " is playing your playlist: " + playlistName +  " at " + spotName;

        
        PushNotification.addParseSubscriberNotification(receiver: receiver, detailDescription: detailDescription, targetId: playlistPostId)
        
        PFCloud.callFunction(inBackground: "sendNotificaionAfterSongPlayedByOthers", withParameters: param, block: { (response, error) in
            print(response)
        })
    }
    
    //subscribe to push notification, whenever the user recevied a push
    class func subscribeTo(){
        guard let currentUser = User.current() else{
            return
        }
        
        guard let currentUserId = currentUser.objectId else{
            return
        }
        
        //the query the current user will subscribe to
        let pushNotificationQuery = PushNotification.query()?.whereKey(ReceiverIdKey, equalTo: currentUserId) as! PFQuery<PushNotification>
        
        App.delegate?.notificationSubcription = App.delegate?.liveQueryClient.subscribe(pushNotificationQuery).handle(Event.created, { (_, notification) in
            print(notification)
        })
    }
    
    class func fetch(readStatus: ReadStatus, completionHandler: @escaping ([PushNotification]?) -> Void){
        guard let currentUserId = User.current()?.objectId else{
            return
        }
        let query = PFQuery(className: ClassName)
        query.includeKey(SenderKey)
        query.whereKey(ReceiverIdKey, equalTo: currentUserId)
        query.order(byDescending: CreatedAtKey)
        
        if readStatus == .read{
            query.whereKey(ReadStatusKey, equalTo: 1)
        }else{
            query.whereKey(ReadStatusKey, equalTo: 0)
        }
        
        query.findObjectsInBackground { (notifications , error) in
            if let notifications = notifications as? [PushNotification]{
                completionHandler(notifications)
            }else{
                completionHandler(nil)
            }
        }
    }
    
    class func updateAllUnreadToRead( completionHandler: @escaping PFBooleanResultBlock){
        PushNotification.fetch(readStatus: .unread) { (pushNotifications) in
            guard let pushNotifications = pushNotifications else{
                return
            }
            
            let updatedNotifications = pushNotifications.map({ (notification) -> PushNotification in
                notification[ReadStatusKey] = 1
                return notification
            })
            PFObject.saveAll(inBackground: updatedNotifications, block: completionHandler)
        }
    }
   
    
}


extension PushNotification: PFSubclassing {
    static func parseClassName() -> String {
        return ClassName
    }
}
