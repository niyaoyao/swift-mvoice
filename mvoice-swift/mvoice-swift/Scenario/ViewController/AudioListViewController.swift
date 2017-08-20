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
    
    var selectedIndex:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(AudioViewModel.shared.audioModels())
        setupUI()
        audioPlayerBoard.playButton.addTarget(self,
                                              action: #selector(startPlaying),
                                              for: UIControlEvents.touchUpInside)
        audioPlayerBoard.previousButton.addTarget(self,
                                                  action: #selector(previousVoice),
                                                  for: UIControlEvents.touchUpInside)
        audioPlayerBoard.nextButton.addTarget(self,
                                              action: #selector(nextVoice),
                                              for: UIControlEvents.touchUpInside)
        
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

        cell.isPlaying = selectedIndex == indexPath.row
        cell.update(audio: audio)
        return cell
    }
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AudioTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.reloadData()
        playAudio(index: selectedIndex)
    }
    
    // MARK: Audio
    func playAudio(index: Int) {
        if AudioViewModel.shared.audioModels().count >= index + 1 && index >= 0 {
            let audio:AudioModel =  AudioViewModel.shared.audioModels()[index]
            let url:URL = audio.filePathURL
            AudioViewModel.shared.playingAudio = audio
            NYRecorder.shared.startPlay(url: url)
        } else {
            if AudioViewModel.shared.audioModels().count <= 0 {
                let alertController = UIAlertController(title: "This world is silent", message: "There is no voice to hear", preferredStyle: .alert)
                
                let  deleteButton = UIAlertAction(title: "OK", style: .destructive, handler: nil)
                alertController.addAction(deleteButton)
                
                navigationController?.present(alertController, animated: true, completion: nil)
                
            } else {
                let alertController = UIAlertController(title: "Oops!", message: "Count: \(AudioViewModel.shared.audioModels().count) \n Index: \(index)", preferredStyle: .alert)
                
                let  deleteButton = UIAlertAction(title: "OK", style: .destructive, handler: nil)
                alertController.addAction(deleteButton)
                navigationController?.present(alertController, animated: true, completion: nil)
            }
        }
    }

    func refreshUI(playIndex: Int) {
        selectedIndex = playIndex
        audioListTableView.reloadData()
    }
    
    // MARK: Button Action
    func startPlaying() {
        var playIndex = 0
        if selectedIndex >= 0 && selectedIndex < AudioViewModel.shared.audioModels().count {
            playIndex = selectedIndex
        }
        refreshUI(playIndex: playIndex)
        playAudio(index: playIndex)
    }
    
    func previousVoice() {
        var playIndex = 0
        let total = AudioViewModel.shared.audioModels().count
        
        if selectedIndex >= 1 && selectedIndex < total {
            playIndex = selectedIndex - 1
        } else {
            playIndex = total - 1
        }
        refreshUI(playIndex: playIndex)
        playAudio(index: playIndex)
    }
    
    func nextVoice() {
        var playIndex = 0
        let total = AudioViewModel.shared.audioModels().count
        if selectedIndex >= -1 && selectedIndex <= total - 2 {
            playIndex = selectedIndex + 1
        }
        refreshUI(playIndex: playIndex)
        playAudio(index: playIndex )
    }
}
