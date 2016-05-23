//
//  TSTAngularVelocityViewController.swift
//  TISensorTag
//
//  Created by Andre Muis on 5/17/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import SceneKit
import UIKit

import STGTISensorTag

class TSTAngularVelocityViewController : UIViewController
{
    @IBOutlet weak var sceneView: SCNView!
    
    let animationEngine : TSTAngularVelocityAnimationEngine
    
    required init?(coder aDecoder: NSCoder)
    {
        self.animationEngine = TSTAngularVelocityAnimationEngine()

        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.sceneView.scene = self.animationEngine.scene
        
        self.animationEngine.addCamera(position: TSTConstants.AngularVelocityView.cameraPosition)
        
        self.animationEngine.self.addLights(ambientLightColor: TSTConstants.AmbientLight.color,
                                            omnidirectionalLightColor: TSTConstants.OmnidirectionalLight.color,
                                            omnidirectionalLightPosition: TSTConstants.OmnidirectionalLight.position)
        
        self.animationEngine.self.drawSensorTag(eulerAngles: TSTConstants.AngularVelocityView.sensorTagEulerAngles,
                                                width: TSTConstants.SensorTag.width,
                                                height: TSTConstants.SensorTag.height,
                                                depth: TSTConstants.SensorTag.depth,
                                                chamferRadius: TSTConstants.SensorTag.chamferRadius,
                                                holeDiameter: TSTConstants.SensorTag.holeDiameter,
                                                holeVerticalDisplacement: TSTConstants.SensorTag.holeVerticalDisplacement,
                                                coverColor: TSTConstants.SensorTag.coverColor,
                                                baseColor: TSTConstants.SensorTag.baseColor,
                                                holeColor: TSTConstants.SensorTag.holeColor)
    }
    
    func resetUI()
    {
        self.animationEngine.sensorTagNode.eulerAngles = SCNVector3Zero
    }
    
    func didUpdateAngularVelocity(angularVelocity angularVelocity: STGVector)
    {
        print(angularVelocity)
        
        let scale : Float = TSTConstants.AngularVelocityView.measurementScale
        
        self.animationEngine.sensorTagNode.eulerAngles = SCNVector3(-scale * angularVelocity.y,
                                                                    scale * angularVelocity.x,
                                                                    scale * angularVelocity.z)
    }
}


















