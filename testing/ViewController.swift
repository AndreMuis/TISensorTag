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

class ViewController: UIViewController, STGCentralManagerDelegate
{
    var centralManager : STGCentralManager!
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.centralManager = STGCentralManager(delegate: self)
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
                try self.centralManager.startScanningForPeripherals()
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
    
    func centralManager(central: STGCentralManager, didConnectPeripheral peripheral: CBPeripheral)
    {
        print("connected")
    }
    
    func centralManager(central: STGCentralManager, didDisconnectPeripheral peripheral: CBPeripheral)
    {
        print("disconnected")
    }
}

