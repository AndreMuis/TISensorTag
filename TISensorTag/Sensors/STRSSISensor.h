//
//  STRSSISensor.h
//  TISensorTag
//
//  Created by Andre Muis on 11/16/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STSensor.h"
#import "STSensorTagDelegate.h"

@interface STRSSISensor : STSensor

@property (readonly, assign, nonatomic) BOOL configured;
@property (readwrite, assign, nonatomic) BOOL enabled;

- (id)initWithSensorTagDelegate: (id<STSensorTagDelegate>)sensorTagDelegate
            sensorTagPeripheral: (CBPeripheral *)sensorTagPeripheral;

- (void)sensorTagPeripheralDidUpdateRSSI;
- (void)updateWithTimerIntervalInMilliseconds: (int)timerIntervalInMilliseconds;

@end
