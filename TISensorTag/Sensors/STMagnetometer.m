//
//  STMagnetometer.m
//  TISensorTag
//
//  Created by Andre Muis on 11/15/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "STMagnetometer.h"

#import "STConstants.h"
#import "STUtilities.h"

@interface STMagnetometer ()

@property (readonly, strong, nonatomic) CBPeripheral *sensorTagPeripheral;

@end

@implementation STMagnetometer

- (id)initWithSensorTagPeripheral: (CBPeripheral *)sensorTagPeripheral
{
    self = [super init];
    
    if (self)
    {
        _sensorTagPeripheral = sensorTagPeripheral;
        
        _dataCharacteristicUUID = [CBUUID UUIDWithString: STMagnetometerDataCharacteristicUUIDString];
        _dataCharacteristic = nil;
        
        _configurationCharacteristicUUID = [CBUUID UUIDWithString: STMagnetometerConfigurationCharacteristicUUIDString];
        _configurationCharacteristic = nil;
        
        _periodCharacteristicUUID = [CBUUID UUIDWithString: STMagnetometerPeriodCharacteristicUUIDString];
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

- (float)magneticFieldStrengthWithCharacteristicValue: (NSData *)characteristicValue
{
    char scratchVal[6];
    [characteristicValue getBytes: &scratchVal length: 6];
    
    int16_t rawX = (scratchVal[0] & 0xff) | ((scratchVal[1] << 8) & 0xff00);
    float x = (((float)rawX * 1.0) / (65536 / STMagnetometerRange)) * -1;

    int16_t rawY = ((scratchVal[2] & 0xff) | ((scratchVal[3] << 8) & 0xff00));
    float y = (((float)rawY * 1.0) / (65536 / STMagnetometerRange)) * -1;

    int16_t rawZ = (scratchVal[4] & 0xff) | ((scratchVal[5] << 8) & 0xff00);
    float z =  ((float)rawZ * 1.0) / (65536 / STMagnetometerRange);
    
    return [STUtilities vectorMagnitudeWithXComponent: x YComponent: y ZComponent: z];
}

@end



















