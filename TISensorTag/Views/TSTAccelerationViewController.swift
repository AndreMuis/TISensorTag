//
//  TSTAccelerationViewController.swift
//  TISensorTag
//
//  Created by Andre Muis on 5/20/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import SceneKit
import UIKit

import STGTISensorTag

class TSTAccelerationViewController : UIViewController
{
    @IBOutlet weak var sceneView: SCNView!
    
    let animationEngine : TSTAccelerationAnimationEngine

    var previousAcceleration : STGVector

    required init?(coder aDecoder: NSCoder)
    {
        self.animationEngine = TSTAccelerationAnimationEngine()

        self.previousAcceleration = STGVector(x: 0.0, y: 0.0, z: 0.0)

        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.sceneView.scene = self.animationEngine.scene
        
        self.animationEngine.addLights(ambientLightColor: TSTConstants.AmbientLight.color,
                                       omnidirectionalLightColor: TSTConstants.OmnidirectionalLight.color,
                                       omnidirectionalLightPosition: TSTConstants.OmnidirectionalLight.position)
        
        self.animationEngine.addCamera(position: TSTConstants.AccelerationView.cameraPosition)
        
        self.animationEngine.self.addSensorTag(eulerAngles: TSTConstants.AccelerationView.SensorTag.eulerAngles,
                                               width: TSTConstants.AccelerationView.SensorTag.width,
                                               height: TSTConstants.AccelerationView.SensorTag.height,
                                               depth: TSTConstants.AccelerationView.SensorTag.depth,
                                               chamferRadius: TSTConstants.AccelerationView.SensorTag.chamferRadius,
                                               holeDiameter: TSTConstants.AccelerationView.SensorTag.holeDiameter,
                                               holeVerticalDisplacement: TSTConstants.AccelerationView.SensorTag.holeVerticalDisplacement,
                                               coverColor: TSTConstants.SensorTag.coverColor,
                                               baseColor: TSTConstants.SensorTag.baseColor,
                                               holeColor: TSTConstants.SensorTag.holeColor)
        
        self.animationEngine.addVector(color: TSTConstants.AccelerationView.Vector.color,
                                       shaftHeight: TSTConstants.AccelerationView.Vector.shaftHeight,
                                       shaftRadius: TSTConstants.AccelerationView.Vector.shaftRadius,
                                       headHeight: TSTConstants.AccelerationView.Vector.headHeight,
                                       headBottomRadius: TSTConstants.AccelerationView.Vector.headBottomRadius)
    }
    
    func resetUI()
    {
        self.animationEngine.accelerationLookAtNode.position = TSTConstants.AccelerationView.accelerationLookAtNodeDefaultPosition
    }
    
    func didUpdateSmoothedAcceleration(acceleration acceleration: STGVector)
    {
        let xDelta = acceleration.x - self.previousAcceleration.x
        let yDelta = acceleration.y - self.previousAcceleration.y
        let zDelta = acceleration.z - self.previousAcceleration.z
        
        let scale : Float = TSTConstants.AccelerationView.measurementScale
        
        var position : SCNVector3 = self.animationEngine.accelerationLookAtNode.position
        
        if fabs(zDelta) > TSTConstants.Accelerometer.measurementVariance / 2.0
        {
            position.y = acceleration.z * scale
        }
        
        if fabs(xDelta) > TSTConstants.Accelerometer.measurementVariance / 2.0
        {
            position.x = -acceleration.x * scale
        }
        
        if fabs(yDelta) > TSTConstants.Accelerometer.measurementVariance / 2.0
        {
            position.z = acceleration.y * scale
        }
        
        if position.magnitude > Float(TSTConstants.AccelerationView.Vector.height)
        {
            self.animationEngine.accelerationLookAtNode.position = position
        }
        
        self.previousAcceleration = acceleration
    }
}



















