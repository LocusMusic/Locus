//
//  DateExtension.swift
//  Locus
//
//  Created by Xie kesong on 5/26/17.
//  Copyright © 2017 ___Locus___. All rights reserved.
//

import Foundation



extension Date {
    func getCurrentLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}
