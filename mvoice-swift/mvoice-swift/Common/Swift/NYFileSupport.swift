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
        let url = docPathURL().appendingPathComponent(fileName+"."+extensionName)
        print(url)
        return url
    }
    
    class func docPathURL() -> URL {
        let paths =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    class func docDirContents(extensionName: String) -> Array<String> {
        var filePaths:Array<String> = Array()
        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: String(contentsOf:docPathURL()))
            for file:String in contents {
                if URL(string:file)?.pathExtension.lowercased() == extensionName {
                    filePaths.append(file)
                    print(file + "\n")
                }
            }
        } catch  {
            assert(error.localizedDescription.utf8.count < 0, error.localizedDescription)
        }
        return filePaths;
    }
    
}
