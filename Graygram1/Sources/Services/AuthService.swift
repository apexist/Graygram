//
//  AuthService.swift
//  Graygram1
//
//  Created by DJV on 2017. 6. 28..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

import Alamofire

struct AuthService: APIServiceType {
    static func login(username: String, password: String, completion : @escaping (DataResponse<Void>) -> Void) {
        //let urlString = "https://api.graygram.com/login/username"
            //APIServiceType 프로토콜을 받아서 정의함
            let urlString = self.url("/login/username")
            let parameters: Parameters = [
                "username": username,
                "password": password,
                ]
            let headers: HTTPHeaders = [
                "Accept": "application/json",
                ]

        Alamofire.request(urlString, method: .post, parameters: parameters, headers: headers)
            .validate(statusCode: 200..<400)
            .responseJSON { response in
                let newResponse = response.mapResult { value -> Void in
                    return Void()
                }
                completion(newResponse)
            }
    }
}
