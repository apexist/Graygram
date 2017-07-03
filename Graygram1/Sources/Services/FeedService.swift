
//
//  FeedService.swift
//  Graygram1
//
//  Created by DJV on 2017. 6. 28..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

import Alamofire
import ObjectMapper


//여러개의 포스트가 있고 페이징도 있음, 한가지 함수에서 처리 하도록 한다.
struct FeedService: APIServiceType {
    static func feed(
        paging: Paging,
        //isMore: Bool, //더볼건지
        //nextURLString: String?,
        completion: @escaping (DataResponse<Feed>) -> Void //Feed 모델을 새로 정의해서 씀
    ) {
        let urlString: String
        
        /*
        if !isMore { //refresh요청인경우
            urlString = self.url("/feed")
        } else if let nextURLString = nextURLString {
            urlString = nextURLString
        } else {
            return
        }
        */
        
        switch paging {
        case .refresh:
            urlString = self.url("/feed")
        case .next(let nextURLString):
            urlString = nextURLString
        }
        
        Alamofire.request(urlString)
            .validate(statusCode: 200..<400)
            .responseJSON { response in
                let newResponse = response.flatMapResult { json -> Result<Feed> in
                    if let feed = Mapper<Feed>().map(JSONObject: json) {
                        return .success(feed)
                    } else {
                        return .failure(MappingError())
                    }
                }
                completion(newResponse)
            }
    }
}
