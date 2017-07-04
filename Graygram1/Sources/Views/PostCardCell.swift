//
//  PostCardCell.swift
//  Graygram1
//
//  Created by DJV on 2017. 5. 31..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

import UIKit
import ManualLayout
import Kingfisher



//더이상 상속하기 싫음
final class PostCardCell: UICollectionViewCell {

    fileprivate enum Metric {
        static let avatarViewTop: CGFloat = 0 //이값이 이상한가?
        static let avatarViewLeft: CGFloat = 10
        static let avatarViewSize: CGFloat = 30
        
        //avatarView의 오른쪽 간격
        static let usernameLabelLeft: CGFloat = 10
        static let usernameLabelRight: CGFloat = 10

        static let pictureViewTop: CGFloat = 10
        
        static let likeButtonTop: CGFloat = 10
        static let likeButtonLeft: CGFloat = 10
        static let likeButtonSize: CGFloat = 20
        
        static let likeCountLabelLeft: CGFloat = 10
        static let likeCountLabelRight: CGFloat = 10
        
        static let messageLabelTop: CGFloat = 10
        static let messageLabelLeft: CGFloat = 10
        static let messageLabelRight: CGFloat = 10
        
    }

    fileprivate enum Font{
        static let usernameLabel = UIFont.boldSystemFont(ofSize: 13)
        static let likeCountLabel = UIFont.boldSystemFont(ofSize: 13)
        static let messageLabel = UIFont.systemFont(ofSize: 14)
    }
    
    //이미지뷰하나 생성 : 프로필사진
    fileprivate let avatarView = UIImageView()
    //사용자 이름라벨
    fileprivate let usernameLabel = UILabel()
    //사용자가 업로드한 사진
    fileprivate let pictureView = UIImageView()
    //라이크버튼
    fileprivate let likeButton = UIButton()
    fileprivate let likeCountLabel = UILabel()
    //사용자가 남긴 text
    fileprivate let messageLabel = UILabel()
    
    fileprivate var post: Post?
    fileprivate var isMessageTrimmed : Bool?
    
    //cell을상속받으면 꼭 아래 함
    
