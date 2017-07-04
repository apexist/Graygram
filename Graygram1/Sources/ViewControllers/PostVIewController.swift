//
//  PostVIewController.swift
//  Graygram1
//
//  Created by DJV on 2017. 6. 26..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

import UIKit

final class PostViewController: UIViewController {
    fileprivate let postID: Int
    fileprivate var post: Post?
    
    //미션:
    //  Post가 collectionView에 보이도록 해보세요
    
    fileprivate let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    init(postID: Int) {
        self.postID = postID
        //스토리보드를 안쓰므로 아래와 같이 init
        //아래 이후부터 self 사용가능
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        
        collectionView.register(PostCardCell.self, forCellWithReuseIdentifier: "postCell")
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
     
        collectionView.frame = self.view.frame
        
        //화면에 보이게 하기위해
        self.view.addSubview(collectionView)
        
        //snapkit을 써서 오토레이아웃 정의하는 편의 //코드를 사용해서 정의, SnapKit을 사용해서 간단화 시킴 /돌려도 자동으로 가로크기에 맞게 함
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.fetchPost()
        
   }
    
    func fetchPost() {
        PostServcie.post(id: self.postID) { response in
            switch response.result {
            case .success(let post):
                self.post = post
                self.collectionView.reloadData()
            case .failure(let error):
                print("post로드 실패\(error)")
            }
        }
    }
}

extension PostViewController: UICollectionViewDataSource {
    
    //필수메소드 몇개의 아이템
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.post == nil {
            return 0
        } else {
            return 1
        }
    }
    
    //어떤셀을 사용할것인가
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "postCell",
            for: indexPath
            ) as! PostCardCell
        
        if let post = self.post{
            cell.configure(post: post, isMessageTrimmed: false)
        }
            return cell
    }
}

//크기, 여백, 간격 등을 정의
extension PostViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let post = self.post else { return .zero }
        return PostCardCell.size(width: collectionView.width, post: post, isMessageTrimmed: false)
    }
    
}
