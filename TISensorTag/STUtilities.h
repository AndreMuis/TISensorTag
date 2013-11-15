//
//  STUtilities.h
//  TISensorTag
//
//  Created by Andre Muis on 11/14/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import <Foundation/Foundation.h>

@interface STUtilities : NSObject

+ (NSString *)stringWithCBUUID: (CBUUID *)uuid;

+ (float)farenheitWithCelsius: (float)celsius;

@end
