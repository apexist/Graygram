//
//  FeedViewController.swift
//  Graygram1
//
//  Created by DJV on 2017. 5. 31..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

import UIKit
import Alamofire

//클래스 이름을 바꾸면, 파일이름도 왼쪽에서 바꾸어 줘야 함
final class FeedViewController: UIViewController {
    
    fileprivate var posts: [Post] = []
    
    //@IBOutlet var tableView : UITableView!
    //그대신아래와 같이 스토리보드 사용하지 않고 정의.. 딴데서 사용못하게 fileprivate으로 정의
    
    fileprivate let collectionView = UICollectionView(
        frame: .zero, // CGRect.zero
        collectionViewLayout: UICollectionViewFlowLayout() // CSS float과 비슷
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cardCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //크기를 직접 잡아주어야함
        //오토레이아웃을 코드로 지정 하는 방법
        
        //frame을 직접 잡아주는 방법 아래
        collectionView.frame = self.view.frame
        
        //화면에 보이게 하기위해
        self.view.addSubview(collectionView)
        
        fetchPosts()
    
    }

    //public : 다른 모듈에서 접근 가능
    //internal (default) : 하나의 모듈안에서 접근가능, 프로젝트 안에서 가능
    //fileprivate : 이 파일 안에서만 사용가능, 파일이 기준, swift는 extension이 사용되므로 안에서 사용가능
    //private : class안에서만 가능함, 익스텐션에서도 접근 못함
    //fileprivate 및 private 은 가능한 선언 해주면 빌드가 빨라짐... 항상 쓰는게 좋음
    //class 앞에 final 붙이면 상속할 수 없음, 컴파일 속도와 실행속도 빨라짐 
    //Static Dispatch : final class 를 찾아서 정의함...
    //Dynamic Dispatch : OjbC는 모두, 런타임에 실행함
    
    fileprivate func fetchPosts() {
        Alamofire.request("https://api.graygram.com/feed")
            .responseJSON { response in
                switch response.result {
                    case .success(let value):
                        guard let json = value as? [String:Any] else {return}
                        guard let jsonArray = json["data"] as? [[String:Any]] else {return}
                        let newPosts = [Post](JSONArray : jsonArray)
                        self.posts = newPosts
                        self.collectionView.reloadData()
                    
                    case .failure(let error):
                        print(error)
                }
        }
    }
}

extension FeedViewController: UICollectionViewDataSource {
    // Section-Row / Section-Item
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cardCell",
            for: indexPath
        )
        cell.backgroundColor = .blue
        return cell
    }
}
    
extension FeedViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
    return CGSize(
    width: collectionView.frame.size.width,
    height: collectionView.frame.size.width
    )
    }
}


