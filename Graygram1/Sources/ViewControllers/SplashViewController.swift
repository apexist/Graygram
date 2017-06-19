//
//  SplashViewController.swift
//  Graygram1
//
//  Created by DJV on 2017. 6. 14..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

import UIKit
import Alamofire

final class SplashViewController: UIViewController {
    
    //로딩중일때 애니메이션
    fileprivate let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        activityIndicatorView.stopAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        let urlString = "https://api.graygram.com/me"
        
        Alamofire.request(urlString)
          .validate(statusCode: 200..<400)
          .responseJSON{ response in
            switch response.result {
            case .success(let value):
                print("내 프로필정보 가져오기 성공 \(value)")
                AppDelegate.instance?.presentMainScreen()
            case .failure(let error):
                print("내 프로필정보 가져오기 실패 \(error)")
                AppDelegate.instance?.presentLoginScreen()
            }
                
          }
    }
}
