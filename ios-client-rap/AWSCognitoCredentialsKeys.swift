//
//  Constant.swift
//  ios-client-rap
//
//  Created by Remi Robert on 01/04/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit
import Foundation
import AWSPolly

struct AWSCognitoCredentialsKeys {

    static var identityPoolId: String {
        guard let path = Bundle.main.path(forResource: "AWSConfiguration", ofType: "plist") else {return ""}
        guard let content = NSDictionary(contentsOfFile: path) else {return ""}
        return content["identityPoolId"] as? String ?? ""
    }

    static var region: AWSRegionType {
        return AWSRegionType.EUWest1
    }
}
