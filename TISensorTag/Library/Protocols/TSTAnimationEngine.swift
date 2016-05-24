//
//  TSTAnimationEngine.swift
//  TISensorTag
//
//  Created by Andre Muis on 5/22/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import SceneKit

protocol TSTAnimationEngine
{
    var scene : SCNScene {get}
    var sensorTagNode : SCNNode {get}
    
    func addCamera(position position : SCNVector3)
    
    func addLights(ambientLightColor ambientLightColor : UIColor,
                                     omnidirectionalLightColor : UIColor,
                                     omnidirectionalLightPosition : SCNVector3)
    
    func addSensorTag(eulerAngles eulerAngles : SCNVector3,
                                  width : CGFloat,
                                  height : CGFloat,
                                  depth : CGFloat,
                                  chamferRadius : CGFloat,
                                  holeDiameter : CGFloat,
                                  holeVerticalDisplacement : CGFloat,
                                  coverColor : UIColor,
                                  baseColor : UIColor,
                                  holeColor : UIColor)

    func addAxes(axisLength axisLength : Float, axisRadius : Float)
}

