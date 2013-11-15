//
//  STTemperatureSensor.h
//  TISensorTag
//
//  Created by Andre Muis on 11/14/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import <Foundation/Foundation.h>

#import "STSensor.h"

@interface STTemperatureSensor : STSensor

@property (readonly, strong, nonatomic) CBUUID *dataCharacteristicUUID;
@property (readwrite, strong, nonatomic) CBCharacteristic *dataCharacteristic;

@property (readonly, strong, nonatomic) CBUUID *configurationCharacteristicUUID;
@property (readwrite, strong, nonatomic) CBCharacteristic *configurationCharacteristic;

@property (readonly, assign, nonatomic) BOOL configured;

- (id)initWithSensorTagPeripheral: (CBPeripheral *)sensorTagPeripheral;

- (void)update;

- (float)temperatureWithCharacteristicValue: (NSData *)characteristicValue;

@end
