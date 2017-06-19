//
//  DataResponse+ErrorInfo.swift
//  Graygram1
//
//  Created by DJV on 2017. 6. 14..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

import Alamofire

extension DataResponse {
    //튜플 사용 //옵셔널 리턴 //쓰는데서 옵셔널 바인딩 해줘야 함
    func errorInfo() -> (field: String, message: String)? {
        guard let data = self.data,
            let json = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any],
            let errorInfo = json["error"] as? [String: Any],
            let field = errorInfo["field"] as? String,
            let message = errorInfo["message"] as? String
        else { return nil }
        return (field, message)
    }
}
