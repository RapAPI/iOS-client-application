//
//  ViewController.swift
//  ios-client-rap
//
//  Created by Remi Robert on 01/04/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit
import AWSPolly
import AVFoundation

class ViewController: UIViewController {

    fileprivate let audioPlayer = AVPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        let credentialProvider = AWSCognitoCredentialsProvider(regionType: AWSRegionType.EUCentral1, identityPoolId: "")
        let configuration = AWSServiceConfiguration(
            region: AWSRegionType.EUCentral1,
            credentialsProvider: credentialProvider)

        AWSServiceManager.default().defaultServiceConfiguration = configuration

        let input = AWSPollySynthesizeSpeechURLBuilderRequest()
        input.text = "Sample text"
        input.outputFormat = AWSPollyOutputFormat.mp3
        input.voiceId = AWSPollyVoiceId.joanna
        let builder = AWSPollySynthesizeSpeechURLBuilder.default().getPreSignedURL(input)

        builder.continueWith { task in
            guard let url = task.result else {return nil}
            self.audioPlayer.replaceCurrentItem(with: AVPlayerItem(url: url as URL))
            self.audioPlayer.play()
            return nil
        }
    }
}
