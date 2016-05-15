//
//  ViewController.swift
//  testing
//
//  Created by Andre Muis on 5/10/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import CoreBluetooth
import UIKit

import STGTISensorTag

class ViewController: UIViewController, STGCentralManagerDelegate, STGSensorTagDelegate
{
    var centralManager : STGCentralManager!
    var sensorTag : STGSensorTag!
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.centralManager = STGCentralManager(delegate: self)
        self.sensorTag = nil
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    func centralManagerDidUpdateState(state: STGCentralManagerState)
    {
        print("STGCentralManagerState = \(state.desscription)")
        
        if (state == .PoweredOn)
        {
            do
            {
                try self.centralManager.startScanningForSensorTags()
            }
            catch let error
            {
                print(error)
            }
        }
    }
    
    func centralManagerDidUpdateConnectionStatus(status: STGCentralManagerConnectionStatus)
    {
        print("STGCentralManagerConnectionStatus = \(status.rawValue)")
    }
    
    func centralManager(central: STGCentralManager, didConnectSensorTagPeripheral peripheral: CBPeripheral)
    {
        print("didConnectSensorTagPeripheral")

        self.sensorTag = STGSensorTag(delegate: self, peripheral: peripheral)
        
        self.sensorTag.discoverServices()
    }
    
    func centralManager(central: STGCentralManager, didDisconnectSensorTagPeripheral peripheral: CBPeripheral)
    {
        print("didDisconnectSensorTagPeripheral")
    }
    
    func sensorTag(sensorTag: STGSensorTag, didDiscoverCharacteristicsForAccelerometer accelerometer: STGAccelerometer)
    {
        accelerometer.enable()
    }
    
    func sensorTag(sensorTag: STGSensorTag, didUpdateAcceleration acceleration: STGVector)
    {
        print(acceleration)
    }
}

























