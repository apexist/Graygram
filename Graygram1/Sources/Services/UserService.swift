//
//  UserService.swift
//  Graygram1
//
//  Created by DJV on 2017. 6. 28..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

import Alamofire
import ObjectMapper

// 사용자와 관련된 모든 서비스를 여기에 묶음

struct UserService: APIServiceType{
    //로그인한 사용자의 프로필 정보 가져오는 메서드 //completion 콜백클로저
    static func me(_ completion: @escaping (DataResponse<User>) -> Void) {
        //let urlString = "http://api.graygram.com/me"
        let urlString = self.url("/me")
        Alamofire.request(urlString)
            .validate(statusCode: 200..<400)
            .responseJSON { response in
                let newResponse = response.flatMapResult { json -> Result<User> in //response는 DataResponse<Any> 임
                    if let user = Mapper<User>().map(JSONObject: json) {
                        return .success(user)
                    } else {
                        return .failure(MappingError())
                    }
                }
                completion(newResponse) //DataResponse<User>
                
                //위와 같이 만들 수 있음
                /*
                switch response.result {
                case .success(let json): //성공하면 유저모델을 생성
                    if let user = Mapper<User>().map(JSONObject: json) { //타입캐스팅 없이 쓸수 있다.
                        //성공 //요청도 성공, 유저 생성도 성공
                        let newResponse = DataResponse<User>(request: response.request, response: response.request, data: response.data, result: .success(user), timeline: response.timeline)
                        completion(newResponse) //콜백클로저로 보냄 //이부분 궁금하다. 이스케이핑도 궁금, 컴플리션되면..콜백클로저를 어케 처리 하는거냐
                    } else {
                        //실패 //유저정보 만드는데 실패
                        let error = MappingError()
                        let newResponse = DataResponse<User>(request: response.request, response: response.request, data: response.data, result: .failure(error), timeline: response.timeline)
                        completion(newResponse) //싶패정보를 보냄
                    }
                case .failure(let error):
                    //실패:요청자체가 실패
                    let newResponse = DataResponse<User>(request: response.request, response: response.request, data: response.data, result: .failure(error), timeline: response.timeline)
                    completion(newResponse) //실패정보를 보냄
                }*/
        }
    }
    
}
