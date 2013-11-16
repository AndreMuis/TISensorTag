//
//  STButtonSensor.m
//  TISensorTag
//
//  Created by Andre Muis on 11/15/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "STButtonSensor.h"

#import "STConstants.h"

@interface STButtonSensor ()

@property CBPeripheral *sensorTagPeripheral;

@end

@implementation STButtonSensor

- (id)initWithSensorTagPeripheral: (CBPeripheral *)sensorTagPeripheral
{
    self = [super init];
    
    if (self)
    {
        _sensorTagPeripheral = sensorTagPeripheral;
        
        _dataCharacteristicUUID = [CBUUID UUIDWithString: STButtonSensorDataCharacteristicUUIDString];
        _dataCharacteristic = nil;
    }
    
    return self;
}

- (BOOL)configured
{
    if (self.dataCharacteristic != nil)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)update
{
    [self.sensorTagPeripheral setNotifyValue: YES
                           forCharacteristic: self.dataCharacteristic];
}

- (int)buttonPressedWithCharacteristicValue: (NSData *)characteristicValue
{
    char scratchVal[characteristicValue.length];
    [characteristicValue getBytes: &scratchVal length: characteristicValue.length];

    switch ((int)scratchVal[0])
    {
        case 0:
            return STButtonNone;
            break;
            
        case 1:
            return STButtonRight;
            break;
        
        case 2:
            return STButtonLeft;
            break;

        default:
            NSLog(@"Button with characteristic value %@ not handled.", characteristicValue);
            return STButtonUnknown;
            break;
    }
}

@end


























