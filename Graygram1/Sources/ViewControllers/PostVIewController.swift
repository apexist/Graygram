//
//  PostVIewController.swift
//  Graygram1
//
//  Created by DJV on 2017. 6. 26..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

import UIKit

final class PostViewController: UIViewController {
    fileprivate let postID: Int
    
    init(postID: Int) {
        self.postID = postID
        //스토리보드를 안쓰므로 아래와 같이 init
        //아래 이후부터 self 사용가능
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
}
