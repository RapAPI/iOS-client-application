//
//  AWSPolly.swift
//  ios-client-rap
//
//  Created by Remi Robert on 01/04/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit
import AWSPolly

class AWSPollyManager {

    static let shared = AWSPollyManager()
    private let input = AWSPollySynthesizeSpeechURLBuilderRequest()

    func configure() {
        let credentialProvider = AWSCognitoCredentialsProvider(regionType: AWSCognitoCredentialsKeys.region,
                                                               identityPoolId: AWSCognitoCredentialsKeys.identityPoolId)

        let configuration = AWSServiceConfiguration(
            region: AWSCognitoCredentialsKeys.region,
            credentialsProvider: credentialProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }

    func buildSong(text: String, completion: @escaping (_ url: NSURL?) -> Void) {
        input.text = text
        input.outputFormat = AWSPollyOutputFormat.mp3
        input.voiceId = AWSPollyVoiceId.joanna
        let builder = AWSPollySynthesizeSpeechURLBuilder.default().getPreSignedURL(input)
        builder.continueWith { task in
            completion(task.result)
            return nil
        }
    }
}
