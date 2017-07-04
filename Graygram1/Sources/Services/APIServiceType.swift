//
//  APIServiceType.swift
//  Graygram1
//
//  Created by DJV on 2017. 6. 28..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

protocol APIServiceType {
}

extension APIServiceType {
    /// path를 가지고 url을 만들어서 반환합니다.
    ///
    /// - parameter path: API path (e.g. /me)
    static func url(_ path: String) -> String {
        return "https://api.graygram.com" + path
    }
}
