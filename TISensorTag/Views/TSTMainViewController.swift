//
//  TSTViewController.swift
//  TISensorTag
//
//  Created by Andre Muis on 5/9/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import CoreBluetooth
import SceneKit
import UIKit

import STGTISensorTag

class TSTMainViewController : UIViewController, STGCentralManagerDelegate, STGSensorTagDelegate
{
    @IBOutlet weak var centralManagerStateLabel: UILabel!
    @IBOutlet weak var connectionStatusLabel: UILabel!
    @IBOutlet weak var rssiBarGaugeView: TSTBarGaugeView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var barometricPressureLabel: UILabel!
    @IBOutlet weak var magneticFieldStrengthBarGaugeView: TSTBarGaugeView!
    @IBOutlet weak var leftKeyView: TSTSimpleKeyView!
    @IBOutlet weak var rightKeyView: TSTSimpleKeyView!
    @IBOutlet weak var messagesTextView: UITextView!

    var centralManager : STGCentralManager!
    var sensorTag : STGSensorTag?

    var sensorTagNode : SCNNode?
    var accelerationNode : SCNNode?
    
    var previousAcceleration : STGVector!
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.centralManager = STGCentralManager(delegate: self)
        self.sensorTag = nil
        
        self.sensorTagNode = nil
        
        self.previousAcceleration = STGVector(x: 0.0, y: 0.0, z: 0.0)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let viewController = segue.destinationViewController as? TSTAngularVelocityViewController
        {
            self.sensorTagNode = viewController.sensorTagNode
        }
        else if let viewController = segue.destinationViewController as? TSTAccelerationViewController
        {
            self.accelerationNode = viewController.accelerationNode
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.messagesTextView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        self.centralManagerStateLabel.text = self.centralManager.state.desscription
        self.connectionStatusLabel.text = self.centralManager.connectionStatus.rawValue
        
        self.rssiBarGaugeView.setupWithBackgroundColor(UIColor(red: 0.75, green: 1.0, blue: 0.75, alpha: 1.0), indicatorColor: UIColor.greenColor())
    
        //self.temperatureLabel.text = "? \u{00B0}F"
        
        //self.humidityLabel.text = "? %"

        //self.barometricPressureLabel.text = "?"
        
        self.leftKeyView.setup()
        self.rightKeyView.setup()
        
        self.magneticFieldStrengthBarGaugeView.setupWithBackgroundColor(UIColor(red: 0.75, green: 0.75, blue: 1.0, alpha: 1.0), indicatorColor: UIColor.blueColor())
    }
    
    func scheduleRSSITimer()
    {
        NSTimer.scheduledTimerWithTimeInterval(1.0,
                                               target: self,
                                               selector: #selector(TSTMainViewController.readRSSI),
                                               userInfo: nil,
                                               repeats: false)
    }
    
    func readRSSI()
    {
        self.sensorTag!.readRSSI()
    }

    // MARK: STGCentralManagerDelegate
    
    func centralManagerDidUpdateState(state: STGCentralManagerState)
    {
        self.centralManagerStateLabel.text = state.desscription
        
        if (state == .PoweredOn)
        {
            self.centralManagerStateLabel.textColor = UIColor.blueColor()
            
            self.centralManager.startScanningForSensorTags()
        }
        else
        {
            self.centralManagerStateLabel.textColor = UIColor.blackColor()
        }
    }
    
    func centralManagerDidUpdateConnectionStatus(status: STGCentralManagerConnectionStatus)
    {
        self.connectionStatusLabel.text = status.rawValue
    }
    
    func centralManager(central: STGCentralManager, didConnectSensorTagPeripheral peripheral: CBPeripheral)
    {
        self.sensorTag = STGSensorTag(delegate: self, peripheral: peripheral)

        self.scheduleRSSITimer()
        
        self.sensorTag!.discoverServices()
        
        self.addMessage("Connected to SensorTag")
    }
    
    func centralManager(central: STGCentralManager, didDisconnectSensorTagPeripheral peripheral: CBPeripheral)
    {
        self.sensorTag = nil

        self.addMessage("Disconnected from SensorTag")
    }
    
    func centralManager(central: STGCentralManager, didEncounterError error: NSError)
    {
        self.addMessage(error.description)
    }
    
    // MARK: STGSensorTagDelegate
    
    func sensorTag(sensorTag: STGSensorTag, didUpdateRSSI rssi: NSNumber)
    {
        let rssiValue : Float = rssi.floatValue
        
        self.rssiBarGaugeView.normalizedReading = (rssiValue - STGConstants.rssiMinimum) / (STGConstants.rssiMaximum - STGConstants.rssiMinimum)
                
        self.scheduleRSSITimer()
    }
    
    func sensorTag(sensorTag: STGSensorTag, didDiscoverCharacteristicsForAccelerometer accelerometer: STGAccelerometer)
    {
        self.sensorTag!.accelerometer.enable(measurementPeriodInMilliseconds: 100, lowPassFilteringFactor: 0.5)
    }
    
    func sensorTag(sensorTag: STGSensorTag, didDiscoverCharacteristicsForBarometricPressureSensor sensor: STGBarometricPressureSensor)
    {
        self.sensorTag!.barometricPressureSensor.enable(measurementPeriodInMilliseconds: 300)
    }
    
