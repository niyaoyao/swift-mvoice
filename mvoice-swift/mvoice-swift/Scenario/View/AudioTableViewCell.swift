//
//  AudioTableViewCell.swift
//  mvoice-swift
//
//  Created by NY on 5/25/17.
//  Copyright © 2017 NY. All rights reserved.
//

import UIKit

let kAudioCellId = "kAudioTableViewCell"


class AudioTableViewCell: UITableViewCell {
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var audioStatusImageView: UIImageView!
    @IBOutlet private weak var audioName: UILabel!
    @IBOutlet private weak var wrapperView: UIView!
    
    public var isPlaying:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI () {
        contentView.backgroundColor = UIColor.hexValue(hex: 0xeeeeee)
        wrapperView.layer.cornerRadius = 5
        wrapperView.layer.masksToBounds = true
    }
    
    // MARK: Public Method
    public class func height() -> CGFloat {
        return 100.0
    }
    
    public func update(audio:AudioModel) {
        audioName.text = audio.fileName
        audioStatusImageView.isHidden = !isPlaying
    }
}
