//
//  FrequencyBand.swift
//  ios-client-rap
//
//  Created by Remi Robert on 01/04/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit

class FrequencyBands {
    var volumeInBand: [CGFloat] = [] // 0 to 1.0
    var colorByBand: [UIColor] = []
    var colorByBandRed: [CGFloat] = []
    var colorByBandGreen: [CGFloat] = []
    var colorByBandBlue: [CGFloat] = []
    var layers:[CALayer] = []

    func render(_ frequencies: [Float], yPosition: CGFloat) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(0)
        CATransaction.setDisableActions(true)
        // Set the dimension of every frequency bar.
        let width:CGFloat = 320.0 / CGFloat(kNumBands)
        var frame:CGRect = CGRect(x: 20, y: 0, width: width, height: 0)
        for n in 0..<kNumBands {
            frame.size.height = 4 + CGFloat(frequencies[n]) * 5000
            if frame.size.height > 150 {
                frame.size.height = 150
            }
            frame.size.width = 1
//            frame.size.width = CGFloat(frequencies[n] * 1.5)
            frame.origin.y = yPosition - frame.size.height
            layers[n].frame = frame
            frame.origin.x += width

            let amt = Float(frequencies[n] * 200)

            var volume = CGFloat(amt) / 5.0
            volume = min(1, volume)
            volumeInBand[n] = volume
        }
        CATransaction.commit()
    }

    func setup(view: UIView) {
        setupLayers(view: view)
        setupBands()
    }

    func setupLayers(view: UIView) {
        for n in 0..<kNumBands {
            let color = colorForBand(n)
            let newColor = UIColor(red: 0.5 + color.components.red * 0.5,
                                   green: 0.5 + color.components.green * 0.5,
                                   blue: 0.5 + color.components.blue * 0.5, alpha: 1.0)
            let newCGColor = newColor.cgColor
            layers.append(CALayer())
            layers[n].backgroundColor = newCGColor
            layers[n].frame = CGRect.zero
            view.layer.addSublayer(layers[n])
        }
    }

    func setupBands() {
        for n in 0..<kNumBands {
            let color = colorForBand(n)
            volumeInBand.append(0)
            colorByBand.append(color)
            colorByBandRed.append(color.components.red)
            colorByBandGreen.append(color.components.green)
            colorByBandBlue.append(color.components.blue)
        }
    }

    func colorForBand(_ n: Int) -> UIColor {
        let range = CGFloat(0.8)
        let t = CGFloat(n) / CGFloat(kNumBands)
        return UIColor(hue: t * range, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    }
}
