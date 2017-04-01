//
//  ViewController.swift
//  ios-client-rap
//
//  Created by Remi Robert on 01/04/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    fileprivate let audioPlayer = AVPlayer()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        AWSPollyManager.shared.buildSong(text: "hello world") { [weak self] url in
            guard let url = url else {return}
            self?.audioPlayer.replaceCurrentItem(with: AVPlayerItem(url: url as URL))
            self?.audioPlayer.play()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
