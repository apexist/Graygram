//
//  CollectionActivityIndicatorView.swift
//  Graygram1
//
//  Created by DJV on 2017. 6. 12..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

import UIKit


//더보기가 진행되는지 여부 보여주기 위함

final class CollectionActivityIndicatorView: UICollectionReusableView {
    fileprivate let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        activityIndicatorView.startAnimating()
        self.addSubview(activityIndicatorView)
    }
    
    //아래 컴파일러가 자동완성
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.centerX = self.width / 2
        activityIndicatorView.centerY = self.height / 2
    }
}
