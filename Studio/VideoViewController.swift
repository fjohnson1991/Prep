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

class VideoViewController: AVPlayerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let url: URL = URL(string: "http://devstreaming.apple.com/videos/wwdc/2016/102w0bsn0ge83qfv7za/102/hls_vod_mvp.m3u8") else { print("video URL error"); return }
        let player = AVPlayer(url: url)
        let controller=AVPlayerViewController()
        controller.player=player
        controller.view.frame = self.view.frame
        self.view.addSubview(controller.view)
        self.addChildViewController(controller)
        player.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
