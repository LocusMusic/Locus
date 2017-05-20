//
//  RecentlyVisitedSpot.swift
//  Spottunes
//
//  Created by Xie kesong on 5/19/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import Parse


fileprivate let ClassName = "RecentlyVisitedSpot"
fileprivate let SpotsKey = "spot"
fileprivate let UserKey = "user"

class RecentlyVisitedSpot: PFObject{
    var spots: [TuneSpot]{
        get{
            return self[SpotsKey] as! [TuneSpot]
        }
        set{
            self[SpotsKey] = newValue
        }
    }
    var user: User{
        return self[UserKey] as! User
    }
    
    
    //fetch the recently visisted spots for users
    class func fetchRecentlyVisitedSpot(forUser user: User, completionHandler: @escaping (RecentlyVisitedSpot?) -> Void){
        let query = PFQuery(className: ClassName)
        query.whereKey(UserKey, equalTo: user)
        query.includeKey(UserKey)
        query.includeKey(SpotsKey)
        query.getFirstObjectInBackground { (recentSpots, error) in
            if let recentSpots = recentSpots as? RecentlyVisitedSpot{
                completionHandler(recentSpots)
            }else{
                //create a empty spot
                completionHandler(nil)
            }
        }
    }
    
    //update the recently visisted spot if existed, create new otherwise
    class func saveRecentlyVisitedSpot(user: User, newSpot spot: TuneSpot, completionHandler: @escaping (RecentlyVisitedSpot?) -> Void){
        RecentlyVisitedSpot.fetchRecentlyVisitedSpot(forUser: user) { (recentlyVisitedSpot) in
            if let recentlyVisitedSpot = recentlyVisitedSpot{
                //already existed
                let newSpot = [spot]
                let filteredArray = recentlyVisitedSpot.spots.filter({ (tuneSpot) -> Bool in
                    return !newSpot.contains(tuneSpot)
                })
                let newRecentSpot = newSpot + filteredArray
                recentlyVisitedSpot.spots = newRecentSpot
                recentlyVisitedSpot.saveInBackground(block: { (succeed, error) in
                    if succeed{
                        completionHandler(recentlyVisitedSpot)
                    }else{
                        completionHandler(nil)
                    }
                })
            }else{
                //not yet existed for this given user, create a new one
                let recentlyVisitedSpot = RecentlyVisitedSpot()
                recentlyVisitedSpot[SpotsKey] = [spot]
                recentlyVisitedSpot[UserKey] = user
                recentlyVisitedSpot.saveInBackground(block: { (succeed, error) in
                    if succeed{
                        completionHandler(recentlyVisitedSpot)
                    }else{
                        completionHandler(nil)
                    }
                })
            }
        }
    }
    
    
    
    
}

extension RecentlyVisitedSpot: PFSubclassing {
    static func parseClassName() -> String {
        return ClassName
    }
}
