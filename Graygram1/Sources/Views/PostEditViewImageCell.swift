//
//  PostEditViewImageCell.swift
//  Graygram1
//
//  Created by DJV on 2017. 6. 23..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

import UIKit

//미션:
//1. photoView: UIImageView
//2. configure(image: UIImage)
//3. photoView 가 Cell에 꽉 차야 한다.
//4. 셀의 크기 class func height(width: CGFloat) -> CGFloat //정사각형 크기 변환, 테이블뷰는 좌우 꽉차서 상하 높이만 정하면 된다.

final class PostEditViewImageCell: UITableViewCell {
    
    fileprivate let photoView = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(photoView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: UIImage) {
        //
        self.photoView.image = image
        self.setNeedsLayout()
    }
    
    //이 셀이 얼마나 하는 높이로 그릴지 정함, 정사각형으로 하려면 너비 정보가 필요함 테이블뷰의 너비
    class func height(width: CGFloat) -> CGFloat {
        return width //너비랑 같은 높이 반환, 정사각형
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.photoView.width = self.contentView.width
        self.photoView.height = self.contentView.height
    }
}
