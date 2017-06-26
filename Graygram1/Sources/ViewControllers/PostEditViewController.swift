//
//  PostEditViewController.swift
//  Graygram1
//
//  Created by DJV on 2017. 6. 23..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

import UIKit

//미션
//1. PostEditViewController 정의
//2. UITableView를 꽉차게 보이도록 한다.
//   -tableView.backgroundColor = .blue

final class PostEditViewController: UIViewController {
    //칸이 나뉘도록 테이블 뷰 만듬
    fileprivate let tableView = UITableView(frame: .zero, style: UITableViewStyle.grouped)
    
    fileprivate let image: UIImage
    fileprivate var text: String?
    
    //postEditViewCOntroller가 뜰때 이미지를 받기 위해서 init 시 이미지 받아서 한다.
    init(image: UIImage) {
        
        // 슈퍼클래스의 생성자 전에 상수 초기화 해야 한다. //복습!!!!
        self.image = image
        
        super.init(nibName: nil, bundle: nil)
        
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
        
        //tableView.backgroundColor = .blue
        
        tableView.snp.makeConstraints { make in
            //make.top.left.right.bottom.equalToSuperview()
            make.edges.equalToSuperview()
        }
        
        //global 한 메시지는 모두 notification
        //키보드의 변화
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    //키보드가 올라왔다!!! 이때 이거 한다.
    func keyboardDidChangeFrame(notification: Notification) {
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
            //클로저 작성
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
    
    //무슨셀을 넣을지
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return PostEditViewImageCell.height(width: tableView.width)
        } else {
            return PostEditViewTextCell.height(width: tableView.width, text: self.text)
        }
    }
}

