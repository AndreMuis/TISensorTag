//
//  STMovement.h
//  TISensorTag
//
//  Created by Michael Terry on 5/9/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import <Foundation/Foundation.h>

#import "STSensor.h"
#import "STSensorTagDelegate.h"

@class STMovement;

@interface STMovement : STSensor

@property (readonly, strong, nonatomic) CBUUID *dataCharacteristicUUID;
@property (readwrite, strong, nonatomic) CBCharacteristic *dataCharacteristic;

@property (readonly, strong, nonatomic) CBUUID *configurationCharacteristicUUID;
@property (readwrite, strong, nonatomic) CBCharacteristic *configurationCharacteristic;

@property (readonly, strong, nonatomic) CBUUID *periodCharacteristicUUID;
@property (readwrite, strong, nonatomic) CBCharacteristic *periodCharacteristic;

@property (readonly, assign, nonatomic) BOOL configured;
@property (readwrite, assign, nonatomic) BOOL enabled;

- (id)initWithSensorTagDelegate: (id<STSensorTagDelegate>)sensorTagDelegate
            sensorTagPeripheral: (CBPeripheral *)sensorTagPeripheral;

- (void)sensorTagPeripheralDidUpdateValueForCharacteristic: (CBCharacteristic *)characteristic;
- (void)updateWithPeriodInMilliseconds: (int)periodInMilliseconds;

//- (STAcceleration *)accelerationWithCharacteristicValue: (NSData *)characteristicValue;
//- (STAcceleration *)accelerationWithCharacteristicValue: (uint8_t*)scratchVal;
//- (STAcceleration *)smoothedAccelerationWithCharacteristicValue: (NSData *)characteristicValue;

@end