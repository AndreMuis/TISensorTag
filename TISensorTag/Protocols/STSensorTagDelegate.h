//
//  STSensorTagDelegate.h
//  TISensorTag
//
//  Created by Andre Muis on 11/14/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

#import "STAcceleration.h"
#import "STAngularVelocity.h"
#import "STButtonSensor.h"

@protocol STSensorTagDelegate <NSObject>

@required
- (void)sensorTagDidUpdateAcceleration: (STAcceleration *)acceleration;
- (void)sensorTagDidUpdateButtonPressed: (STButton)button;
- (void)sensorTagDidUpdateAngularVelocity: (STAngularVelocity *)angularVelocity;
- (void)sensorTagDidUpdateMagneticFieldStrength: (float)magneticFieldStrength;
- (void)sensorTagDidUpdateRSSI: (NSNumber *)rssi;
- (void)sensorTagDidUpdateTemperature: (float)temperature;

@end

