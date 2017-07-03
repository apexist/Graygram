//
//  AppDelegate.swift
//  Graygram1
//
//  Created by DJV on 2017. 5. 31..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

import UIKit
import Alamofire //import 하기 전에 반드시 빌드 부터 해야 한다.
import SnapKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //
    class var instance: AppDelegate? {
      return UIApplication.shared.delegate as? AppDelegate
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //여기에 처음 시작 점을 만듬, 초기 스토리보드를 만듬
        let window = UIWindow(frame: UIScreen.main.bounds) //위치는 0,0 사이즈는 아이폰 전체 크기로 나옴
        window.backgroundColor = .white //배경색  바꿈
        window.makeKeyAndVisible() //키윈도우로 만들고 보이게 함
        
        //let viewController = FeedViewController()
        let viewController = SplashViewController() //임시코드
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        //URLSession
        //Alamofire : Matt Thomson 이 만듬  
        //1. 소스코드 직접 다운로드 : 하지말라
        //2. CocoaPods를 사용한다 : 해라, 의존성 관리 매니저, 외부라이브러리들을 쉽게 추가 할 수 있음
        //3. Carthage를 사용 : 비추
        
        self.window = window //위에서 옵셔널이니까 나중에 계쏙 쓸때 오셔널 바인딩 안하기 위해서 정의해서 넣어준다.
        return true
    }
    
    //화면을 바꾸는 메소드, 로그인 성공 후 호출됨
    func presentMainScreen() {
        //let viewController = FeedViewController()
        //let navigationController = UINavigationController(rootViewController: viewController)
        
        //Tab Bar 추가 //여기 이상 함....
        let tabBarController = MainTabBarController()
        self.window?.rootViewController = tabBarController
    }

    //로그인 세션이 죽었을때 로그인 뷰로 보냄
    func presentLoginScreen() {
        let viewController = LoginViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        self.window?.rootViewController = navigationController
    }

}

