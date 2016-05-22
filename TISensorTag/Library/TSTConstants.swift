//
//  TSTConstants.swift
//  TISensorTag
//
//  Created by Andre Muis on 5/17/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import SceneKit

struct TSTConstants
{
    static let cameraPosition : SCNVector3 = SCNVector3(x: 0.0, y: 0.0, z: 12.0)
    
    static let omnidirectionalLightColor : UIColor = UIColor.init(white: 0.85, alpha: 1.0)
    static let omnidirectionalLightPosition : SCNVector3 = SCNVector3(x: 10.0, y: 10.0, z: 10.0)
    
    static let ambientLightColor : UIColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
    
    private static let sensorTagWidthInMm : Float = 39.0
    private static let sensorTagHeightInMm : Float = 67.0
    private static let sensorTagDepthInMm : Float = 16.0
    private static let sensorTagHoleDiameterInMm : Float = 13.0
    private static let sensorTagHoleVerticalDisplacementInMm : Float = 4.0
    
    private static let sensorTagSizeScale : Float = 10.0 * (1.0 / sensorTagHeightInMm)
    
    static let sensorTagWidth : Float = sensorTagSizeScale * sensorTagWidthInMm
    static let sensorTagHeight : Float = sensorTagSizeScale * sensorTagHeightInMm
    static let sensorTagDepth : Float = sensorTagSizeScale * sensorTagDepthInMm
    static let sensorTagHoleDiameter : Float = sensorTagSizeScale * sensorTagHoleDiameterInMm
    static let sensorTagHoleVerticalDisplacement : Float = sensorTagSizeScale * sensorTagHoleVerticalDisplacementInMm
    
    static let axisLength : Float = 10.0
    static let axisRadius : Float = 0.5
    
    
    struct SimpleKey
    {
        static let depressedPercent : CGFloat = 0.35
        static let cornerRadius : CGFloat = 15.0
    }
}

