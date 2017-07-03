//
//  PostService.swift
//  Graygram1
//
//  Created by DJV on 2017. 6. 28..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

import Alamofire
import ObjectMapper

struct PostServcie: APIServiceType {
    // 미션:
    // 1. like()
    // 2. unLike()
    
    static func like(postID: Int, completion: ((DataResponse<Void>) -> Void)? = nil) {
        
        NotificationCenter.default.post(name: .postDidLike, object: self, userInfo: ["postID": postID])
        
        let urlString = self.url("/posts/\(postID)/likes")
        Alamofire.request(urlString, method: .post)
            .responseJSON { response in
                if case .failure = response.result, response.response?.statusCode != 409 {
                    NotificationCenter.default.post(name: .postDidUnLike, object: self, userInfo: ["postID": postID])
                }
                let newResponse = response.mapResult { _ in }
                completion?(newResponse)
            }
    }

    static func Unlike(postID: Int, completion: ((DataResponse<Void>) -> Void)? = nil) {
        
        NotificationCenter.default.post(name: .postDidUnLike, object: self, userInfo: ["postID": postID])
        
        let urlString = self.url("/posts/\(postID)/likes")
        Alamofire.request(urlString, method: .delete)
            .responseJSON { response in
                if case .failure = response.result, response.response?.statusCode != 409 {
                    NotificationCenter.default.post(name: .postDidLike, object: self, userInfo: ["postID": postID])
                }
                let newResponse = response.mapResult { _ in }
                completion?(newResponse)
        }
    }
}
