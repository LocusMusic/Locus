//
//  Ultility.swift
//  Locus
//
//  Created by Xie kesong on 5/20/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import Foundation




let availableLocationTag: [String: UIImage] = [
    "beach" :  #imageLiteral(resourceName: "beach")
]

struct Ultility{
    static func getSpotCoverFor(tag: String) -> UIImage?{
        return availableLocationTag[tag]
    }
}