    func sensorTag(sensorTag: STGSensorTag, didDiscoverCharacteristicsForGyroscope gyroscope: STGGyroscope)
    {
        self.sensorTag!.gyroscope.enable(measurementPeriodInMilliseconds: 100)
    }
    
    func sensorTag(sensorTag: STGSensorTag, didDiscoverCharacteristicsForHumiditySensor humiditySensor: STGHumiditySensor)
    {
        self.sensorTag?.humiditySensor.enable(measurementPeriodInMilliseconds: 300)
    }
    
    func sensorTag(sensorTag: STGSensorTag, didDiscoverCharacteristicsForMagnetometer magnetometer: STGMagnetometer)
    {
        self.sensorTag!.magnetometer.enable(measurementPeriodInMilliseconds: 300)
    }
    
    func sensorTag(sensorTag: STGSensorTag, didDiscoverCharacteristicsForSimpleKeysService simpleKeysService: STGSimpleKeysService)
    {
        self.sensorTag!.simpleKeysService.enable()
    }
    
    func sensorTag(sensorTag: STGSensorTag, didDiscoverCharacteristicsForTemperatureSensor temperatureSensor: STGTemperatureSensor)
    {
        self.sensorTag!.temperatureSensor.enable(measurementPeriodInMilliseconds: 300)
    }
    

    
    func sensorTag(sensorTag: STGSensorTag, didUpdateAcceleration acceleration: STGVector)
    {
    }
    
    func sensorTag(sensorTag: STGSensorTag, didUpdateSmoothedAcceleration acceleration: STGVector)
    {
        let xDelta = acceleration.x - self.previousAcceleration.x
        let yDelta = acceleration.y - self.previousAcceleration.y
        let zDelta = acceleration.z - self.previousAcceleration.z
        
        if fabs(zDelta) > 0.03
        {
            accelerationNode?.position.y = acceleration.z * 10000.0
        }
        
        if fabs(xDelta) > 0.03
        {
            accelerationNode?.position.x = -acceleration.x * 10000.0
        }

        if fabs(yDelta) > 0.03
        {
            accelerationNode?.position.z = acceleration.y * 10000.0
        }

        self.previousAcceleration = acceleration
    }
    
    func sensorTag(sensorTag: STGSensorTag, didUpdateBarometricPressure pressure: Int)
    {
        self.barometricPressureLabel.text = String(pressure)
    }
    
    func sensorTag(sensorTag: STGSensorTag, didUpdateAngularVelocity angularVelocity: STGVector)
    {
        self.sensorTagNode?.eulerAngles = SCNVector3(-angularVelocity.y / 1000.0,
                                                     angularVelocity.x / 1000.0,
                                                     angularVelocity.z / 1000.0)
    }
    
    func sensorTag(sensorTag: STGSensorTag, didUpdateRelativeHumidity relativeHumidity: Float)
    {
        self.humidityLabel.text = "\(relativeHumidity.format(".0"))%"
    }
    
    func sensorTag(sensorTag : STGSensorTag, didUpdateMagneticField magneticField : STGVector)
    {
        let minimum : Float = STGConstants.Magnetometer.magneticFieldStrengthMinimum
        let maximum : Float = STGConstants.Magnetometer.magneticFieldStrengthMaximum
        
        self.magneticFieldStrengthBarGaugeView.normalizedReading = (magneticField.magnitude - minimum) / (maximum - minimum)
    }
    
    func sensorTag(sensorTag: STGSensorTag, didUpdateSimpleKeysState state: STGSimpleKeysState?)
    {
        if let someState = state
        {
            switch someState
            {
            case STGSimpleKeysState.NonePressed:
                self.leftKeyView.depress()
                self.rightKeyView.depress()
                
            case STGSimpleKeysState.LeftPressed:
                self.leftKeyView.press()
                self.rightKeyView.depress()
                
            case STGSimpleKeysState.RightPressed:
                self.leftKeyView.depress()
                self.rightKeyView.press()
                
            case STGSimpleKeysState.BothPressed:
                self.leftKeyView.press()
                self.rightKeyView.press()
            }
        }
    }
    
    func sensorTag(sensorTag: STGSensorTag, didUpdateAmbientTemperature temperature: STGTemperature)
    {
        self.temperatureLabel.text = "\(temperature.fahrenheit.format(".1")) \u{00B0}F"
    }
    
    func sensorTag(sensorTag: STGSensorTag, didEncounterError error: NSError)
    {
        addMessage(error.description)
    }
    
    // MARK:
    
    func addMessage(message : String)
    {
        if self.messagesTextView.text.isEmpty == true
        {
            self.messagesTextView.text = self.messagesTextView.text + message
        }
        else
        {
            self.messagesTextView.text = self.messagesTextView.text + "\n\n" + message
        }
        
        if self.messagesTextView.text.isEmpty == false
        {
            let bottom : NSRange = NSMakeRange(self.messagesTextView.text.characters.count - 1, 1)
            self.messagesTextView.scrollRangeToVisible(bottom)
        }
    }
}



















