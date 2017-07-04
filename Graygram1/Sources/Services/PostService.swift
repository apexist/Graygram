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
    
    //단일 포스트 정보 얻어오기
    static func post(id: Int, completion: @escaping (DataResponse<Post>) -> Void) {
        let urlString = self.url("/posts/\(id)")
        Alamofire.request(urlString)
            .validate(statusCode: 200..<400)
            .responseJSON { response in
                let newResponse = response.flatMapResult{ json -> Result<Post> in
                    if let post = Mapper<Post>().map(JSONObject: json) {
                        return .success(post)
                    } else {
                        return .failure(MappingError())
                    }
                }
                completion(newResponse)
            }
    }
    
    
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
    
    static func create(
        image: UIImage,
        message: String?,
        progress: @escaping (Progress) -> Void, //상태를 반환
        completion: @escaping (DataResponse<Post>) -> Void //completion으로 생성된 포스트를 반환
    ) {
        
        let urlString = self.url("/posts")
        
        //여기 아래 잘 모르겠다. ㅠ.ㅠ
        Alamofire.upload(
            multipartFormData: { formData in
                if let imageData = UIImageJPEGRepresentation(image, 1) {
                    //formData에 직렬화된 이미지를 추가
                    formData.append(imageData, withName: "photo", fileName: "photo.jpg", mimeType: "image/jpeg")
                }
                if let textData = message?.data(using: .utf8) {
                    formData.append(textData, withName: "message")
                }
        },
            to: urlString,
            method: .post,
            encodingCompletion: { encodingResult in //request만들때 실패할수 있음, 인코딩이 성공했는지 실패했는지, 나누어 처리
                switch encodingResult {
                case .success(let request, _, _):
                    print("인코딩 성공 : \(request)")
                    request
                        //프로그래스 진행상태를 위한것
                        .uploadProgress(closure: progress)
                        .validate(statusCode: 200..<400)
                        .responseJSON { response in
                            let newResponse = response.flatMapResult { json -> Result<Post> in
                                if let post = Mapper<Post>().map(JSONObject: json) {
                                    return .success(post)
                                } else {
                                    return .failure(MappingError())
                                }
                            }
                            if let post = newResponse.result.value {
                                NotificationCenter.default.post(
                                    name: .postDidCreate,
                                    object: self,
                                    userInfo: ["post": post]
                                )
                            }
                            completion(newResponse)
                    }
                case .failure(let error):
                    print("인코딩 실패 : \(error)")
                    let response = DataResponse<Post>(request: nil, response: nil, data: nil, result: .failure(error))
                    completion(response)
                    /*
                    //다시 업로드 가능하게
                    self.setControlsEnabled(true)
                    //프로그래스바가 안보이게
                    self.progressView.isHidden = true
                    */
            }
        }
        )
    }
}
