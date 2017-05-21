//
//  Spot.swift
//  Locus
//
//  Created by Xie kesong on 4/25/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import Foundation

class Spot{
    var thumbnailURL: String?
    var name: String?
    
    init(name: String, thubmnailURL: String) {
        self.name = name
        self.thumbnailURL = thubmnailURL
    }
}
