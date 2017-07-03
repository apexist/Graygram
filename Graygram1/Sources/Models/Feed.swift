//
//  Feed.swift
//  Graygram1
//
//  Created by DJV on 2017. 6. 28..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

import ObjectMapper

struct Feed: Mappable {
    var posts: [Post]?
    var nextURLString: String?
    //아무것도 하지않고 정의만 해줘도 됨
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        self.posts <- map["data"]
        self.nextURLString <- map["paging.next"]
    }
}
