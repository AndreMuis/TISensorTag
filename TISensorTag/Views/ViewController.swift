//
//  ViewController.swift
//  TISensorTag
//
//  Created by Andre Muis on 5/9/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import CoreBluetooth
import UIKit

import STGTISensorTag

class ViewController : UIViewController, STGCentralManagerDelegate, STGSensorTagDelegate
{
    @IBOutlet weak var centralManagerStateLabel: UILabel!
    @IBOutlet weak var connectionStatusLabel: UILabel!
    @IBOutlet weak var rssiBarGaugeView: STGBarGaugeView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var barometricPressureLabel: UILabel!
    @IBOutlet weak var magneticFieldStrengthBarGaugeView: STGBarGaugeView!
    @IBOutlet weak var messagesTextView: UITextView!

    var centralManager : STGCentralManager!
    var sensorTag : STGSensorTag?
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.centralManager = STGCentralManager(delegate: self)
        self.sensorTag = nil
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.messagesTextView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        self.centralManagerStateLabel.text = self.centralManager.state.desscription
        self.connectionStatusLabel.text = self.centralManager.connectionStatus.rawValue
        
        self.rssiBarGaugeView.setupWithBackgroundColor(UIColor(red: 0.75, green: 1.0, blue: 0.75, alpha: 1.0), indicatorColor: UIColor.greenColor())
    
        self.magneticFieldStrengthBarGaugeView.setupWithBackgroundColor(UIColor(red: 0.75, green: 0.75, blue: 1.0, alpha: 1.0), indicatorColor: UIColor.blueColor())
    }
    
    func scheduleRSSITimer()
    {
        NSTimer.scheduledTimerWithTimeInterval(1.0,
                                               target: self,
                                               selector: #selector(ViewController.readRSSI),
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
            self.centralManager.startScanningForSensorTags()
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
        self.sensorTag!.accelerometer.enable(measurementPeriodInMilliseconds: 300, lowPassFilteringFactor: 0.2)
    }
    
    func sensorTag(sensorTag: STGSensorTag, didDiscoverCharacteristicsForBarometricPressureSensor sensor: STGBarometricPressureSensor)
    {
        self.sensorTag!.barometricPressureSensor.enable(measurementPeriodInMilliseconds: 300)
    }
    
    func sensorTag(sensorTag: STGSensorTag, didDiscoverCharacteristicsForGyroscope gyroscope: STGGyroscope)
    {
        self.sensorTag!.gyroscope.enable(measurementPeriodInMilliseconds: 300)
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
    }
    
    func sensorTag(sensorTag: STGSensorTag, didUpdateBarometricPressure pressure: Int)
    {
        self.barometricPressureLabel.text = "\(pressure) millibars"
    }
    
    func sensorTag(sensorTag: STGSensorTag, didUpdateAngularVelocity angularVelocity: STGVector)
    {
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
            print("simple keys state = \(someState.desscription)")
        }
    }
    
    func sensorTag(sensorTag: STGSensorTag, didUpdateAmbientTemperature temperature: STGTemperature)
    {
        self.temperatureLabel.text = "\(temperature.fahrenheit.format(".1")) \u{00B0}C"
    }
    
    func sensorTag(sensorTag: STGSensorTag, didEncounterError error: NSError)
    {
        print(error)
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



















