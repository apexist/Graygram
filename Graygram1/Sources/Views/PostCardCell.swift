//
//  PostCardCell.swift
//  Graygram1
//
//  Created by DJV on 2017. 5. 31..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

import UIKit

//더이상 상속하기 싫음
final class PostCardCell: UICollectionViewCell {
    
    //cell을상속받으면 꼭 아래 함
    //1. 생성자
    override init(frame: CGRect) {
        super.init(frame:frame)
        // addSubView 하는 곳
    }
    
    // 자동완성됨 실행안됨 ... 무시해도됨
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //2. 설정
    
    func configure(post: Post) {
        self.backgroundColor = .blue
    }
    
    //3. 크기
    //밖에서 크기를 알수 있게 반환해주는것
    //class method 임.... 찾아보자
    class func size(width: CGFloat, post: Post) -> CGSize {
        //ABCDEFGHIJKLMOP
        
        return CGSize(width: width, height: width)
    }
}

