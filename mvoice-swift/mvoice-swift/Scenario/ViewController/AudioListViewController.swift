//
//  AudioListViewController.swift
//  mvoice-swift
//
//  Created by NY on 5/25/17.
//  Copyright © 2017 NY. All rights reserved.
//

import UIKit

class AudioListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var audioListTableView: UITableView!
    @IBOutlet weak var audioPlayerBoard: AudioPlayerBoard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(AudioViewModel.shared.audioModels())
        setupUI()
    }

    private func setupUI()  {
        navigationItem.title = "i·Listen"
        setupTableView()
    }
    
    private func setupTableView() {
        audioListTableView.delegate = self
        audioListTableView.dataSource = self
    
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AudioViewModel.shared.audioModels().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:AudioTableViewCell = tableView.dequeueReusableCell(withIdentifier: kAudioCellId) as! AudioTableViewCell
        let audio = AudioViewModel.shared.audioModels()[indexPath.row]

        cell.update(audio: audio)
        cell.isPlaying = audio.fileName == AudioViewModel.shared.playingAudio?.fileName
        return cell
    }
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AudioTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let audio:AudioModel =  AudioViewModel.shared.audioModels()[indexPath.row]
        let url:URL = audio.filePathURL
        AudioViewModel.shared.playingAudio = audio
        tableView.reloadData()
        NYRecorder.shared.startPlay(url: url)
    }
}
