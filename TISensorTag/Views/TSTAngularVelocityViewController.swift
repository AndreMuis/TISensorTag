//
//  TSTAngularVelocityViewController.swift
//  TISensorTag
//
//  Created by Andre Muis on 5/17/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import SceneKit
import UIKit

class TSTAngularVelocityViewController : UIViewController
{
    @IBOutlet weak var sceneView: SCNView!
    
    var scene : SCNScene!
    var sensorTagNode : SCNNode?
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.scene = SCNScene()
        self.sensorTagNode = SCNNode()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.sceneView.scene = self.scene
        
        self.addCamera()
        self.addLights()
        
        self.drawSensorTag()
    }

    func addCamera()
    {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = TSTConstants.cameraPosition
        
        self.scene.rootNode.addChildNode(cameraNode)
    }
    
    func addLights()
    {
        let omnidirectionalLight : SCNLight = SCNLight()
        omnidirectionalLight.type = SCNLightTypeOmni
        omnidirectionalLight.color = TSTConstants.omnidirectionalLightColor
        
        let omnidirectionalLightNode : SCNNode = SCNNode()
        omnidirectionalLightNode.light = omnidirectionalLight
        omnidirectionalLightNode.position = TSTConstants.omnidirectionalLightPosition
        
        self.scene.rootNode.addChildNode(omnidirectionalLightNode)
        
        let ambientLight : SCNLight = SCNLight()
        ambientLight.type = SCNLightTypeAmbient
        ambientLight.color = TSTConstants.ambientLightColor
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = ambientLight
        
        self.scene.rootNode.addChildNode(ambientLightNode)
    }
    
    func drawSensorTag()
    {
        let redMaterial : SCNMaterial = SCNMaterial()
        redMaterial.diffuse.contents = UIColor.redColor()
        redMaterial.specular.contents = UIColor.whiteColor()
        
        let blackMaterial : SCNMaterial = SCNMaterial()
        blackMaterial.diffuse.contents = UIColor.blackColor()
        blackMaterial.specular.contents = UIColor.whiteColor()

        let greenMaterial : SCNMaterial = SCNMaterial()
        greenMaterial.diffuse.contents = UIColor(red: 0.0, green: 0.8, blue: 0.0, alpha: 1.0)
        greenMaterial.specular.contents = UIColor.whiteColor()

        let geometry : SCNBox = SCNBox(width: CGFloat(TSTConstants.sensorTagWidth),
                                       height: CGFloat(TSTConstants.sensorTagHeight),
                                       length: CGFloat(TSTConstants.sensorTagDepth),
                                       chamferRadius: 0.4)
        
        geometry.materials = [redMaterial, redMaterial, blackMaterial, redMaterial, redMaterial, blackMaterial]
        
        self.sensorTagNode?.geometry = geometry
        
        
        let cylinder : SCNCylinder = SCNCylinder(radius: 1.0, height: CGFloat(TSTConstants.sensorTagHoleDiameter / 2.0))
        cylinder.materials = [greenMaterial]
        
        let holeNode = SCNNode(geometry: cylinder)
        
        holeNode.position = SCNVector3(0.0, TSTConstants.sensorTagHoleVerticalDisplacement, 1.0)

        holeNode.eulerAngles = SCNVector3(Float(M_PI) / 2.0, 0.0, 0.0)
        
        self.sensorTagNode?.addChildNode(holeNode)
        
        
        
        self.scene.rootNode.addChildNode(self.sensorTagNode!)
    }
    
    func drawAxes()
    {
        let xAxisGeometry : SCNCylinder = SCNCylinder(radius: CGFloat(TSTConstants.axisRadius),
                                                      height: CGFloat(TSTConstants.axisLength))
        
        let xAxisNode = SCNNode(geometry: xAxisGeometry)
        xAxisNode.position = SCNVector3(x: TSTConstants.axisLength / 2.0,
                                        y: 0.0,
                                        z: 0.0)
        
        xAxisNode.rotation = SCNVector4(0.0, 0.0, 1.0, M_PI / 2.0)
        
        self.scene.rootNode.addChildNode(xAxisNode)
        
        
        let yAxisGeometry : SCNCylinder = SCNCylinder(radius: CGFloat(TSTConstants.axisRadius),
                                                      height: CGFloat(TSTConstants.axisLength))
        
        let yAxisNode = SCNNode(geometry: yAxisGeometry)
        yAxisNode.position = SCNVector3(x: 0.0,
                                        y: TSTConstants.axisLength / 2.0,
                                        z: 0.0)
        
        self.scene.rootNode.addChildNode(yAxisNode)
        
        
        let zAxisGeometry : SCNCylinder = SCNCylinder(radius: CGFloat(TSTConstants.axisRadius),
                                                      height: CGFloat(TSTConstants.axisLength))
        
        let zAxisNode = SCNNode(geometry: zAxisGeometry)
        zAxisNode.position = SCNVector3(x: 0.0,
                                        y: 0.0,
                                        z: TSTConstants.axisLength / 2.0)
        
        zAxisNode.rotation = SCNVector4(1.0, 0.0, 0.0, M_PI / 2.0)
        
        self.scene.rootNode.addChildNode(zAxisNode)
    }
}

    
    
    
    













