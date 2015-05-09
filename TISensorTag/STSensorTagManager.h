//
//  STSensorTagManager.h
//  TISensorTag
//
//  Created by Andre Muis on 11/14/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import <Foundation/Foundation.h>

#import "STSensorTagDelegate.h"
#import "STSensorTagManagerDelegate.h"

@interface STSensorTagManager : NSObject

@property (nonatomic, assign) STVersion version;

- (id)initWithDelegate: (id<STSensorTagManagerDelegate>)delegate
     sensorTagDelegate: (id<STSensorTagDelegate>)sensorTagDelegate;

- (void)enableSensors;
- (void)disableSensors;

@end
