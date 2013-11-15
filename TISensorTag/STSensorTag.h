//
//  STSensorTag.h
//  TISensorTag
//
//  Created by Andre Muis on 11/14/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import <Foundation/Foundation.h>

@class STAccelerometer;
@class STTemperatureSensor;

@interface STSensorTag : NSObject

@property (readonly, strong, nonatomic) STAccelerometer *accelerometer;
@property (readonly, strong, nonatomic) STTemperatureSensor *temperatureSensor;

- (id)initWithSensorTagPeripheral: (CBPeripheral *)sensorTagPeripheral;

- (void)disconnect;

@end
