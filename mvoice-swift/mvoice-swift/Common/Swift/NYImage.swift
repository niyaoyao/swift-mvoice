//
//  NYImage.swift
//  NYHealthy
//
//  Created by NiYao on 6/2/16.
//  Copyright © 2016 SuneBearNi. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    class func imageForColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: size.width, height: size.height))
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    class func unitImageForColor(color: UIColor) -> UIImage {
        return imageForColor(color: color, size: CGSize(width: 1.0, height: 1.0))
    }
}
