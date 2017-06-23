//
//  UIImage+Grayscale.swift
//  Graygram1
//
//  Created by DJV on 2017. 6. 21..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

import UIKit

extension UIImage {
    func grayscaled() -> UIImage? { //반환에 실패할수 있기 때문에 옵셔널로...
        // Core Graphics
        // CG Image
        // CG Context
        
        //UIImage -> CGImage -> CGContext -> CGImage -> UIImage
        
        //아래 데이터들은 잘 몰라도 된다. 그냥 참조
        guard let context = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: .allZeros)
        else { return nil }
        
        guard let inputCGImage = self.cgImage else { return nil }
        
        let imageRect = CGRect(origin: .zero, size: self.size) //0.0에 위치한 이미지크기의 사각형
        
        context.draw(inputCGImage, in: imageRect)
        
        guard let outputCGImage = context.makeImage() else { return nil }
        return UIImage(cgImage: outputCGImage)
        
    }
}
