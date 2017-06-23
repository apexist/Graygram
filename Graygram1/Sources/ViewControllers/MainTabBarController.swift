//
//  MainTabBarController.swift
//  Graygram1
//
//  Created by DJV on 2017. 6. 19..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

import UIKit

final class MainTabBarController: UITabBarController {

    let feedViewController = FeedViewController()
    let settingsViewController = UIViewController()
    //업로드 버튼역할을 할 가짜 뷰 컨트롤러, 실제로 선택되지는 않음
    fileprivate let fakeUploadViewController = UIViewController()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.delegate = self
        
        self.settingsViewController.title = "Settings"
        self.settingsViewController.tabBarItem.image = UIImage(named: "tab-settings")
        self.settingsViewController.tabBarItem.selectedImage = UIImage(named: "tab-settings-selected")
        
        self.fakeUploadViewController.tabBarItem.image = UIImage(named: "tab-upload")
        self.fakeUploadViewController.tabBarItem.imageInsets.top = 5
        self.fakeUploadViewController.tabBarItem.imageInsets.bottom = -5
        
        self.viewControllers = [
            UINavigationController(rootViewController: self.feedViewController),
            UINavigationController(rootViewController: self.settingsViewController),
            self.fakeUploadViewController,
        ]
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func presentImagePickerController() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        self.present(pickerController, animated: true, completion: nil)
        //그냥 하면 크래시 남, 사진에 접근 할수 있도로 plist 설정 / Target의 info에 추가 "Privacy - Photo Library Usage Description"
    }
    
    //크롭뷰를 올림
    fileprivate func presentCropViewController(image: UIImage) {
        let cropViewController = CropViewController(image: image)
        //navigationcontroller로 한번 감쌈
        
        cropViewController.didFinishCropping = { image in
            print(image)
            let grayscaledImage = image.grayscaled()
            print(grayscaledImage)
        }
        
        let navigationController = UINavigationController(rootViewController: cropViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
}

// will~ // did~
// should~ : 이런 메서드는 Bool을 반환한다.

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController === self.fakeUploadViewController { //같은 메모리에 위치하는 객체인지 검사하는 연산자
            
            self.presentImagePickerController()
            
            print("업로드버튼 선택!")
            return false
        } else {
            return true
        }
    }
}

//앨범에서 원하는 이미지 선택
extension MainTabBarController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("이미지 선택: \(info)")
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        

        picker.dismiss(animated: true, completion: nil)
        
        print(image) //breakpoit 넣고 미리 볼수 있다 quick look할수 있다.
        
        self.presentCropViewController(image: image)
    }
}

extension MainTabBarController: UINavigationControllerDelegate {
    
}
