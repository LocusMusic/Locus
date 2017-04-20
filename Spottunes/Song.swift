//
//  Song.swift
//  Spottunes
//
//  Created by Xie kesong on 4/16/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import Foundation

import Foundation
import Parse


let SongRecordName = "song"
fileprivate let NameKey = "name"
fileprivate let HitsKey = "hits"


class Song{
 
    var name: String?
    
    var author: String?
    
    unowned var playList: PlayList
    
    var hits: Int!
    
    var object: PFObject!
    
//    init(object: PFObject) {
//        self.object = object
//    }
    
    init(name: String, author: String, playList: PlayList, hits: Int){
        self.name = name
        self.author = author
        self.playList = playList
        self.hits = hits
    }
    
    
}
