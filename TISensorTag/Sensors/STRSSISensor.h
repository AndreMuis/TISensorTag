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

- (id)initWithSensorTagDelegate: (id<STSensorTagDelegate>)sensorTagDelegate
            sensorTagPeripheral: (CBPeripheral *)sensorTagPeripheral;

- (void)enable;
- (void)sensorTagPeripheralDidUpdateRSSI;
- (void)updateWithTimerIntervalInMilliseconds: (int)timerIntervalInMilliseconds;
- (void)disable;

@end
