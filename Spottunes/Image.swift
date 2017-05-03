//
//  Image.swift
//  Spottunes
//
//  Created by Xie kesong on 5/2/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import Foundation

/*
 "height" : 640,
 "url" : "https://mosaic.scdn.co/640/9da7d8563ec74f11492dd53ef2f515f71a234256a66e6447f40f8ac973e41ca936f9084996acad84ec8b5eaaf4850b02711442918d99b6c8f252753cb646b9bbe43be30c539623f31c97dba38e7d4215",
 "width" : 640

 */

fileprivate let HeightKey = "height"
fileprivate let WidthKey = "width"
fileprivate let URLKey = "url"


class Image{
    var dict: [String: Any]!
    var height: Int!{
        return self.dict[HeightKey] as! Int
    }
    
    var width: Int!{
        return self.dict[WidthKey] as! Int
    }
    
    var url: String!{
        return self.dict[URLKey] as! String
    }
    
    init(dict: [String: Any]) {
        self.dict = dict
    }
}
