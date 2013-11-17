//
//  STGyroscope.m
//  TISensorTag
//
//  Created by Andre Muis on 11/15/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "STGyroscope.h"

#import "STAngularVelocity.h"
#import "STConstants.h"

@interface STGyroscope ()
{
    BOOL _enabled;
}

@property (readonly, strong, nonatomic) id<STSensorTagDelegate> sensorTagDelegate;
@property (readonly, strong, nonatomic) CBPeripheral *sensorTagPeripheral;

@end

@implementation STGyroscope

- (id)initWithSensorTagDelegate: (id<STSensorTagDelegate>)sensorTagDelegate
            sensorTagPeripheral: (CBPeripheral *)sensorTagPeripheral
{
    self = [super init];
    
    if (self)
    {
        _sensorTagDelegate = sensorTagDelegate;
        _sensorTagPeripheral = sensorTagPeripheral;
        
        _dataCharacteristicUUID = [CBUUID UUIDWithString: STGyroscopeDataCharacteristicUUIDString];
        _dataCharacteristic = nil;
        
        _configurationCharacteristicUUID = [CBUUID UUIDWithString: STGyroscopeConfigurationCharacteristicUUIDString];
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

- (BOOL)enabled
{
    return _enabled;
}

- (void)setEnabled: (BOOL)enabled
{
    if (enabled == YES && _enabled == NO)
    {
        _enabled = YES;
        
        uint8_t enableValue = STGyroscopeEnableValue;
        [self.sensorTagPeripheral writeValue: [NSData dataWithBytes: &enableValue length: 1]
                           forCharacteristic: self.configurationCharacteristic
                                        type: CBCharacteristicWriteWithResponse];
        
        [self.sensorTagPeripheral setNotifyValue: YES
                               forCharacteristic: self.dataCharacteristic];
    }
    else if (enabled == NO && _enabled == YES)
    {
        _enabled = NO;
        
        [self.sensorTagPeripheral setNotifyValue: NO
                               forCharacteristic: self.dataCharacteristic];
        
        uint8_t disableValue = STSensorDisableValue;
        [self.sensorTagPeripheral writeValue: [NSData dataWithBytes: &disableValue length: 1]
                           forCharacteristic: self.configurationCharacteristic
                                        type: CBCharacteristicWriteWithResponse];
    }
}

- (void)sensorTagPeripheralDidUpdateValueForCharacteristic: (CBCharacteristic *)characteristic
{
    if ([characteristic.UUID isEqual: self.dataCharacteristicUUID] == YES)
    {
        [self.sensorTagDelegate sensorTagDidUpdateAngularVelocity: [self angularVelocityWithCharacteristicValue: characteristic.value]];
    }
}

- (STAngularVelocity *)angularVelocityWithCharacteristicValue: (NSData *)characteristicValue
{
    char scratchVal[6];
    [characteristicValue getBytes: &scratchVal length: 6];

    int16_t rawX = (scratchVal[0] & 0xff) | ((scratchVal[1] << 8) & 0xff00);
    float x = (((float)rawX * 1.0) / (65536 / STGyroscopeRange)) * -1;

    int16_t rawY = ((scratchVal[2] & 0xff) | ((scratchVal[3] << 8) & 0xff00));
    float y = (((float)rawY * 1.0) / (65536 / STGyroscopeRange)) * -1;

    int16_t rawZ = (scratchVal[4] & 0xff) | ((scratchVal[5] << 8) & 0xff00);
    float z = ((float)rawZ * 1.0) / (65536 / STGyroscopeRange);
    
    STAngularVelocity *angularVelocity = [[STAngularVelocity alloc] initWithXComponent: x
                                                                            YComponent: y
                                                                            ZComponent: z];
    
    return angularVelocity;
}

@end

















