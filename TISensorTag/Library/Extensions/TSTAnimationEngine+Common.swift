//
//  TSTAnimationEngine+Common.swift
//  TISensorTag
//
//  Created by Andre Muis on 5/22/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import SceneKit

extension TSTAnimationEngine
{
    func addLights(ambientLightColor ambientLightColor : UIColor,
                                     omnidirectionalLightColor : UIColor,
                                     omnidirectionalLightPosition : SCNVector3)
    {
        let omnidirectionalLight : SCNLight = SCNLight()
        omnidirectionalLight.type = SCNLightTypeOmni
        omnidirectionalLight.color = omnidirectionalLightColor
        
        let omnidirectionalLightNode : SCNNode = SCNNode()
        omnidirectionalLightNode.light = omnidirectionalLight
        omnidirectionalLightNode.position = omnidirectionalLightPosition
        
        self.scene.rootNode.addChildNode(omnidirectionalLightNode)
        
        let ambientLight : SCNLight = SCNLight()
        ambientLight.type = SCNLightTypeAmbient
        ambientLight.color = ambientLightColor
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = ambientLight
        
        self.scene.rootNode.addChildNode(ambientLightNode)
    }
    
    func drawSensorTag(eulerAngles eulerAngles : SCNVector3,
                                   width : CGFloat,
                                   height : CGFloat,
                                   depth : CGFloat,
                                   chamferRadius : CGFloat,
                                   holeDiameter : CGFloat,
                                   holeVerticalDisplacement : CGFloat,
                                   coverColor : UIColor,
                                   baseColor : UIColor,
                                   holeColor : UIColor)
    {
        let coverMaterial : SCNMaterial = SCNMaterial()
        coverMaterial.diffuse.contents = coverColor
        coverMaterial.specular.contents = UIColor.whiteColor()
        
        let baseMaterial : SCNMaterial = SCNMaterial()
        baseMaterial.diffuse.contents = baseColor
        baseMaterial.specular.contents = UIColor.whiteColor()
        
        let sensorTagGeometry : SCNBox = SCNBox(width: width,
                                                height: height,
                                                length: depth,
                                                chamferRadius: chamferRadius)
        
        sensorTagGeometry.materials = [coverMaterial, coverMaterial, baseMaterial, coverMaterial, coverMaterial, baseMaterial]
        
        self.sensorTagNode.geometry = sensorTagGeometry
        
        
        let holeMaterial : SCNMaterial = SCNMaterial()
        holeMaterial.diffuse.contents = holeColor
        holeMaterial.specular.contents = UIColor.whiteColor()
        
        let cylinder : SCNCylinder = SCNCylinder(radius: holeDiameter / 2.0, height: depth / 2.0)
        cylinder.materials = [holeMaterial]
        
        let holeNode = SCNNode(geometry: cylinder)
        
        holeNode.position = SCNVector3(0.0, holeVerticalDisplacement, depth / 4.0 + 0.01)
        
        holeNode.eulerAngles = SCNVector3(Float(M_PI) / 2.0, 0.0, 0.0)
        
        self.sensorTagNode.addChildNode(holeNode)
        
        
        self.sensorTagNode.eulerAngles = eulerAngles
        
        self.scene.rootNode.addChildNode(self.sensorTagNode)
    }

    func drawAxes(axisLength axisLength : Float, axisRadius : Float)
    {
        let xAxisGeometry : SCNCylinder = SCNCylinder(radius: CGFloat(axisRadius),
                                                      height: CGFloat(axisLength))
        
        let xAxisNode = SCNNode(geometry: xAxisGeometry)
        
        xAxisNode.position = SCNVector3(x: axisLength / 2.0,
                                        y: 0.0,
                                        z: 0.0)
        
        xAxisNode.rotation = SCNVector4(0.0, 0.0, 1.0, M_PI / 2.0)
        
        self.scene.rootNode.addChildNode(xAxisNode)
        
        
        let yAxisGeometry : SCNCylinder = SCNCylinder(radius: CGFloat(axisRadius),
                                                      height: CGFloat(axisLength))
        
        let yAxisNode = SCNNode(geometry: yAxisGeometry)
        yAxisNode.position = SCNVector3(x: 0.0,
                                        y: axisLength / 2.0,
                                        z: 0.0)
        
        self.scene.rootNode.addChildNode(yAxisNode)
        
        
        let zAxisGeometry : SCNCylinder = SCNCylinder(radius: CGFloat(axisRadius),
                                                      height: CGFloat(axisLength))
        
        let zAxisNode = SCNNode(geometry: zAxisGeometry)
        zAxisNode.position = SCNVector3(x: 0.0,
                                        y: 0.0,
                                        z: axisLength / 2.0)
        
        zAxisNode.rotation = SCNVector4(1.0, 0.0, 0.0, M_PI / 2.0)
        
        self.scene.rootNode.addChildNode(zAxisNode)
    }
}
























