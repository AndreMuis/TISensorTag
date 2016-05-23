//
//  TSTAngularVelocityAnimationEngine.swift
//  TISensorTag
//
//  Created by Andre Muis on 5/22/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import SceneKit

class TSTAngularVelocityAnimationEngine : TSTAnimationEngine
{
    var scene : SCNScene
    var sensorTagNode : SCNNode
    
    init()
    {
        self.scene = SCNScene()
        self.sensorTagNode = SCNNode()
    }
    
    func addCamera(position position : SCNVector3)
    {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = position
        
        self.scene.rootNode.addChildNode(cameraNode)
    }
}














