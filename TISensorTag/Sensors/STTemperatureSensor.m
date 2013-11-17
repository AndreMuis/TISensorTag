//
//  STTemperatureSensor.m
//  TISensorTag
//
//  Created by Andre Muis on 11/14/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "STTemperatureSensor.h"

#import "STConstants.h"
#import "STUtilities.h"

@interface STTemperatureSensor ()
{
    BOOL _enabled;
}

@property (readonly, strong, nonatomic) id<STSensorTagDelegate> sensorTagDelegate;
@property (readonly, strong, nonatomic) CBPeripheral *sensorTagPeripheral;

@end

@implementation STTemperatureSensor

- (id)initWithSensorTagDelegate: (id<STSensorTagDelegate>)sensorTagDelegate
            sensorTagPeripheral: (CBPeripheral *)sensorTagPeripheral
{
    self = [super init];
    
    if (self)
    {
        _sensorTagDelegate = sensorTagDelegate;
        _sensorTagPeripheral = sensorTagPeripheral;
        
        _dataCharacteristicUUID = [CBUUID UUIDWithString: STTemperatureSensorDataCharacteristicUUIDString];
        _dataCharacteristic = nil;

        _configurationCharacteristicUUID = [CBUUID UUIDWithString: STTemperatureSensorConfigurationCharacteristicUUIDString];
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
        
        uint8_t enableValue = STSensorEnableValue;
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
        [self.sensorTagDelegate sensorTagDidUpdateTemperature: [self temperatureWithCharacteristicValue: characteristic.value]];
    }
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














