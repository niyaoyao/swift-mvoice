//
//  NYDevice.swift
//  NYHealthy
//
//  Created by NiYao on 6/2/16.
//  Copyright © 2016 SuneBearNi. All rights reserved.
//

import Foundation
import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

extension NSObject {
    class func getUUID() -> String {
        let uuid = UIDevice.current.identifierForVendor?.uuid
        return String(describing: uuid)
    }
    
}
