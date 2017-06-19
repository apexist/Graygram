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
    
    //더보기 할 페이지가 있는지. 확인
    fileprivate var nextURLString: String?
    
    //로딩중인지 확인 필요 //로딩이 시작될때 true로 만들어줌
    fileprivate var isLoading: Bool = false
    
    fileprivate let refreshControl = UIRefreshControl()
    
    //@IBOutlet var tableView : UITableView!
    //그대신아래와 같이 스토리보드 사용하지 않고 정의.. 딴데서 사용못하게 fileprivate으로 정의
    
    fileprivate let collectionView = UICollectionView(
        frame: .zero, // CGRect.zero
        collectionViewLayout: UICollectionViewFlowLayout() // CSS float과 비슷
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        //우리가 정의한 PostCardCell로 등록
        collectionView.register(PostCardCell.self, forCellWithReuseIdentifier: "cardCell")
        
        collectionView.register(CollectionActivityIndicatorView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "activitiIndicatorView")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //크기를 직접 잡아주어야함
        //오토레이아웃을 코드로 지정 하는 방법
        
        //frame을 직접 잡아주는 방법 아래
        collectionView.frame = self.view.frame
        
 
        //refresh 처리 self의 아래 func을 호출
        refreshControl.addTarget(self, action: #selector(refreshControlDidChangeValue), for: UIControlEvents.valueChanged)
        
        //화면에 보이게 하기위해
        self.view.addSubview(collectionView)
        collectionView.addSubview(refreshControl)
        
        //snapkit을 써서 오토레이아웃 정의하는 편의 //코드를 사용해서 정의, SnapKit을 사용해서 간단화 시킴 /돌려도 자동으로 가로크기에 맞게 함
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            
            //위 네개는 아래와 같음
            //make.top.left.bottom.right.equalToSuperview()
            //make.edges.equalToSuperview()
        }
        
        fetchPosts()
        
    }

    func refreshControlDidChangeValue() {
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
    
    fileprivate func fetchPosts(isMore: Bool = false) {
        
        //로딩중이면 안하겠다.
        guard !isLoading else { return }
        
        let urlString: String //아래에서 모든 케이스가 커버되었으니까 초기값이 없더라도 컴파일됨
        
        if !isMore {
            urlString = "https://api.graygram.com/feed?limit=3"
        } else if let nextURLString = self.nextURLString {
            urlString = nextURLString
        } else {
            return
        }
        
        //중복요청 막기 위해서
        isLoading = true
        
        Alamofire.request(urlString)
            .responseJSON { response in
                //로딩중 아님
                self.isLoading = false
                //fetchPost를 리프레시 할때 끝나면 컨트롤 끝내는 처리
                self.refreshControl.endRefreshing()
                switch response.result {
                    case .success(let value):
                        guard let json = value as? [String:Any] else {return}
                        guard let jsonArray = json["data"] as? [[String:Any]] else {return}
                            //Array<Post>.init(JSONArray : jsonArray) 같음
                        let newPosts = [Post](JSONArray : jsonArray)
                        
                        if !isMore {
                            self.posts = newPosts
                        } else {
                            self.posts += newPosts
                        }
                        
                        
                        //paging데이터가져옴
                        let paging = json["paging"] as? [String: Any]
                        self.nextURLString = paging?["next"] as? String
                        
                        self.collectionView.reloadData()
                    
                    case .failure(let error):
                        print(error)
                }
        }
    }
}

extension FeedViewController: UICollectionViewDataSource {
    
    //두가지 필수 구현, 몇번째 색션에 몇개의 아이템이 있나, 특정한 indexpath에 어떤 셀을 반환할 것인가
    // Section-Row / Section-Item
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cardCell",
            for: indexPath
        ) as! PostCardCell
        
        let post = self.posts[indexPath.item]
        cell.configure(post: post)
        return cell
    }
    
    //아래 이상함 체크하자
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind: String,
        at indexPath: IndexPath
        ) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionElementKindSectionFooter,
            withReuseIdentifier: "activitiIndicatorView",
            for: indexPath)
        }
    
}
    
    //갯수만큼의 셀을 만들어서 색깔만 칠했음 위에까지...
    
extension FeedViewController : UICollectionViewDelegateFlowLayout {
    
    // 사이즈 정의 , 특정한 indexpath에 해당하는 셀의 사이즈를 정의, 모두 post card cell에 위읨
    
    func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let post = self.posts[indexPath.item]
        return PostCardCell.size(width: collectionView.frame.size.width, post: post)
    //return CGSize(
    //width: collectionView.frame.size.width,
    //height: collectionView.frame.size.width
    //)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        
        //마지막 페이지에서는 더보기 요청이 불가능한 경우 (마지막페이지에 도달)
        if self.nextURLString == nil && !self.posts.isEmpty {
            return .zero
        } else {
            return CGSize(width: collectionView.width, height: 44)
        }
    }
    
    //스크롤 될때 마다 호출되는 함수 //스크롤할때 더보기 보여주게 하기 위해서
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print(scrollView.contentOffset.y + scrollView.height , scrollView.contentSize.height)
        
        guard scrollView.contentSize.height > 0 else { return }
        let contentOffsetBottom = scrollView.contentOffset.y + scrollView.height
        if contentOffsetBottom >= scrollView.contentSize.height - 300 /*적당히 내려갔을때 처리*/ {
            print("Load more")
            fetchPosts(isMore: true)
        }
    }
    
    //아래 체크
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt: Int)
        -> UIEdgeInsets {
            return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }

    //아래 체크
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int)
        -> CGFloat {
            return 20
    }
    
    
}
