//
//  TSTAccelerationAnimationEngine.swift
//  TISensorTag
//
//  Created by Andre Muis on 5/22/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import SceneKit

class TSTAccelerationAnimationEngine : TSTAnimationEngine
{
    var scene : SCNScene
    var sensorTagNode : SCNNode
    
    var originNode : SCNNode

    var vectorBaseNode : SCNNode
    var accelerationLookAtNode : SCNNode
    
    init()
    {
        self.scene = SCNScene()
        self.sensorTagNode = SCNNode()
        
        self.originNode = SCNNode()
        self.scene.rootNode.addChildNode(self.originNode)

        self.vectorBaseNode = SCNNode()
        
        self.accelerationLookAtNode = SCNNode()
        self.scene.rootNode.addChildNode(self.accelerationLookAtNode)
    }
    
    func addCamera(position position : SCNVector3)
    {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = position
        
        cameraNode.constraints = [SCNLookAtConstraint(target: self.originNode)]
        
        self.scene.rootNode.addChildNode(cameraNode)
    }

    func addVector(color color : UIColor,
                         shaftHeight : CGFloat,
                         shaftRadius : CGFloat,
                         headHeight : CGFloat,
                         headBottomRadius : CGFloat)
    {
        let vectorMaterial : SCNMaterial = SCNMaterial()
        vectorMaterial.diffuse.contents = color
        vectorMaterial.specular.contents = UIColor.whiteColor()
        

        let shaftGeometry : SCNCylinder = SCNCylinder(radius: shaftRadius,
                                                      height: shaftHeight)
        shaftGeometry.materials = [vectorMaterial]
        
        let shaftNode : SCNNode = SCNNode(geometry: shaftGeometry)
        shaftNode.position = SCNVector3(0.0, shaftHeight / 2.0, 0.0)
        
        
        let headGeometry : SCNCone = SCNCone(topRadius: 0.0, bottomRadius: headBottomRadius, height: headHeight)
        headGeometry.materials = [vectorMaterial]
        
        let headNode : SCNNode = SCNNode(geometry: headGeometry)
        headNode.position = SCNVector3(0.0, shaftHeight / 2.0 + headHeight / 2.0, 0.0)
        
        shaftNode.addChildNode(headNode)
        
        
        let rotationNode : SCNNode = SCNNode()
        rotationNode.eulerAngles = SCNVector3(-Float(M_PI) / 2.0, 0.0, 0.0)
        
        rotationNode.addChildNode(shaftNode)


        let lookAtConstraint : SCNLookAtConstraint = SCNLookAtConstraint(target: self.accelerationLookAtNode)
        self.vectorBaseNode.constraints = [lookAtConstraint]

        self.vectorBaseNode.addChildNode(rotationNode)
        
        
        self.scene.rootNode.addChildNode(self.vectorBaseNode)
    }
}












