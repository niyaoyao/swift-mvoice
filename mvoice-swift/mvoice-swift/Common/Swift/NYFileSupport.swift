//
//  NYFileSupport.swift
//  mvoice-swift
//
//  Created by NY on 5/23/17.
//  Copyright © 2017 NY. All rights reserved.
//

import Foundation

extension FileManager {
    class func fileDocPathURL(fileName: String, extensionName: String) -> URL {
        let paths =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let url = documentDirectory.appendingPathComponent(fileName+"."+extensionName)
        print(url)
        return url
    }
}
