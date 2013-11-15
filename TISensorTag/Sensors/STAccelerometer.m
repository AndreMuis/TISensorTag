//
//  STAccelerometer.m
//  TISensorTag
//
//  Created by Andre Muis on 11/14/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#define KXTJ9_RANGE 4.0

#import "STAccelerometer.h"

@interface STAccelerometer ()

@property CBPeripheral *sensorTagPeripheral;

@end

@implementation STAccelerometer

- (id)initWithSensorTagPeripheral: (CBPeripheral *)sensorTagPeripheral
{
    self = [super init];
    
    if (self)
    {
        _sensorTagPeripheral = sensorTagPeripheral;
        
        _dataCharacteristicUUID = [CBUUID UUIDWithString: @"f000aa11-0451-4000-B000-000000000000"];
        _dataCharacteristic = nil;
        
        _configurationCharacteristicUUID = [CBUUID UUIDWithString: @"f000aa12-0451-4000-B000-000000000000"];
        _configurationCharacteristic = nil;
        
        _periodCharacteristicUUID = [CBUUID UUIDWithString: @"f000aa13-0451-4000-b000-000000000000"];
        _periodCharacteristic = nil;
    }
    
    return self;
}

- (BOOL)configured
{
    if (self.dataCharacteristic != nil &&
        self.configurationCharacteristic != nil &&
        self.periodCharacteristic != nil)
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
    uint8_t periodData = (uint8_t)(500 / 10);
    [self.sensorTagPeripheral writeValue: [NSData dataWithBytes: &periodData length: 1]
                       forCharacteristic: self.periodCharacteristic
                                    type: CBCharacteristicWriteWithResponse];

    uint8_t data = 0x01;
    [self.sensorTagPeripheral writeValue: [NSData dataWithBytes: &data length: 1]
                       forCharacteristic: self.configurationCharacteristic
                                    type: CBCharacteristicWriteWithResponse];
 
    [self.sensorTagPeripheral setNotifyValue: YES
                           forCharacteristic: self.dataCharacteristic];
}

- (float)xAccelerationWithCharacteristicValue: (NSData *)characteristicValue
{
    char scratchVal[characteristicValue.length];
    [characteristicValue getBytes: &scratchVal length: 3];
    
    return ((scratchVal[0] * 1.0) / (256 / KXTJ9_RANGE));
}
@end


















