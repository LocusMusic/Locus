//
//  Helper.swift
//  Locus
//
//  Created by Xie kesong on 5/3/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import Foundation

func formatTimeInterval(timeInterval: TimeInterval) -> String{
    let duration = Int(timeInterval)
    let seconds = String(format: "%02d", (duration % 60))
    let minutes = String(format: "%02d", (duration / 60))
    return minutes + ":" + seconds
}

