//
//  Grid.swift
//  ios-client-rap
//
//  Created by Remi Robert on 01/04/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit
import SceneKit

let kNumBands = 512
let kBandStep = 0.06125

class Grid {
    var gridNode = SCNNode()
    var grid: [SCNNode] = []
    enum VisualizationType {
        case rectangle
        case spiral
    }
    var visualizationType = VisualizationType.spiral

    func render(_ frequencies: [Float], frequencyBands: FrequencyBands) {
        for n in 0..<frequencies.reversed().count where n < grid.count {
            var amt = Float(frequencies[n] * 200)
            var volume = CGFloat(amt) / 5.0
            volume = min(1, volume)

            amt = amt > 2 ? 2 : amt
            grid[n].scale = SCNVector3(1, amt*2.0, 1)
            grid[n].position.y = amt + 1

            let scaledVolume = volume * 0.8
            let newColor = UIColor(red: 0 + frequencyBands.colorByBandRed[n] * scaledVolume,
                                   green: 0 + frequencyBands.colorByBandGreen[n] * scaledVolume,
                                   blue: 0 + frequencyBands.colorByBandBlue[n] * scaledVolume,
                                   alpha: 1.0)
            grid[n].geometry?.materials.first?.diffuse.contents = newColor
            //grid[n].geometry?.materials.first?.emission.contents = newColor
        }
    }

    func setup(scene: SCNScene?) {
        for _ in 0..<kNumBands {
            let node = createCube(width: 1.0, length: 1.0, position: SCNVector3(0,0,0))
            grid.append(node)
            gridNode.addChildNode(node)
        }
        //configRectangle()
        configSpiral()
        scene?.rootNode.addChildNode(gridNode)
    }

    func handleTap() {
        if visualizationType == .spiral {
            visualizationType = .rectangle
            configRectangle()
        } else {
            visualizationType = .spiral
            configSpiral()
        }
    }

    func configRectangle() {
        let gridWidth = 32
        let gridDepth = kNumBands / 2
//        for i in 0..<256 {
//            for j in 0..<256 {
//                let ax = -gridWidth/2 + i % gridWidth
//                let az = Int(j / gridWidth) - gridDepth / 2
//
//                grid[i].position.x = Float(ax)
//                grid[i].position.y = 0
//                grid[i].position.z = Float(-az)
//            }
//        }
        for i in 0..<kNumBands {
            let ax = -gridWidth/2 + i % gridWidth
            let az = Int(i / gridWidth) - gridDepth / 2
            grid[i].position.x = Float(ax)
            grid[i].position.y = 0
            grid[i].position.z = Float(-az)
        }
    }

    func configSpiral() {
        for i in 0..<256 {
            let r = Float(i) / 10.0
            let s = Float(i) / 50.0
            let x = s * cos(r)
            let z = s * sin(r)
            grid[i].position.x = Float(x)
            grid[i].position.y = 0
            grid[i].position.z = Float(z)
        }
    }

    func createCube(width: CGFloat, length: CGFloat, position: SCNVector3) -> SCNNode {
        var geometry: SCNGeometry
        geometry = SCNBox(width: width, height: 1.0, length: length, chamferRadius: 0.3)
        let geometryNode = SCNNode(geometry: geometry)
        geometryNode.position = position
        return geometryNode
    }
}
