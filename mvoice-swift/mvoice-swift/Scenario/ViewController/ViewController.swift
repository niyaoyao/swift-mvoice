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
   
    // timer label
    
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
        setPlayButton(isPlaying: false)
        hidePlayButton(animate: true)
        NYRecorder.shared.startRecord()
    }
    
    @IBAction func cancelRecording(_ sender: Any) {
        NYRecorder.shared.cancelRecording()
    }
    
    @IBAction func finishRecording(_ sender: Any) {
        NYRecorder.shared.finishRecording()
        showPlayButton()
    }
    
    @IBAction func dragOutsideToCancelRecording(_ sender: Any) {
        // Slide up not start
    }
    
    // MARK: Play Action
    
    @IBAction func playAudio(_ sender: Any) {
        if isPlaying {
            NYRecorder.shared.pausePlayer()
            isPlaying = false
        } else {
            NYRecorder.shared.startPlayLastAudio()
            isPlaying = true
        }
        setPlayButton(isPlaying: isPlaying)
    }
}

