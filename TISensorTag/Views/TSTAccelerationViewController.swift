//
//  TSTAccelerationViewController.swift
//  TISensorTag
//
//  Created by Andre Muis on 5/20/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import SceneKit
import UIKit

class TSTAccelerationViewController : UIViewController
{
    @IBOutlet weak var sceneView: SCNView!
    
    var scene : SCNScene!
    
    var vectorBaseNode : SCNNode!
    var accelerationNode : SCNNode!

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.scene = SCNScene()
        
        self.vectorBaseNode = SCNNode()
        self.accelerationNode = SCNNode()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.sceneView.scene = self.scene
        
        self.addCamera()
        self.addLights()
        
        self.scene.rootNode.addChildNode(self.accelerationNode)

        self.drawVector()
    }
    
    func addCamera()
    {
        let originNode : SCNNode = SCNNode()
        self.scene.rootNode.addChildNode(originNode)

        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(13.0, 13.0, 13.0)

        cameraNode.constraints = [SCNLookAtConstraint(target: originNode)]
        
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
    
    func drawVector()
    {
        let material : SCNMaterial = SCNMaterial()
        material.diffuse.contents = UIColor.blueColor()
        material.specular.contents = UIColor.whiteColor()
        

        let shaftGeometry : SCNCylinder = SCNCylinder(radius: 1.0,
                                                      height: 7.0)
        shaftGeometry.materials = [material]

        let shaftNode : SCNNode = SCNNode(geometry: shaftGeometry)
        shaftNode.position = SCNVector3(0.0, 7.0 / 2.0, 0.0)
        
        
        let headGeometry : SCNCone = SCNCone(topRadius: 0.0, bottomRadius: 2.0, height: 3.0)
        headGeometry.materials = [material]
        
        let headNode : SCNNode = SCNNode(geometry: headGeometry)
        headNode.position = SCNVector3(0.0, 7.0 / 2.0 + 3.0 / 2.0, 0.0)

        shaftNode.addChildNode(headNode)
        

        let lookAtConstraint : SCNLookAtConstraint = SCNLookAtConstraint(target: self.accelerationNode)
        
        self.vectorBaseNode.constraints = [lookAtConstraint]
        
        
        let tmp : SCNNode = SCNNode()
        tmp.addChildNode(shaftNode)
        
        tmp.eulerAngles = SCNVector3(-Float(M_PI) / 2.0, 0.0, 0.0)

        
        self.vectorBaseNode.addChildNode(tmp)
        
        

        self.scene.rootNode.addChildNode(self.vectorBaseNode)
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



















