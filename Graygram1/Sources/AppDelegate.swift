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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //여기에 처음 시작 점을 만듬, 초기 스토리보드를 만듬
        let window = UIWindow(frame: UIScreen.main.bounds) //위치는 0,0 사이즈는 아이폰 전체 크기로 나옴
        window.backgroundColor = .white //배경색  바꿈
        window.makeKeyAndVisible() //키윈도우로 만들고 보이게 함
        
        let viewController = FeedViewController()
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

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

