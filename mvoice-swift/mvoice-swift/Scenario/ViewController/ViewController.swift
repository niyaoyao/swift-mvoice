//
//  ViewController.swift
//  mvoice-swift
//
//  Created by NY on 5/20/17.
//  Copyright © 2017 NY. All rights reserved.
//

import UIKit

let animateDuration = 0.3
let playButtonHideConstant:CGFloat = -80.0
let playButtonShowConstant:CGFloat = 42.0

class ViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playButtonBottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var promotionLabel: UILabel!
    
    // MARK: Timer
    var timer: DispatchSourceTimer?
    var seconds: Int = 0
    
    private func startTimer() {
        seconds = 0
        let queue = DispatchQueue(label: "that.boring.bear.mvoice.timer.queue", attributes: .concurrent)
        timer?.cancel()
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer?.scheduleRepeating(deadline: .now(), interval: .seconds(1), leeway: .seconds(0))
        timer?.setEventHandler { [weak self] in
            self!.seconds += 1
            DispatchQueue.main.async(execute: {
                self?.promotionLabel.text = "Recording \(String(describing: self!.seconds))s..."
            })
        }
        timer?.resume()
    }
    
    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
    var isPlaying:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NYRecorder.shared.setupRecorder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Private Method
    private func setupUI() {
        navigationItem.title = "M·Voice"
        recordButton.layer.cornerRadius = recordButton.frame.size.width/2.0
        playButton.layer.cornerRadius = playButton.frame.size.width/2.0
        hidePlayButton(animate: false)
        promotionLabel.text = "Hold microphone button to restart"
    }

    private func showPlayButton() {
        UIView.animate(withDuration: animateDuration) { 
            [unowned self] in
            self.playButton.alpha = 1
            self.playButtonBottomLayoutConstraint.constant = playButtonShowConstant
        }
    }
    
    private func hidePlayButton(animate: Bool) {
        if animate {
            UIView.animate(withDuration: animateDuration, animations: { 
                [unowned self] in
                self.playButton.alpha = 0
                self.playButtonBottomLayoutConstraint.constant = playButtonHideConstant
            })
        } else {
            playButton.alpha = 0
            playButtonBottomLayoutConstraint.constant = playButtonHideConstant
        }
    }
    
    func setPlayButton(isPlaying: Bool) {
        if isPlaying {
            playButton.setImage(UIImage.init(named: "stop"), for: UIControlState.normal)
            playButton.backgroundColor = UIColor.hexValue(hex: 0xff6d6d)
        } else {
            playButton.setImage(UIImage.init(named: "play"), for: UIControlState.normal)
            playButton.backgroundColor = UIColor.hexValue(hex: 0x7face0)
        }
    }
    
    // MARK: Record Action
    @IBAction func startRecording(_ sender: Any) {
        startTimer()
        setPlayButton(isPlaying: false)
        hidePlayButton(animate: true)
        NYRecorder.shared.startRecord()
        promotionLabel.text = "Recording Voice..."
    }
    
    @IBAction func cancelRecording(_ sender: Any) {
        NYRecorder.shared.cancelRecording()
        stopTimer()
        promotionLabel.text = "Canceled...\nHold microphone button again to restart.."
    }
    
    @IBAction func finishRecording(_ sender: Any) {
        stopTimer()
        if seconds > 3 {
            NYRecorder.shared.finishRecording()
            showPlayButton()
            AudioViewModel.shared.insertAudioData(fileName: NYRecorder.shared.filePathURL.lastPathComponent)
            promotionLabel.text = "Wait for play"
        } else {
            promotionLabel.text = "The voice is too short to save"
        }
    }
    
    @IBAction func dragOutsideToCancelRecording(_ sender: Any) {
        // Slide up not start
        promotionLabel.text = "Release Button To Cancel..."
    }
    
    // MARK: Play Action
    
    @IBAction func playAudio(_ sender: Any) {
        if isPlaying {
            NYRecorder.shared.pausePlayer()
            isPlaying = false
            promotionLabel.text = "Wait for play"
        } else {
            NYRecorder.shared.startPlayLastAudio()
            isPlaying = true
            promotionLabel.text = "Playing..."
        }
        setPlayButton(isPlaying: isPlaying)
    }
}

