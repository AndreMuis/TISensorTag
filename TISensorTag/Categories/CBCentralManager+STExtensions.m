//
//  CBCentralManager+STExtensions.m
//  TISensorTag
//
//  Created by Andre Muis on 11/14/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "CBCentralManager+STExtensions.h"

@implementation CBCentralManager (STExtensions)

- (NSString *)stateAsString
{
    switch (self.state)
    {
        case CBCentralManagerStateUnknown:
            return @"unknown";
            break;
            
        case CBCentralManagerStateResetting:
            return @"resetting";
            break;
            
        case CBCentralManagerStateUnsupported:
            return @"unsupported";
            break;
            
        case CBCentralManagerStateUnauthorized:
            return @"unauthorized";
            break;
            
        case CBCentralManagerStatePoweredOff:
            return @"powered off";
            break;
            
        case CBCentralManagerStatePoweredOn:
            return @"powered on";
            break;
            
        default:
            NSLog(@"Unhandled central manager state: %d", (int)self.state);
            return @"";
            break;
    }
}

@end
