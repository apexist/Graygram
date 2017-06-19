//
//  LoginViewController.swift
//  Graygram1
//
//  Created by DJV on 2017. 6. 14..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

import UIKit
import Alamofire // 이건 쓸려면 import 따로 해줘야 한다.


//로그인을 처리할 viewcontroller
final class LoginViewController: UIViewController {
    // 1. 속성정의
    // usernameTextField
    // passwordTextField
    // loginButton
    // 2. viewDidLoad에서 addSubView
    // 3. SnapKit을 사용해서 만들기
    
    fileprivate let usernameTextField = UITextField()
    fileprivate let passwordTextField = UITextField()
    fileprivate let loginButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(usernameTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(loginButton)
        
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.placeholder = "Username"
        //자동완성과 자동대소문자 변환 끄기
        usernameTextField.autocorrectionType = .no
        usernameTextField.autocapitalizationType = .none
        //잘못 입력해서 빨갛게 된걸 다시 입력 시작하면 돌려주기 위함
        usernameTextField.addTarget(self, action: #selector(textFieldDidChangeText), for: .editingChanged)
        
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.addTarget(self, action: #selector(textFieldDidChangeText), for: .editingChanged)
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        loginButton.backgroundColor = loginButton.tintColor //iOS에는 모든 뷰가 자기자신의 tint color 가 있음
        loginButton.layer.cornerRadius = 5
        
        //액션을 잡음
        loginButton.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
        
        //네비게이션 바에 가려지므로 내려줘야 한다.
        
        usernameTextField.snp.makeConstraints { make in
            //make.top.equalTo(30)
            //네비게이션 바에 가려지므로 내려줘야 한다.
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(30)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(30)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(10)
            //make.left.equalTo(usernameTextField.snp.left)
            //make.right.equalTo(usernameTextField.snp.right)
            //make.height.equalTo(usernameTextField.snp.height)
            make.left.equalTo(usernameTextField)
            make.right.equalTo(usernameTextField)
            make.height.equalTo(usernameTextField)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.left.right.height.equalTo(passwordTextField)
        }
    
    }
    
    //버튼이 클릭 되었을때
    func loginButtonDidTap() {
        //login()을 호출
        //""도 값이 있음 따라서 조건 추가
        guard let username = usernameTextField.text, !username.isEmpty else { return } //또는 흔들어 줄수 있음..해보자
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        login(username: username, password: password)
    }
    
    func login(username: String, password: String) {
        let urlString = "https://api.graygram.com/login/username"
        let parameters: Parameters = [
            "username": username,
            "password": password,
        ]
        //let headers: [String: String] = [
        let headers: HTTPHeaders = [
            "Accept": "application/json",
        ]
        
        Alamofire
            .request(urlString, method: .post, parameters: parameters, headers: headers)
            .validate(statusCode: 200..<400) //http 응답코드의 성공으로 볼 코드 범위 200~399 인경우 성공
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("로그인성공!\(value)")
                    //로그인 성공하면 LoginViewController -> FeedViewController로 바꿈
                    AppDelegate.instance?.presentMainScreen()
                    
                case .failure(let error):
                    print("로그인실패!\(error)")
                    //옵셔널 바인딩, errorInfo 에서 반환값이 옵셔널이다.
                    if let errorInfo = response.errorInfo() {
                        switch errorInfo.field {
                        case "username":
                            self.usernameTextField.becomeFirstResponder()
                            self.usernameTextField.backgroundColor = UIColor.red.withAlphaComponent(0.5)
                        case "password":
                            self.passwordTextField.becomeFirstResponder()
                            self.passwordTextField.backgroundColor = UIColor.red.withAlphaComponent(0.5)
                        default:
                            break //위의 두개 String이 아니면 브레이크 한다.
                        }
                    }
                }
            }
    }
    
    //이벤트를 처리한 놈이 파라미터로 옴
    func textFieldDidChangeText(_ textField: UITextField) {
        UIView.animate(withDuration: 1){
            textField.backgroundColor = .white}
    }
    
}

