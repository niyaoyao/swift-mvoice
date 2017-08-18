//
//  AudioPlayerBoard.swift
//  mvoice-swift
//
//  Created by NY on 5/25/17.
//  Copyright © 2017 NY. All rights reserved.
//

import UIKit

@IBDesignable class AudioPlayerBoard: UIView {
    @IBOutlet weak var previousButton:UIButton!
    @IBOutlet weak var nextButton:UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet private weak var backgroundView: UIView!

    override func awakeFromNib() {
        setupUI()
    }
    
    
    // MARK: Private Method
    private func setupUI() {
        backgroundColor = UIColor.clear
        previousButton.layer.cornerRadius = previousButton.frame.size.width/2.0
        nextButton.layer.cornerRadius = nextButton.frame.size.width/2.0
        playButton.layer.cornerRadius = playButton.frame.size.width/2.0
        setupBackground()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupBackground()
    }
    
    private func setupBackground() {
       
        let path:UIBezierPath = UIBezierPath()
        let p0 = CGPoint(x: 0, y: frame.size.height)
        let c0 = CGPoint(x: 0, y: 0)
        
        let p1 = CGPoint(x: frame.size.width/2.0, y: 0)
        let c1 = CGPoint(x: frame.size.width, y: 0)
        
        let p2 = CGPoint(x: frame.size.width, y: frame.size.height)
        
        path.move(to: p0)
        path.addQuadCurve(to: p1, controlPoint: c0)
        path.addQuadCurve(to: p2, controlPoint: c1)
        path.addLine(to: p0)
        UIGraphicsBeginImageContext(bounds.size)
        UIColor.hexValue(hex: 0xcfe1dc).setFill()
        UIColor.alphaValue(hex: 0xffffff, alpha: 0).setStroke()
        path.fill()
        UIGraphicsEndImageContext()
        
        let shape:CAShapeLayer = CAShapeLayer.init()
        shape.path = path.cgPath
        backgroundView.layer.mask = shape
    }
}
