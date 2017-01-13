//
//  TimerView.swift
//  Studio
//
//  Created by Felicity Johnson on 1/11/17.
//  Copyright © 2017 FJ. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class MovieView: UIView {

    var player: AVPlayer!
    var controller = AVPlayerViewController()
    var invisibleButton = UIButton()
    var isPlaying = Bool()
    var currentBPMLabel = UILabel()
    var timerLabel = UILabel()
    
    var users: [User] = [] {
        didSet {
            configVideo()
            configureView()
            configButton()
            liveBPMUpdateLabel()
            updateTimeLeftLabel()
        }
    }
    
    fileprivate func configureView() {
        //BPM Config
        currentBPMLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(currentBPMLabel)
        currentBPMLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        currentBPMLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        currentBPMLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        currentBPMLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        currentBPMLabel.layer.cornerRadius = 3.0
        currentBPMLabel.layer.backgroundColor = UIColor.orange.withAlphaComponent(0.3).cgColor
        currentBPMLabel.textColor = UIColor.white
        currentBPMLabel.font = UIFont(name: "Helvetica", size: 15)
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(MovieView.liveBPMUpdateLabel), userInfo: nil, repeats: true)
        
        //TimerLabel Config
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(timerLabel)
        timerLabel.topAnchor.constraint(equalTo: currentBPMLabel.bottomAnchor, constant: 8).isActive = true
        timerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        timerLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timerLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        timerLabel.layer.cornerRadius = 3.0
        timerLabel.layer.backgroundColor = UIColor.orange.withAlphaComponent(0.3).cgColor
        timerLabel.textColor = UIColor.white
        timerLabel.font = UIFont(name: "Helvetica", size: 15)
        timerLabel.textAlignment = .center
        timerLabel.lineBreakMode = .byWordWrapping
        timerLabel.numberOfLines = 2
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MovieView.updateTimeLeftLabel), userInfo: nil, repeats: true)
        
        //Pause & play tap config
        invisibleButton.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension MovieView {
    
    //MARK: Movie config
    func configVideo() {
        guard let url: URL = URL(string: "http://devstreaming.apple.com/videos/wwdc/2016/102w0bsn0ge83qfv7za/102/hls_vod_mvp.m3u8") else { print("video URL error"); return }
        player = AVPlayer(url: url)
        controller.player = player
        controller.view.frame = self.bounds
        self.addSubview(controller.view)
        player.play()
        isPlaying = true
    }
    
    //MARK: Pause & play tap config
    func configButton() {
        self.addSubview(invisibleButton)
        invisibleButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        invisibleButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        invisibleButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        invisibleButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        invisibleButton.addTarget(self, action: #selector(handleTapGesture(_:)), for: .touchDown)
    }
    
    func handleTapGesture(_ sender: UITapGestureRecognizer) {
        if isPlaying == true {
            print("pause")
            self.player.pause()
            self.isPlaying = false
        } else {
            print("play")
            self.player.play()
            self.isPlaying = true
        }
    }
    
    //MARK: BPM live update
    func liveBPMUpdateLabel() {
        FirebaseMethods.getCurrentUsersLiveUpdateBPM { (bpm) in
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: "HeartrateChart")
            let attachmentString = NSAttributedString(attachment: attachment)
            let bpmString = NSAttributedString(string: " \(bpm)")
            let myString = NSMutableAttributedString(string: "")
            myString.append(attachmentString)
            myString.append(bpmString)
            self.currentBPMLabel.attributedText = myString
            self.currentBPMLabel.textAlignment = .center
        }
    }
    
    //MARK: Timer
    func updateTimeLeftLabel() {
        let duration = player.currentItem?.asset.duration
        let currentTime = player.currentTime()
        let timeLeft = duration! - currentTime
        let audioDurationSeconds = CMTimeGetSeconds(timeLeft)
        let hours = Int(audioDurationSeconds / 3600)
        let minutes = Int((audioDurationSeconds.truncatingRemainder(dividingBy: 3600)) / 60)
        let seconds = Int(audioDurationSeconds.truncatingRemainder(dividingBy: 60))
        let timeString = String("\(hours):\(minutes):\(seconds) \n remaining")
        guard let unwrappedTimeLeft = timeString else { return }
        timerLabel.text = unwrappedTimeLeft
    }
}
