//
//  ViewController.swift
//  mvoice-swift
//
//  Created by NY on 5/20/17.
//  Copyright © 2017 NY. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NYRecorder.shared.setupRecorder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupUI() {
        navigationItem.title = "M·Voice"
        recordButton.layer.cornerRadius = recordButton.frame.size.width/2.0
    }

    // MARK: Record
    @IBAction func startRecording(_ sender: Any) {
        NYRecorder.shared.startRecord()
    }
    
    @IBAction func cancelRecording(_ sender: Any) {
        NYRecorder.shared.cancelRecording()
    }
    
    @IBAction func finishRecording(_ sender: Any) {
        NYRecorder.shared.finishRecording()
    }
    
    @IBAction func dragOutsideToCancelRecording(_ sender: Any) {
        // Slide up not start 
    }
}

