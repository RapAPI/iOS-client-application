//
//  AWSPolly.swift
//  ios-client-rap
//
//  Created by Remi Robert on 01/04/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit
import AWSPolly

enum AWSVoice: String {
    case geraint = "geraint"
    case gwyneth = "gwyneth"
    case mads = "mads"
    case naja = "naja"
    case hans = "hans"
    case marlene = "marlene"
    case nicole = "nicole"
    case russell = "russell"
    case amy = "amy"
    case brian = "brian"
    case emma = "emma"
    case raveena = "raveena"
    case ivy = "ivy"
    case joanna = "joanna"
    case joey = "joey"
    case justin = "justin"

    func voice() -> AWSPollyVoiceId {
        switch self {
        case .geraint:
            return AWSPollyVoiceId.geraint
        case .gwyneth:
            return AWSPollyVoiceId.gwyneth
        case .mads:
            return AWSPollyVoiceId.mads
        case .naja:
            return AWSPollyVoiceId.maja
        case .hans:
            return AWSPollyVoiceId.hans
        case .marlene:
            return AWSPollyVoiceId.marlene
        case .nicole:
            return AWSPollyVoiceId.nicole
        case .russell:
            return AWSPollyVoiceId.russell
        case .amy:
            return AWSPollyVoiceId.amy
        case .brian:
            return AWSPollyVoiceId.brian
        case .emma:
            return AWSPollyVoiceId.emma
        case .raveena:
            return AWSPollyVoiceId.raveena
        case .ivy:
            return AWSPollyVoiceId.ivy
        case .joanna:
            return AWSPollyVoiceId.joanna
        case .joey:
            return AWSPollyVoiceId.joey
        case .justin:
            return AWSPollyVoiceId.justin
        }
    }
}

class AWSPollyManager {

    static let shared = AWSPollyManager()
    let input = AWSPollySynthesizeSpeechURLBuilderRequest()

    init() {
        input.outputFormat = AWSPollyOutputFormat.mp3
        input.voiceId = AWSPollyVoiceId.justin
    }

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
        let builder = AWSPollySynthesizeSpeechURLBuilder.default().getPreSignedURL(input)
        builder.continueWith { task in
            completion(task.result)
            return nil
        }
    }
}
