//
//  UIColorExtensions.swift
//  ios-client-rap
//
//  Created by Remi Robert on 01/04/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit

extension UIColor {
    var components:(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r,g,b,a)
    }
}
