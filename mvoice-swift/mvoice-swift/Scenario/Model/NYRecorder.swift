//
//  NYRecorder.swift
//  mvoice-swift
//
//  Created by NY on 5/23/17.
//  Copyright © 2017 NY. All rights reserved.
//

import UIKit

import Foundation
import AVFoundation

final class NYRecorder: NSObject, AVAudioRecorderDelegate {
    // Can't init is singleton
    private override init() {
        super.init()
    }
    
    // MARK: Shared Instance
    public static let shared = NYRecorder()
    
    // MARK: Local Variable
    var audioRecorder: AVAudioRecorder!
    var audioSession: AVAudioSession!
    var audioPlayer: AVAudioPlayer!
    var duration:Int64 = 0
    var recorderSettins:[String : Int]!
    
    // MARK: Setup
    public func setupRecorder() {
        recorderSettins = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 11025,
            AVNumberOfChannelsKey: 2,
            AVLinearPCMBitDepthKey: 16,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setActive(true)
            audioSession.requestRecordPermission({ (granted: Bool) in
                DispatchQueue.main.async {
                    if granted {
                        print("true" + "\n") // clousure
                    } else {
                        print("false" + "\n")
                    }
                }
            })
            
        } catch  {
            print("Failed to record")
        }
    }
    
    // MARK: Record
    public func startRecord() {
        do {
            let fileName = Date().currentDateString(formatString: "yyyy_MM_dd_hh_mm_ss")
            let fileURL = FileManager.fileDocPathURL(fileName: fileName, extensionName: "m4a")
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setActive(true)
            try audioRecorder = AVAudioRecorder(url: fileURL, settings: recorderSettins)
            audioRecorder.isMeteringEnabled = true
            audioRecorder.delegate = self
            
            if !audioRecorder.isRecording {
                audioRecorder.prepareToRecord()
                audioRecorder.peakPower(forChannel: 0)
                audioRecorder.record()
            } else {
                print("Already Recording...")
            }
        } catch  {
            // clousure
            print(error)
        }
        
    }
    
    public func cancelRecording() {
        if audioRecorder.isRecording {
            audioRecorder.stop()
            do {
                try audioSession.setActive(true)
            } catch  {
                print("audioSession.setActive(true) error")
            }
        }
    }
    
    public func finishRecording() {
        audioRecorder.stop()
        do {
            try audioSession.setActive(false)
        } catch  {
            print("audioSession.setActive(false) error")
        }
    }
    
    // MARK: Player
    public func startPlayer(data: Data) {
        do {
            try audioPlayer = AVAudioPlayer(data: data)
            if !audioPlayer.isPlaying {
                audioPlayer.play()
            }
        } catch {
            print("audio player error")
        }
    }
    
    public func pausePlayer() {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        }
    }
    
    public func stopPlayer() {
        if audioPlayer.isPlaying {
            audioPlayer.stop()
        }
    }
    
}
