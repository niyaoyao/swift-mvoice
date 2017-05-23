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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupUI() {
        navigationItem.title = "M·Voice"
        recordButton.layer.cornerRadius = recordButton.frame.size.width/2.0
    }

}

