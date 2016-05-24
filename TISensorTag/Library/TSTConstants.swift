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
    static let mainViewBackgroundColor : UIColor = UIColor.whiteColor()
 
    static let centralManagerPoweredOnTextColor  : UIColor = UIColor.blueColor()

    struct RSSIBarGaugeView
    {
        static let backgroundColor : UIColor = UIColor(red: 0.75, green: 1.0, blue: 0.75, alpha: 1.0)
        static let indicatorColor : UIColor = UIColor.greenColor()
    }
    
    struct MagneticFieldStrengthBarGaugeView
    {
        static let backgroundColor : UIColor = UIColor(red: 0.75, green: 0.75, blue: 1.0, alpha: 1.0)
        static let indicatorColor : UIColor = UIColor.blueColor()
    }

    static let messagesTextViewBackgroundColor : UIColor = UIColor(white: 0.95, alpha: 1.0)

    struct OmnidirectionalLight
    {
        static let color : UIColor = UIColor.init(white: 0.85, alpha: 1.0)
        static let position : SCNVector3 = SCNVector3(x: 10.0, y: 10.0, z: 10.0)
    }
    
    struct AmbientLight
    {
        static let color : UIColor = UIColor(white: 0.6, alpha: 1.0)
    }
    
    struct SensorTag
    {
        private static let widthInMm : Float = 39.0
        private static let heightInMm : Float = 67.0
        private static let depthInMm : Float = 16.0
        
        private static let holeDiameterInMm : Float = 13.0
        private static let holeVerticalDisplacementInMm : Float = 4.0
        
        static let baseColor : UIColor = UIColor.blackColor()
        static let coverColor : UIColor = UIColor.redColor()
        static let holeColor : UIColor = UIColor(red: 0.0, green: 0.8, blue: 0.0, alpha: 1.0)
    }
    
    static let rssiUpdateIntervalInSeconds : NSTimeInterval = 1.0
    
    struct Accelerometer
    {
        static let measurementPeriodInMilliseconds : Int = 100
        static let lowPassFilteringFactor : Float = 0.5
    
        static let measurementVariance : Float = 0.06
    }
    
    struct BarometricPressureSensor
    {
        static let measurementPeriodInMilliseconds : Int = 1000
    }
    
    struct Gyroscope
    {
        static let measurementPeriodInMilliseconds : Int = 100
    }
    
    struct HumiditySensor
    {
        static let measurementPeriodInMilliseconds : Int = 500
    }
    
    struct Magnetometer
    {
        static let measurementPeriodInMilliseconds : Int = 500
    }
    
    struct TemperatureSensor
    {
        static let measurementPeriodInMilliseconds : Int = 500
    }

    struct SimpleKeyView
    {
        static let depressedPercent : CGFloat = 0.35
        static let cornerRadius : CGFloat = 15.0
    }

    struct AngularVelocityView
    {
        static let cameraPosition : SCNVector3 = SCNVector3(x: 0.0, y: 0.0, z: 12.0)
     
        struct SensorTag
        {
            static let eulerAngles : SCNVector3 = SCNVector3(0.0, 0.0, 0.0)
            
            private static let sizeScale : Float = 10.0 * (1.0 / TSTConstants.SensorTag.heightInMm)
            
            static let width : CGFloat = CGFloat(sizeScale * TSTConstants.SensorTag.widthInMm)
            static let height : CGFloat = CGFloat(sizeScale * TSTConstants.SensorTag.heightInMm)
            static let depth : CGFloat = CGFloat(sizeScale * TSTConstants.SensorTag.depthInMm)
            
            static let chamferRadius : CGFloat = 0.4
            
            static let holeDiameter : CGFloat = CGFloat(sizeScale * TSTConstants.SensorTag.holeDiameterInMm)
            static let holeVerticalDisplacement : CGFloat = CGFloat(sizeScale * TSTConstants.SensorTag.holeVerticalDisplacementInMm)
        }
    
        static let measurementScale : Float = 0.06
    }

    struct AccelerationView
    {
        static let cameraPosition : SCNVector3 = SCNVector3(x: 13.0, y: 13.0, z: 13.0)
    
        struct SensorTag
        {
            static let eulerAngles : SCNVector3 = SCNVector3(-Float(M_PI / 2.0), 0.0, 0.0)
            
            private static let sizeScale : Float = 8.0 * (1.0 / TSTConstants.SensorTag.heightInMm)
            
            static let width : CGFloat = CGFloat(sizeScale * TSTConstants.SensorTag.widthInMm)
            static let height : CGFloat = CGFloat(sizeScale * TSTConstants.SensorTag.heightInMm)
            static let depth : CGFloat = CGFloat(sizeScale * TSTConstants.SensorTag.depthInMm)
            
            static let chamferRadius : CGFloat = 0.3

            static let holeDiameter : CGFloat = CGFloat(sizeScale * TSTConstants.SensorTag.holeDiameterInMm)
            static let holeVerticalDisplacement : CGFloat = CGFloat(sizeScale * TSTConstants.SensorTag.holeVerticalDisplacementInMm)
        }
        
        struct Vector
        {
            static let color : UIColor = UIColor.blueColor()

            static var height : CGFloat
            {
                return self.shaftHeight + self.headHeight
            }

            static let shaftHeight : CGFloat = 7.0
            static let shaftRadius : CGFloat = 1.0
            
            static let headHeight : CGFloat = 3.0
            static let headBottomRadius : CGFloat = 2.0
        }

        static var accelerationLookAtNodeDefaultPosition : SCNVector3
        {
            return SCNVector3(0.0, -2.0 * self.Vector.height, 0.0)
        }
        
        static let measurementScale : Float = 10_000
    }
    
    struct Axis
    {
        static let length : Float = 10.0
        static let radius : Float = 0.5
    }
}













