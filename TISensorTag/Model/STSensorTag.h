//
//  STSensorTag.h
//  TISensorTag
//
//  Created by Andre Muis on 11/14/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import <Foundation/Foundation.h>

#import "STSensorTagDelegate.h"

@class STAccelerometer;
@class STButtonSensor;
@class STGyroscope;
@class STMagnetometer;
@class STRSSISensor;
@class STTemperatureSensor;
@class STMovement;

@interface STSensorTag : NSObject

@property (readonly, strong, nonatomic) STAccelerometer *accelerometer;
@property (readonly, strong, nonatomic) STButtonSensor *buttonSensor;
@property (readonly, strong, nonatomic) STGyroscope *gyroscope;
@property (readonly, strong, nonatomic) STMagnetometer *magnetometer;
@property (readonly, strong, nonatomic) STRSSISensor *rssiSensor;
@property (readonly, strong, nonatomic) STTemperatureSensor *temperatureSensor;
@property (readonly, strong, nonatomic) STMovement *movement;

- (id)initWithDelegate: (id<STSensorTagDelegate>)delegate
   sensorTagPeripheral: (CBPeripheral *)sensorTagPeripheral;

- (void)enableSensors;
- (void)disableSensors;

@end
