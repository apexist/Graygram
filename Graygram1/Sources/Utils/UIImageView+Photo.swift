//
//  UIImageView+Photo.swift
//  Graygram1
//
//  Created by DJV on 2017. 6. 12..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

import UIKit

enum PhotoSize {
    case tiny
    case small
    case medium
    case large
    
    var pointSize: Int {
        switch self {
        case .tiny: return 20
        case .small: return 40
        case .medium: return 320
        case .large: return 640
        }
    }
    
    var pixelSize: Int {
        return self.pointSize * Int(UIScreen.main.scale) //Int 와 Float 곱하기 안됨
    }
}

extension UIImageView {
    func setImage(photoID: String?, size: PhotoSize) {
        guard let photoID = photoID else {
            self.image = nil
            return
        }
        let urlString = "https://www.graygram.com/photos/\(photoID)/\(size.pixelSize)x\(size.pixelSize)"
        let url = URL(string: urlString)!
        self.kf.setImage(with: url)
    }
}
