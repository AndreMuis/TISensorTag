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
    @IBOutlet weak var magneticFieldStrengthBarGaugeView: TSTBarGaugeView!
    @IBOutlet weak var leftKeyView: TSTSimpleKeyView!
    @IBOutlet weak var rightKeyView: TSTSimpleKeyView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var barometricPressureLabel: UILabel!
    @IBOutlet weak var messagesTextView: UITextView!

    var centralManager : STGCentralManager!
    var sensorTag : STGSensorTag?

    var angularVelocityViewController : TSTAngularVelocityViewController?
    var accelerationViewController : TSTAccelerationViewController?

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.centralManager = STGCentralManager(delegate: self)
        self.sensorTag = nil
        
        self.angularVelocityViewController = nil
        self.accelerationViewController = nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let viewController = segue.destinationViewController as? TSTAngularVelocityViewController
        {
            self.angularVelocityViewController = viewController
        }
        else if let viewController = segue.destinationViewController as? TSTAccelerationViewController
        {
            self.accelerationViewController = viewController
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = TSTConstants.mainViewBackgroundColor
        
        self.messagesTextView.backgroundColor = TSTConstants.messagesTextViewBackgroundColor
        
        self.centralManagerStateLabel.text = self.centralManager.state.desscription
        self.connectionStatusLabel.text = self.centralManager.connectionStatus.rawValue
        
        self.rssiBarGaugeView.setup(backgroundColor: TSTConstants.RSSIBarGaugeView.backgroundColor,
                                    indicatorColor: TSTConstants.RSSIBarGaugeView.indicatorColor)
    
        self.magneticFieldStrengthBarGaugeView.setup(backgroundColor: TSTConstants.MagneticFieldStrengthBarGaugeView.backgroundColor,
                                                     indicatorColor: TSTConstants.MagneticFieldStrengthBarGaugeView.indicatorColor)
        
        self.leftKeyView.setup()
        self.rightKeyView.setup()
        
        self.resetUI()
    }
    
    func scheduleRSSITimer()
    {
        NSTimer.scheduledTimerWithTimeInterval(TSTConstants.rssiUpdateIntervalInSeconds,
                                               target: self,
                                               selector: #selector(TSTMainViewController.readRSSI),
                                               userInfo: nil,
                                               repeats: false)
    }
    
    func readRSSI()
    {
        if let sensorTag : STGSensorTag = self.sensorTag
        {
            sensorTag.readRSSI()
        }
    }

    // MARK: STGCentralManagerDelegate
    
    func centralManagerDidUpdateState(state: STGCentralManagerState)
    {
        self.centralManagerStateLabel.text = state.desscription
        
        if (state == STGCentralManagerState.PoweredOn)
        {
            self.centralManagerStateLabel.textColor = TSTConstants.centralManagerPoweredOnTextColor
            
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
        let sensorTag : STGSensorTag = STGSensorTag(delegate: self, peripheral: peripheral)
        
        self.sensorTag = sensorTag

        self.scheduleRSSITimer()
        
        sensorTag.discoverServices()
    }
    
    func centralManager(central: STGCentralManager, didDisconnectSensorTagPeripheral peripheral: CBPeripheral)
    {
        self.sensorTag = nil
        self.resetUI()
    }
    
    func centralManager(central: STGCentralManager, didEncounterError error: NSError)
    {
        if error.domain == CBErrorDomain && error.code == CBError.PeripheralDisconnected.rawValue
        {
            self.sensorTag = nil
            self.resetUI()        
        }
        
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
        sensorTag.accelerometer.enable(measurementPeriodInMilliseconds: TSTConstants.Accelerometer.measurementPeriodInMilliseconds,
                                       lowPassFilteringFactor: TSTConstants.Accelerometer.lowPassFilteringFactor)
    }
    
    func sensorTag(sensorTag: STGSensorTag, didDiscoverCharacteristicsForBarometricPressureSensor sensor: STGBarometricPressureSensor)
    {
        sensorTag.barometricPressureSensor.enable(measurementPeriodInMilliseconds: TSTConstants.BarometricPressureSensor.measurementPeriodInMilliseconds)
    }
    
    func sensorTag(sensorTag: STGSensorTag, didDiscoverCharacteristicsForGyroscope gyroscope: STGGyroscope)
    {
        sensorTag.gyroscope.enable(measurementPeriodInMilliseconds: TSTConstants.Gyroscope.measurementPeriodInMilliseconds)
    }   
    
    func sensorTag(sensorTag: STGSensorTag, didDiscoverCharacteristicsForHumiditySensor humiditySensor: STGHumiditySensor)
    {
        sensorTag.humiditySensor.enable(measurementPeriodInMilliseconds: TSTConstants.HumiditySensor.measurementPeriodInMilliseconds)
    }
    
    func sensorTag(sensorTag: STGSensorTag, didDiscoverCharacteristicsForMagnetometer magnetometer: STGMagnetometer)
    {
        sensorTag.magnetometer.enable(measurementPeriodInMilliseconds: TSTConstants.Magnetometer.measurementPeriodInMilliseconds)
    }
    
    func sensorTag(sensorTag: STGSensorTag, didDiscoverCharacteristicsForSimpleKeysService simpleKeysService: STGSimpleKeysService)
    {
        sensorTag.simpleKeysService.enable()
    }
    
    func sensorTag(sensorTag: STGSensorTag, didDiscoverCharacteristicsForTemperatureSensor temperatureSensor: STGTemperatureSensor)
    {
        sensorTag.temperatureSensor.enable(measurementPeriodInMilliseconds: TSTConstants.TemperatureSensor.measurementPeriodInMilliseconds)
    }
    
    
    func sensorTag(sensorTag: STGSensorTag, didUpdateAcceleration acceleration: STGVector)
    {
    }
    
    func sensorTag(sensorTag: STGSensorTag, didUpdateSmoothedAcceleration acceleration: STGVector)
    {
        if let viewController : TSTAccelerationViewController = self.accelerationViewController
        {
            viewController.didUpdateSmoothedAcceleration(acceleration: acceleration)
        }
    }
    
    func sensorTag(sensorTag: STGSensorTag, didUpdateBarometricPressure pressure: Int)
    {
        self.displayBarometricPressure(pressure)
    }
    
    func sensorTag(sensorTag: STGSensorTag, didUpdateAngularVelocity angularVelocity: STGVector)
    {
        if let viewController : TSTAngularVelocityViewController = self.angularVelocityViewController
        {
            viewController.didUpdateAngularVelocity(angularVelocity: angularVelocity)
        }
    }
    
    func sensorTag(sensorTag: STGSensorTag, didUpdateRelativeHumidity relativeHumidity: Float)
    {
        self.displayRelativeHumidity(relativeHumidity)
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
        self.displayAmbientTemperature(temperature)
    }
    
    func sensorTag(sensorTag: STGSensorTag, didEncounterError error: NSError)
    {
        addMessage(error.description)
    }
    
    // MARK:
    
    func resetUI()
    {
        self.rssiBarGaugeView.normalizedReading = 0.0
        
        if let viewController : TSTAngularVelocityViewController = self.angularVelocityViewController
        {
            viewController.resetUI()
        }

        if let viewController : TSTAccelerationViewController = self.accelerationViewController
        {
            viewController.resetUI()
        }

        self.magneticFieldStrengthBarGaugeView.normalizedReading = 0.0
    
        self.leftKeyView.depress()
        self.rightKeyView.depress()

        self.displayAmbientTemperature(nil)
        self.displayRelativeHumidity(nil)
        self.displayBarometricPressure(nil)
    }
    
    func displayAmbientTemperature(ambientTemperature : STGTemperature?)
    {
        if let temperature = ambientTemperature
        {
            self.temperatureLabel.text = "\(temperature.fahrenheit.format(".1")) \u{00B0}F"
        }
        else
        {
            self.temperatureLabel.text = "? \u{00B0}F"
        }
    }
    
    func displayRelativeHumidity(relativeHumidity: Float?)
    {
        if let humidity = relativeHumidity
        {
            self.humidityLabel.text = "\(humidity.format(".0"))%"
        }
        else
        {
            self.humidityLabel.text = "? %"
        }
    }
    
    func displayBarometricPressure(barometricPressure: Int?)
    {
        if let pressure = barometricPressure
        {
            self.barometricPressureLabel.text = String(pressure)
        }
        else
        {
            self.barometricPressureLabel.text = "?"
        }
    }
    
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
        
        let bottom : NSRange = NSMakeRange(self.messagesTextView.text.characters.count - 1, 1)
        self.messagesTextView.scrollRangeToVisible(bottom)
    }
}



















