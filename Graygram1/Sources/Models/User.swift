//
//  User.swift
//  Graygram1
//
//  Created by DJV on 2017. 6. 7..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

import ObjectMapper

struct User: Mappable {
    var id: Int!
    var username: String!
    var photoID: String?
    
    init?(map: Map){
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        username <- map["username"]
        photoID <- map["photo.id"]
    }
}
