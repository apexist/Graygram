//
//  PostEditViewController.swift
//  Graygram1
//
//  Created by DJV on 2017. 6. 23..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

import UIKit
import Alamofire

//미션
//1. PostEditViewController 정의
//2. UITableView를 꽉차게 보이도록 한다.
//   -tableView.backgroundColor = .blue

final class PostEditViewController: UIViewController {
    //아래에서 아직 target에 self 지정 못함,
    fileprivate let cancelButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
    fileprivate let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
    
    //프로그래스 뷰추가
    fileprivate let progressView = UIProgressView()
    
    //칸이 나뉘도록 테이블 뷰 만듬
    fileprivate let tableView = UITableView(frame: .zero, style: UITableViewStyle.grouped)
    
    fileprivate let image: UIImage
    fileprivate var text: String?
    
    
    //미션:
    // 1. cancleButtonItem 과 doneButtonItem을 속성으로 정의
    // 2. 네비게이션 바 왼쪽 오른쪽에 추가
    
    //postEditViewCOntroller가 뜰때 이미지를 받기 위해서 init 시 이미지 받아서 한다.
    init(image: UIImage) {
        
        // 슈퍼클래스의 생성자 전에 상수 초기화 해야 한다. //복습!!!!
        self.image = image
        
        super.init(nibName: nil, bundle: nil)
        
        self.cancelButtonItem.target = self
        self.cancelButtonItem.action = #selector(cancelButtonItemDidTap)
        
        self.doneButtonItem.target = self
        self.doneButtonItem.action = #selector(doneButtonItemDidTap)
        
        //navigationItem은 모든 뷰컨틀롤러가 가지고 있는 속성임
        self.navigationItem.leftBarButtonItem = self.cancelButtonItem
        self.navigationItem.rightBarButtonItem = self.doneButtonItem
        
        //프로그래스바가 처음에 안보이게
        self.progressView.isHidden = true
        
        //이거 먼저 해야 함... 스토리보드 안쓰기 때문에...
        self.tableView.register(PostEditViewImageCell.self, forCellReuseIdentifier: "imageCell")
        self.tableView.register(PostEditViewTextCell.self, forCellReuseIdentifier: "textCell")
        
        //알게 해줘야 함 datasource 와 delegate 정의된걸...
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //드레그로 내리면 키보드가 쇽 내려간다.
        self.tableView.keyboardDismissMode = . interactive
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //뷰가 내려갈때 노티피케이션을 없앤다
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tableView)
        
        //progressview를 테이블뷰 뒤에 add해야 보인다
        self.view.addSubview(self.progressView)
        
        
        //tableView.backgroundColor = .blue
        
        self.tableView.snp.makeConstraints { make in
            //make.top.left.right.bottom.equalToSuperview()
            make.edges.equalToSuperview()
        }
        
        self.progressView.snp.makeConstraints { make in
            make.top.equalTo(self.topLayoutGuide.snp.bottom) //네비게이션바가 있음 그아래 없으면 바로 아래
            make.left.right.equalToSuperview()
        }
        
        //global 한 메시지는 모두 notification
        //키보드의 변화
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    //키보드가 올라왔다!!! 이때 이거 한다.
    func keyboardWillChangeFrame(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        //키보드가 보이는 높이 //전체 스크린 높이 - 키보드프레임의 Y좌표
        let keyboardVisibleHeight = UIScreen.main.bounds.height - keyboardFrame.y
        UIView.animate(withDuration: duration) { 
            self.tableView.contentInset.bottom = keyboardVisibleHeight
            self.tableView.scrollIndicatorInsets.bottom = keyboardVisibleHeight
            
            //키보드가 뜰때에만 스크롤되게 하기 위해 분기 처리
            let isShowing = keyboardVisibleHeight > 0
            if isShowing {
                self.tableView.scrollToRow(at: IndexPath(row:1, section: 0),
                                           at: UITableViewScrollPosition.none, //스크롤이 보이는 위치
                                           animated: false)
            }
            
        }
        
    }
    
    func cancelButtonItemDidTap() {
        //aler으로 확인 받는것 필요하나 이전에 todo box 참고 
        self.dismiss(animated: true, completion: nil)
    }
    
