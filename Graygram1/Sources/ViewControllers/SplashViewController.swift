//
//  SplashViewController.swift
//  Graygram1
//
//  Created by DJV on 2017. 6. 14..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

import UIKit

final class SplashViewController: UIViewController {
    
    //로딩중일때 애니메이션
    fileprivate let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        activityIndicatorView.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //UserService로 분리해서 Alamofire 제거.. 공통으로 보냄
        UserService.me { response in //completion으로 response가 넘어옴 //콜백클로저
            switch response.result {
            case .success(let value):
                print("내프로필정보 받아오기 성공\(value)")
                AppDelegate.instance?.presentMainScreen()
                
            case .failure(let error):
                print("내프로필정보 받아오기 실패\(error)")
                AppDelegate.instance?.presentLoginScreen()
            }
        }
        
    }
}
