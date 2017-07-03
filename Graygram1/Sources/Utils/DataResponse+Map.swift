//
//  DataResponse+FlatMap.swift
//  Graygram1
//
//  Created by DJV on 2017. 6. 28..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

import Alamofire

extension DataResponse {
    //flatMap -> DataResponse
    //DataResponse<Any> -map-> DataResponse<User>
    
    //성공을 실패로 바꿀수 없음, 성공했을때 또다른 성공을 만듬, 항상 성공하는 케이스
    func mapResult<T>(_ transform: (Value) -> T) -> DataResponse<T> {
       return self.flatMapResult{ value in
            return .success(transform(value))
        }
    }
    
    //T : Generic ?? 뭐지? 알아보자
    //DataResponse가 가지고 있는 result를 바꾸는 map
    func flatMapResult<T>(_ transform: (Value) -> Result<T>) -> DataResponse<T> {
        switch self.result {
        case .success(let value):
            return DataResponse<T>(request: self.request, response: self.response, data: self.data, result: transform(value), timeline: self.timeline) //transform 위에 정의
        case .failure(let error):
            return DataResponse<T>(request: self.request, response: self.response, data: self.data, result: .failure(error), timeline: self.timeline)
        }
    }
}
