//
//  MovieViewController.swift
//  Studio
//
//  Created by Felicity Johnson on 1/3/17.
//  Copyright © 2017 FJ. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class MovieViewController: UIViewController {

    var player: AVPlayer!
    var controller = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configVideo()
    }
    
    func configVideo() {
        
        guard let url: URL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4") else { print("video URL error"); return }
        player = AVPlayer(url: url)
        controller.player = player
        controller.view.frame = self.view.frame
        self.view.addSubview(controller.view)
        self.addChildViewController(controller)
        player.play()
    }
}
