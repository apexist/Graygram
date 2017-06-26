//
//  PostTileCell.swift
//  Graygram1
//
//  Created by DJV on 2017. 6. 26..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

import UIKit

//미션
//1. imageView: UIImage를 셀에 꼭채워봐
//

final class PostTileCell: UICollectionViewCell {
    

    fileprivate let imageView = UIImageView()
    
    //클로저 정의
    var didTap: (() -> Void)?
    
    //fileprivate var post: Post?
    
    //1.생성자
    override init(frame: CGRect) {
        super.init(frame: frame)
        //속성초기화
        //서브뷰추가
        self.contentView.addSubview(self.imageView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(contentViewDidTap))
        self.contentView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //2. 설정 , 데이터만 넣어줌
    // UI 바꾸는건 configure에서만 수행하도록 한다.
    
    func configure(post: Post) {

        self.imageView.setImage(photoID: post.photoID, size: .medium)
        setNeedsLayout() //알아서 layoutsubview호출
        
    }
 
    
    //3.레이아웃
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.width = self.contentView.width
        self.imageView.height = self.contentView.height
    }

    
    //4. 사이즈 반환
    //가로세로 사이즈를 모두 정해야 하므로 CGSize로 반환한다. post가 있어야. 크기를 알수 있다. 몇개 있는지 알아야지...
    class func size(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: width)
    }
    
    func contentViewDidTap() {
        self.didTap?()
    }
}
