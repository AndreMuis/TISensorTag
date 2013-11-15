//
//  STSensorTagManager.h
//  TISensorTag
//
//  Created by Andre Muis on 11/14/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import <Foundation/Foundation.h>

#import "STSensorTagManagerDelegate.h"

@interface STSensorTagManager : NSObject

- (id)initWithDelegate: (id<STSensorTagManagerDelegate>)delegate;

@end
