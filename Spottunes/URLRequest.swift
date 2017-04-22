//
//  URLRequest.swift
//  Spottunes
//
//  Created by Xie kesong on 4/20/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import Foundation

extension URLRequest{
    mutating func addTokenValue(token: String){
        self.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    
    mutating func addJsonContentType(){
        self.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}
