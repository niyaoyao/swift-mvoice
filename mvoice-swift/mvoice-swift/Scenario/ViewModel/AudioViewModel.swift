//
//  AudioViewModel.swift
//  mvoice-swift
//
//  Created by NY on 5/23/17.
//  Copyright © 2017 NY. All rights reserved.
//

import UIKit

let entity = "Audio"
let kFileName = "fileName"
let kTimestamp = "timestamp"

class AudioModel {
    public var fileName:String!
    public var timestamp:Int!
    public var filePathURL:URL {
        return FileManager.docPathURL().appendingPathComponent(fileName)
    }
    
    init(dictionary:Dictionary<String, Any>) {
        self.fileName = dictionary[kFileName] as! String
        self.timestamp = dictionary[kTimestamp] as! Int
    }
}

class AudioViewModel: NSObject {
    private override init() {
        super.init()
    }
    var playingAudio:AudioModel!
    
    // MARK: Shared Instance
    public static let shared = AudioViewModel()
    
    
    
    // MARK: Public Function
    public func audioModels() -> Array<AudioModel> {
        var audioModels:Array<AudioModel> = Array()
        let dataArray:Array<Dictionary<String, Any>> = selectAllAudioPaths() as! Array<Dictionary<String, Any>>
        
        for dictionary:Dictionary in dataArray {
            audioModels.append(AudioModel.init(dictionary: dictionary))
        }
        
        return audioModels;
    }
    
    public func insertAudioData(fileName:String) {
        let dic:Dictionary<String, Any> = [
            kFileName: fileName,
            kTimestamp: Date().timeIntervalSince1970
        ]
        NYCoreData.shared.insert(entity: entity, dictionary: dic)
    }
    
    public func selectAllAudioPaths() -> Array<Any> {
        return NYCoreData.shared.selectData(keys: [kFileName],
                                            entity: entity,
                                            predicate:"",
                                            sortKey: kTimestamp,
                                            ascending: false,
                                            limit: 0)
    }
}