    //1. 생성자
    override init(frame: CGRect) {
        super.init(frame:frame)
        // 1) 속성 초기화
        
        avatarView.backgroundColor = .gray
        avatarView.contentMode = .scaleAspectFill //이미지를 네모난 칸에 어떻게 넣을 것인가? 하는 속성
        avatarView.clipsToBounds = true // 뷰바깥으로 나가는 이미지를 그리지 않음
        //usernameLabel.font = UIFont.boldSystemFont(ofSize: 12)  //폰트사이즈 //bold -> 포토샵에서 medium으로 보임 //기본값을 검은색 //여기도 바꿔!!!
        avatarView.layer.cornerRadius = Metric.avatarViewSize / 2
        

        usernameLabel.font = Font.usernameLabel
        //usernameLabel.textColor = UIColor.black
        usernameLabel.textColor = .black
        
        pictureView.backgroundColor = .gray
        
        
        //let abc = UIImage(named: "icon-like") //또는 아래와 같이
        //let def = #imageLiteral(resourceName: "icon-like")//xcode8 부터 가능, Image Literal //옵셔널이 아님..
        
        
        
        //setImage : 자기 크기대로
        //setBackgroundImage : 버튼의 크기에 따라서 늘어남
        likeButton.setBackgroundImage(#imageLiteral(resourceName: "icon-like"), for: .normal)
        likeButton.setBackgroundImage(#imageLiteral(resourceName: "icon-like-selected"), for: .selected)
        
        likeCountLabel.font = UIFont.boldSystemFont(ofSize: 12) //여기도 바꿔!!!
        messageLabel.font = UIFont.systemFont(ofSize: 14) //포토샵에서 regular
        //최대 3줄까지 나올수 있도록 라인수 설정
        messageLabel.numberOfLines = 3
        
        
        // 2. addSubView 하는 곳
        self.contentView.addSubview(avatarView)
        self.contentView.addSubview(usernameLabel)
        self.contentView.addSubview(pictureView)
        self.contentView.addSubview(likeButton)
        self.contentView.addSubview(likeCountLabel)
        self.contentView.addSubview(messageLabel)
        
        likeButton.addTarget(self, action: #selector(likeButtonDidTap), for: .touchUpInside)
        
    }
    
    // 자동완성됨 실행안됨 ... 무시해도됨
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //2. 설정 , 데이터만 넣어줌 
    // UI 바꾸는건 configure에서만 수행하도록 한다.
    
    func configure(post: Post, isMessageTrimmed: Bool) {
        //self.backgroundColor = .lightGray //나중에 제거할 것임....영역확인 위함
        
        //post.user.photoID 는 옵셔널이다.이미지가 옵셔널일때 어떻게 하면 편할까
        //setImage에 photoID를 옵셔널로 정의 하고 guard let으로 처리
        
        self.post = post
        self.isMessageTrimmed = isMessageTrimmed
        
        avatarView.setImage(photoID: post.user.photoID, size: .tiny)
        usernameLabel.text = post.user.username
        
        pictureView.setImage(photoID: post.photoID, size: .large)
        
        likeButton.isSelected = post.isLiked
        
        likeCountLabel.text = "\(post.likeCount ?? 0)명이 좋아합니다" //optional(0)명이 좋아합니다. 없애기 위해서 ?? 0 추가
        messageLabel.text = post.message
        messageLabel.numberOfLines = isMessageTrimmed ? 3 : 0 // true 라면 3 false 라면 0 // 3원 연산자
        
        setNeedsLayout() //알아서 layoutsubview호출
        
    }
    
    //3. 크기
    //밖에서 크기를 알수 있게 반환해주는것
    //class method 임.... 찾아보자
    
    
    /* 아래 문제 있네... 다시 볼것...
    class func size(width: CGFloat, post: Post) -> CGSize {
        //ABCDEFGHIJKLMOP
        
        var height: CGFloat = 0
        
        //위에서 부터 아래로 더함
        height += Metric.avatarViewTop
        height += Metric.avatarViewSize
        
        height += Metric.pictureViewTop
        height += width // picture의 높이
        
        height += Metric.likeButtonTop
        height += Metric.likeButtonSize

        if let message = post.message, !message.isEmpty { //값이 있고 빈문자열이 아닌경우
            
            let messageLabelWidth = width - Metric.messageLabelLeft - Metric.messageLabelRight
            
            height += Metric.messageLabelTop
        
            //height += ceil(UIFont.systemFont(ofSize: 14).lineHeight) //한줄인 경우
            //height += message의 높이(?) 계산 , 메시지는 멀티라인 스트링임 , 문자열 길이에 따라 다름
        
            height += message.size(width: messageLabelWidth, font: Font.messageLabel, numberOfLines: 3).height //이렇게 쓸수 있는 코드를 작성
        }
        
        return CGSize(width: width, height: width)
    }
    */
    
    //가로세로 사이즈를 모두 정해야 하므로 CGSize로 반환한다. post가 있어야. 크기를 알수 있다. 몇개 있는지 알아야지...
    class func size(width: CGFloat, post: Post, isMessageTrimmed: Bool) -> CGSize {
        var height: CGFloat = 0
        
        height += Metric.avatarViewTop
        height += Metric.avatarViewSize
        
        height += Metric.pictureViewTop
        height += width // picture의 높이
        
        height += Metric.likeButtonTop
        height += Metric.likeButtonSize
        
        if let message = post.message, !message.isEmpty {
            let messageLabelWidth = width - Metric.messageLabelLeft - Metric.messageLabelRight
            height += Metric.messageLabelTop
            height += message.size(
                width: messageLabelWidth,
                font: Font.messageLabel,
                numberOfLines: isMessageTrimmed ? 3 : 0
                ).height
        }
        
        return CGSize(width: width, height: height)
    }
    
    //4. 레이아웃
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // avatar view
        avatarView.x = Metric.avatarViewLeft
        avatarView.y = Metric.avatarViewTop
        avatarView.width = Metric.avatarViewSize
        avatarView.height = Metric.avatarViewSize
        
        // username label
        usernameLabel.left = avatarView.right + Metric.usernameLabelLeft
        usernameLabel.sizeToFit()
        usernameLabel.width = min(
            usernameLabel.width,
            contentView.width - Metric.usernameLabelRight - usernameLabel.left
        )
        usernameLabel.centerY = avatarView.centerY
        
        // picture view
        pictureView.width = contentView.width
        pictureView.height = pictureView.width
        pictureView.top = avatarView.bottom + Metric.pictureViewTop
        
        // like button
        likeButton.width = Metric.likeButtonSize
        likeButton.height = Metric.likeButtonSize
        likeButton.left = Metric.likeButtonLeft
        likeButton.top = pictureView.bottom + Metric.likeButtonTop
        
        // like count label
        likeCountLabel.left = likeButton.right + Metric.likeCountLabelLeft
        likeCountLabel.sizeToFit()
        likeCountLabel.width = min(
            likeCountLabel.width,
            contentView.width - Metric.likeCountLabelRight - likeCountLabel.left
        )
        likeCountLabel.centerY = likeButton.centerY
        
        // message label
        messageLabel.top = likeButton.bottom + Metric.messageLabelTop
        messageLabel.left = Metric.messageLabelLeft
        messageLabel.width = contentView.width - Metric.messageLabelRight - messageLabel.left
        messageLabel.sizeToFit()
        
        // 한줄:  sizeToFit -> width 설정
        // 여러줄: width 설정 -> sizeToFit
    }
    
    func likeButtonDidTap() {

        //guard let postID = self.post?.id else { return }
        guard let post = self.post else { return }
        guard let isMessageTrimmed = self.isMessageTrimmed else { return }
        
        let urlString = "https://api.graygram.com/posts/\(post.id!)/likes"
        
        //UI를 그리는데 필요한 데이터를 바꾸고 자동갱신되도록
    
        //like버튼 분기 처리
        if !likeButton.isSelected {
            
            //좋아요 버튼을 먼저 바꿔 놓고 요청
            var newPost = post //newPost는 값은 같지만 다른 위치에 존재하는 변수가 됨
            newPost.isLiked = true
            newPost.likeCount! += 1
            self.configure(post: newPost, isMessageTrimmed: isMessageTrimmed)
            
            //notification발송 
            //스크롤내렸다 올라왔더니, 좋아요 이전의 데이터로 되어 있음 postcardcell이 가지고 있던  데이터는 없데이트 되었으나 feedviewcontroller가 가지고 
            //있던 데이터는 바뀌지 않음, 따라서 feedviewcontroller가 알수 있도록 notification해줌
            //global하게 메시지 전달
            //Notification의 싱글톤 인스턴스를 생성하고 보냄 , Post.swift에 .postDidLike정의
            
            PostServcie.like(postID: post.id)
            /*
            NotificationCenter.default.post(name: .postDidLike, object: self, userInfo: ["postID": post.id!])
            
            Alamofire.request(urlString, method: .post)
                .validate(statusCode: 200..<400)
                .responseData { response in
                    switch response.result {
                    case .success:
                        print("좋아요 성공\(post.id!)")
                        //빠른 피드백을 위해 요청이 성공했다 치고 UI부터 바꾸는거로 위로 옮김
                        //var newPost = post //newPost는 값은 같지만 다른 위치에 존재하는 변수가 됨
                        //newPost.isLiked = true
                        //newPost.likeCount! += 1
                        //self.configure(post: newPost) //복제본을 가지고 configure다시 실행
                        //self.likeButton.isSelected = true
                    case .failure:
                        //중복요청 conflict 처리
                        if response.response?.statusCode != 409 {
                            print("좋아요 실패\(post.id!)")
                            //self.likeButton.isSelected =  false
                            self.configure(post: post)
                            //notification발송
                            NotificationCenter.default.post(name: .postDidUnLike, object: self, userInfo: ["postID": post.id!])
                        }
                    }
                }*/
        } else {
            //취소를 먼저 UI 처리 하고 요청
            var newPost = post //newPost는 값은 같지만 다른 위치에 존재하는 변수가 됨
            newPost.isLiked = false
            newPost.likeCount! -= 1
            self.configure(post: newPost, isMessageTrimmed: isMessageTrimmed) //복제본을 가지고 configure다시 실행
            
            PostServcie.Unlike(postID: post.id)
            
            /*
            //notification발송
            NotificationCenter.default.post(name: .postDidUnLike, object: self, userInfo: ["postID": post.id!])
            
            Alamofire.request(urlString, method: .delete)
                .validate(statusCode: 200..<400)
                .responseData { response in
                    switch response.result {
                    case .success:
                        print("좋아요 취소 성공\(post.id!)")
                        //self.likeButton.isSelected = false
                    case .failure:
                         if response.response?.statusCode != 409 {
                            print("좋아요 취소 실패\(post.id!)")
                            //self.likeButton.isSelected = true
                            self.configure(post: post)
                            //notification발송
                            NotificationCenter.default.post(name: .postDidLike, object: self, userInfo: ["postID": post.id!])
                         }
                    }
                }*/
        }
    }
}