    func doneButtonItemDidTap() {
        
        //호출될때 비활성화 실행
        self.setControlsEnabled(false)
        
        //프로그래스바가 보이게
        self.progressView.isHidden = false
        
        /*
          1. x-www-form-urlencoded
            POST https://example.com
            key1=value&key2=value (바디에)
            -> 바이너리 못보냄
          2. form-data (multipart)
            POST https://example.com
            ----
            예제를 찾아보자
            ----
          3. application/json
            POST https://example.com
            {
                "key" : "abc"
                "key1" : "abc"
            }
        */
        
        let urlString = "https://api.graygram.com/posts"
        
        Alamofire.upload(
            multipartFormData: { formData in
                if let imageData = UIImageJPEGRepresentation(self.image, 1) {
                    //formData에 직렬화된 이미지를 추가
                    formData.append(imageData, withName: "photo", fileName: "photo.jpg", mimeType: "image/jpeg")
                }
                if let textData = self.text?.data(using: .utf8) {
                    formData.append(textData, withName: "message")
                }
            },
            to: urlString,
            method: .post,
            encodingCompletion: { encodingResult in //request만들때 실패할수 있음, 인코딩이 성공했는지 실패했는지, 나누어 처리
                switch encodingResult {
                case .success(let request, _, _):
                    print("인코딩 성공 : \(request)")
                    request
                        //프로그래스 진행상태를 위한것
                        .uploadProgress { progress in
                            self.progressView.progress = Float(progress.completedUnitCount) / Float(progress.totalUnitCount)
                        }
                        .validate(statusCode: 200..<400)
                        .responseJSON { response in
                            switch response.result {
                            case .success(let value):
                                print("업로드 성공 : \(value)")
                                //화면을 닫고, Noti발송
                                
                                //noti 발송위해서 옵셔널 바인딩
                                if let json = value as? [String:Any], let post = Post(JSON: json) {
                                    //default 라는 싱클톤
                                    //업로드 완료를 글로벌하게 뿌림
                                    NotificationCenter.default.post(
                                        name: .postDidCreate,
                                        object: self,
                                        userInfo: ["post": post]
                                    )
                                }
                                //화면닫자
                                self.dismiss(animated: true, completion: nil)
                            case .failure(let error):
                                print("업로드 실패 : \(error)")
                                
                                //다시 업로드 가능하게
                                self.setControlsEnabled(true)
                                
                                //프로그래스바가 안보이게
                                self.progressView.isHidden = true
                            }
                    }
                case .failure(let error):
                    print("인코딩 실패 : \(error)")
                    //다시 업로드 가능하게
                    self.setControlsEnabled(true)
                    //프로그래스바가 안보이게
                    self.progressView.isHidden = true
                }
            }
        )
    }
    
    func setControlsEnabled(_ isEnabled: Bool) {
        //버튼 비활성화, 외관도 바뀐
        self.cancelButtonItem.isEnabled = isEnabled
        self.doneButtonItem.isEnabled = isEnabled
        //뷰를 비활성화
        self.view.isUserInteractionEnabled = isEnabled
    }
    
}

extension PostEditViewController: UITableViewDataSource {
    //몇개의 쎌이 존재하는지
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 //이미지셀 + 텍스트셀
    }
    //무슨셀을 넣을지 0 이면 이미지, 1 이면 텍스트
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell" , for: indexPath)
                as! PostEditViewImageCell
            
            cell.configure(image: self.image)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath)
                as! PostEditViewTextCell
            cell.configure(text: self.text)
            //콜백 클로저 작성
            cell.textDidChange = { text in
                self.text = text
                //트릭...이러면 포커스가 잃어버리지 않으면서 셀의 크기만 다시 계산
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
                self.tableView.scrollToRow(at: indexPath, at: .none, animated: false)
            }
            return cell
        }
        
    }
}

extension PostEditViewController: UITableViewDelegate {
    
    //셀의 높이를 리턴
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return PostEditViewImageCell.height(width: tableView.width)
        } else {
            return PostEditViewTextCell.height(width: tableView.width, text: self.text)
        }
    }
}

