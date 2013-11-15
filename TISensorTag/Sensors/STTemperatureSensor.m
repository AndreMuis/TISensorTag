//
//  STTemperatureSensor.m
//  TISensorTag
//
//  Created by Andre Muis on 11/14/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "STTemperatureSensor.h"

#import "STUtilities.h"

@interface STTemperatureSensor ()

@property CBPeripheral *sensorTagPeripheral;

@end

@implementation STTemperatureSensor

- (id)initWithSensorTagPeripheral: (CBPeripheral *)sensorTagPeripheral
{
    self = [super init];
    
    if (self)
    {
        _sensorTagPeripheral = sensorTagPeripheral;
        
        _dataCharacteristicUUID = [CBUUID UUIDWithString: @"f000aa01-0451-4000-b000-000000000000"];
        _dataCharacteristic = nil;

        _configurationCharacteristicUUID = [CBUUID UUIDWithString: @"f000aa02-0451-4000-b000-000000000000"];
        _configurationCharacteristic = nil;
    }
    
    return self;
}

- (BOOL)configured
{
    if (self.dataCharacteristic != nil &&
        self.configurationCharacteristic != nil)
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
    uint8_t data = 0x01;
    [self.sensorTagPeripheral writeValue: [NSData dataWithBytes: &data length: 1]
                       forCharacteristic: self.configurationCharacteristic
                                    type: CBCharacteristicWriteWithResponse];
 
    [self.sensorTagPeripheral setNotifyValue: YES
                           forCharacteristic: self.dataCharacteristic];
}

- (float)temperatureWithCharacteristicValue: (NSData *)characteristicValue
{
    char scratchVal[characteristicValue.length];
    int16_t ambTemp;
    [characteristicValue getBytes: &scratchVal length: characteristicValue.length];
    ambTemp = ((scratchVal[2] & 0xff) | ((scratchVal[3] << 8) & 0xff00));
    ambTemp = (float)ambTemp / 128.0;

    return [STUtilities farenheitWithCelsius: ambTemp];
}

@end














