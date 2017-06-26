//
//  PostEditViewTextCell.swift
//  Graygram1
//
//  Created by DJV on 2017. 6. 23..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

import UIKit

//Text View를 위한 Cell정의
//생성자, Configure, layout, size
final class PostEditViewTextCell: UITableViewCell {
    
    fileprivate enum Font {
        static let textView = UIFont.systemFont(ofSize: 14)
    }
    
    fileprivate let textView = UITextView()
    
    var textDidChange: ((String?) -> Void)? //클로저 정의 텍스트가 입력/변경되었다는걸 알려주는
    
    //1.init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.textView.font = Font.textView
        self.textView.delegate = self //변경이 된지 알려주기 위한 델리게이트
        self.textView.isScrollEnabled = false
        self.contentView.addSubview(self.textView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //2.설정
    // text는 없을 수도 있으니까 옵셔널
    func configure(text: String?) {
        //textView.text 는 String! 이다.
        self.textView.text = text
        self.setNeedsLayout()
    }
    
    //3.레이아웃
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textView.width = self.contentView.width
        self.textView.height = self.contentView.height
    }
    
    //4.크기
    //얼마나 입력한지 알아야 하기 때문에 text도 필요함
    class func height(width: CGFloat, text: String?) -> CGFloat {
        //text의 높이 아는 방법
        let minimumHeight = CGFloat(100)
        guard let text = text else { return minimumHeight }
        return max(text.size(width: width, font: Font.textView).height, minimumHeight)
    }
    
}

extension PostEditViewTextCell: UITextViewDelegate {
    //텍스트가 변경되었을때 알려주는 메소드 //콜백 클로저를 호출
    func textViewDidChange(_ textView: UITextView) {
        self.textDidChange?(textView.text)
    }
}
