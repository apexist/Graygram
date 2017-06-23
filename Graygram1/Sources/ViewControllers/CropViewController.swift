
//
//  CropViewController.swift
//  Graygram1
//
//  Created by DJV on 2017. 6. 21..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

import UIKit

final class CropViewController: UIViewController {
    
    //응답을 클로저로 정의 하기 위해...완료되고나서 didFinishCropping호출 -> MainTapbarController에서 사용
    //크롭된 이미지를 보냄
    var didFinishCropping: ((UIImage) -> Void)? //옵셔널 클로저가 됨
    
    //밖에서 알필요없으므로 fileprivate
    fileprivate let scrollView = UIScrollView()
    fileprivate let imageView = UIImageView()
    
    fileprivate let cropAreaView = UIView()
    
    fileprivate let topCoverView = UIView()
    fileprivate let bottomCoverView = UIView()
    
    //생성자에 그롭할 이미지를 넣음
    init(image: UIImage) {
        //클래스이므로 슈퍼클래스 생성자를 넣어야함 //왜 근데 아래처럼 해야 하지??? 찾아보자
        super.init(nibName: nil, bundle: nil)
        self.imageView.image = image
        self.cropAreaView.layer.borderColor = UIColor.lightGray.cgColor
        self.cropAreaView.layer.borderWidth = 1 / UIScreen.main.scale //scale에 따라 물리픽셀 기준 1픽셀만 사용하도록 가장얇은선 사용하도록한다
        
        //커버뷰에 배경색을 줌
        self.topCoverView.backgroundColor = .white
        self.topCoverView.alpha = 0.9 //투명도
        self.bottomCoverView.backgroundColor = .white
        self.bottomCoverView.alpha = 0.9 //투명도
        
        //굳이 멤버속성으로 안해도된다. 항상 있어야 하니까, 버튼을 좌우에 추가
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonItemDidTap))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonItemDidTap))
        
        //생성자 시점에서는
        //self.navigationController, self.tabBarController 는 접근 안된다. -> ViewWillAppear 등에서 정의 해줘야 한다.
        //self.tabBarItem, self.navigationItem 은 가능하다
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //화면에 보이게 뷰에 추가
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        //위에서 자동으로 내려주는 시작점을...기능을 꺼줌
        self.automaticallyAdjustsScrollViewInsets = false
        
        //바운스 되게
        self.scrollView.alwaysBounceVertical = true
        self.scrollView.alwaysBounceHorizontal = true
        
        //핀치 줌 가능하게
        //self.scrollView.minimumZoomScale = 0.5
        self.scrollView.maximumZoomScale = 3
        
        //내꺼를 델리게이트 하자~ 아래에 따로 구현
        self.scrollView.delegate = self
        
        //스크롤 인디케이터 안보이게
        self.scrollView.showsHorizontalScrollIndicator = false
        
        //터치이벤트를 안먹게 해줌
        self.topCoverView.isUserInteractionEnabled = false
        self.bottomCoverView.isUserInteractionEnabled = false
        self.cropAreaView.isUserInteractionEnabled = false
        
        //아래 했을때 터치가 안될경우 위의 설정을 해줘야 한다. 아바타뷰를 이미지뷰로 만들고 터치시 프로필 화면 나오게 하고 싶을때ㅡ 이런 실수 한다.
        //addTarget
        //UITapGestureRecognizer
        
        self.scrollView.addSubview(self.imageView)
        self.view.addSubview(self.scrollView)

        self.view.addSubview(self.cropAreaView) //하나씩 뷰를 쌓는다...
        
        self.view.addSubview(topCoverView)
        self.view.addSubview(bottomCoverView)
        
        
        //크기를 잡음 꽉차게
        self.scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview() //edges로 하면 모든 엣지가 꽉참
        }
        
        self.cropAreaView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(self.cropAreaView.snp.width) //높이도같음
            make.centerY.equalToSuperview()
        }
        
        //topCoverCiew의 위/오른쪽/왼쪽을 꽉차게, 그리고 아래를 corpAreaView의 top위치와 같게
        self.topCoverView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.cropAreaView.snp.top)
        }
        
        self.bottomCoverView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(self.cropAreaView.snp.bottom)
        }
        
    }
    //스크롤뷰내에서는 오토레이아웃을 쓰는 것을 권장하지 않음
    //스크롤뷰에 꽉차게 하는 방법
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.imageView.size == .zero {
            //self.imageView.size = self.scrollView.size
            self.initializeContentSize()
        }
    
    }
    
    private func initializeContentSize() {
        //이미지원본 크키를 알아야 함
        guard let image = self.imageView.image else { return }
        let imageWidth = image.size.width
        let imageHeigt = image.size.height
        
        //가로긴이미지인지 세로긴이미지인지 정사각형인지 분기 필요
        
        if imageWidth > imageHeigt { //가로로 긴 이미지
            self.imageView.height = self.cropAreaView.height
            self.imageView.width = imageWidth * self.cropAreaView.height / imageHeigt
        } else if imageWidth < imageHeigt { //세로로 긴 이미지
            self.imageView.width = self.cropAreaView.width
            self.imageView.height = imageHeigt * self.cropAreaView.width / imageWidth
        } else { //정사각형
            self.imageView.size = self.cropAreaView.size
        }
        
        //이미지가 크롭영역의 가운데 위치 하게 하기 위해
        self.scrollView.contentInset.top = (self.scrollView.height - self.cropAreaView.height) / 2
        self.scrollView.contentInset.bottom = self.scrollView.contentInset.top
        //사이즈를 정해줘야 스크롤이 된다. 테이블뷰와 컨렉션뷰는 안잡아줘도 자동으로 된다.
        self.scrollView.contentSize = self.imageView.size
        self.centerContent()
    }
    
    private func centerContent() {
        self.scrollView.contentOffset.x = ( self.scrollView.contentSize.width - self.scrollView.width ) / 2
        self.scrollView.contentOffset.y = ( self.scrollView.contentSize.height - self.scrollView.height ) / 2
    }
    
    func cancelButtonItemDidTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func doneButtonItemDidTap() {
        guard let image = self.imageView.image else { return }
        
        //좌표계변환 메소드
        //cropAreaView.frame을 imageView.frame과 같은 좌표계로 변경
        var rect = self.scrollView.convert(self.cropAreaView.frame, from: self.cropAreaView.superview)
        //rect는 imageView.frame과 같이 있게 된다.
        
        rect.origin.x *= image.size.width / self.imageView.width
        rect.origin.y *= image.size.height / self.imageView.height
        rect.size.width *= image.size.width / self.imageView.width
        rect.size.height *= image.size.height / self.imageView.height
        
        //CG = Core Graphics
        if let croppedCGImage = image.cgImage?.cropping(to: rect) {
            let croppedImage = UIImage(cgImage: croppedCGImage)
            self.didFinishCropping?(croppedImage) //클로저 호출
        }
    }
    
}


extension CropViewController: UIScrollViewDelegate {
    
    //어떤뷰를 줌 할건지 물어봄
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView //이미지뷰를 줌할꺼라고 알려줌
    }
}
