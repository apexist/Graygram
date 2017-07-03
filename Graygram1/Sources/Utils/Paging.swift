//
//  Paging.swift
//  Graygram1
//
//  Created by DJV on 2017. 6. 28..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

//enum을 사용해서 paging 구분, refresh / next
enum Paging {
    case refresh
    case next(String)
}
