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

let extensionName = "m4a"

final class NYRecorder: NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
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
    var filePathURL: URL!
    
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
            try audioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
            try audioSession.setActive(true)
            audioSession.requestRecordPermission({ (granted: Bool) in
                DispatchQueue.main.async {
                    if granted {
                        print("granted ok" + "\n") //  implement closure
                    } else {
                        print("granted false" + "\n")
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
            filePathURL = fileURL
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
            //  implement closure
            assert(error.localizedDescription.utf8.count < 0, error.localizedDescription)
        }
        
    }
    
    public func cancelRecording() {
        if audioRecorder.isRecording {
            audioRecorder.stop()
            do {
                try audioSession.setActive(true)
            } catch  {
                assert(error.localizedDescription.utf8.count < 0, error.localizedDescription)
            }
        }
    }
    
    public func finishRecording() {
        audioRecorder.stop()
        do {
            try audioSession.setActive(false)
        } catch  {
            assert(error.localizedDescription.utf8.count < 0, error.localizedDescription)
        }
    }
    
    // MARK: Player
    public func startPlayLastAudio() {
        startPlay(url: filePathURL)
    }
    
    public func startPlay(url: URL) {
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setActive(true)
            try audioPlayer = AVAudioPlayer(contentsOf: url)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            if !audioPlayer.isPlaying {
                audioPlayer.play()
            } else {
                audioPlayer.stop()
            }
        } catch  {
            assert(error.localizedDescription.utf8.count < 0, error.localizedDescription)
        }
    }
    
    public func startPlayer(data: Data) {
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setActive(true)
            try audioPlayer = AVAudioPlayer(data: data)
            audioPlayer.delegate = self
            if !audioPlayer.isPlaying {
                audioPlayer.play()
            }
        } catch {
            assert(error.localizedDescription.utf8.count < 0, error.localizedDescription)
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
            do {
                try audioSession.setActive(false)
            } catch  {
                assert(error.localizedDescription.utf8.count < 0, error.localizedDescription)
            }
        }
    }
    
    // MARK: AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        //  implement closure
    }
    
}
