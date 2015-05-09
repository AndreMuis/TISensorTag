//
//  STMovement.m
//  TISensorTag
//
//  Created by Michael Terry on 5/9/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import "STMovement.h"

#import "STAcceleration.h"
#import "STConstants.h"
#import "STUtilities.h"

@interface STMovement ()
{
    BOOL _enabled;
}

@property (readonly, strong, nonatomic) id<STSensorTagDelegate> sensorTagDelegate;
@property (readonly, strong, nonatomic) CBPeripheral *sensorTagPeripheral;
@property (readonly, strong, nonatomic) STAcceleration *rollingAcceleration;

@end

@implementation STMovement

- (id)initWithSensorTagDelegate: (id<STSensorTagDelegate>)sensorTagDelegate
            sensorTagPeripheral: (CBPeripheral *)sensorTagPeripheral
{
    self = [super init];
    
    if (self)
    {
        _sensorTagDelegate = sensorTagDelegate;
        _sensorTagPeripheral = sensorTagPeripheral;
        _rollingAcceleration = [[STAcceleration alloc] initWithXComponent: 0.0 yComponent: 0.0 zComponent: 0.0];
        _dataCharacteristicUUID = [CBUUID UUIDWithString: STMovementDataCharacteristicUUIDString];
        _dataCharacteristic = nil;
        
        _configurationCharacteristicUUID = [CBUUID UUIDWithString: STMovementConfigurationCharacteristicUUIDString];
        _configurationCharacteristic = nil;
        
        _periodCharacteristicUUID = [CBUUID UUIDWithString: STMovementPeriodCharacteristicUUIDString];
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

- (BOOL)enabled
{
    return _enabled;
}

- (void)setEnabled: (BOOL)enabled
{
    if (enabled == YES && _enabled == NO)
    {
        _enabled = YES;
        
        uint16_t enableValue = 0x003f;
        
        [self.sensorTagPeripheral writeValue: [NSData dataWithBytes: &enableValue length: 2]
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
        
        uint8_t disableValue = STMovementEnableValue;
        
        [self.sensorTagPeripheral writeValue: [NSData dataWithBytes: &disableValue length: 1]
                           forCharacteristic: self.configurationCharacteristic
                                        type: CBCharacteristicWriteWithResponse];
    }
}

- (void)sensorTagPeripheralDidUpdateValueForCharacteristic: (CBCharacteristic *)characteristic
{
    if ([characteristic.UUID isEqual: self.dataCharacteristicUUID] == YES)
    {
        uint8_t scratchVal[characteristic.value.length];
        [characteristic.value getBytes: &scratchVal length: characteristic.value.length];
        
        [self.sensorTagDelegate sensorTagDidUpdateAcceleration: [self accelerationWithBytes:&scratchVal[6]]];
        [self.sensorTagDelegate sensorTagDidUpdateSmoothedAcceleration: [self smoothedAccelerationWithCharacteristicValue: characteristic.value]];
        [self.sensorTagDelegate sensorTagDidUpdateMagneticFieldStrength: [self magneticFieldStrengthWithBytes:&scratchVal[12]]];
    }
}

- (void)updateWithPeriodInMilliseconds: (int)periodInMilliseconds
{
    uint8_t periodData = (uint8_t)(periodInMilliseconds / 10);
    [self.sensorTagPeripheral writeValue: [NSData dataWithBytes: &periodData length: 1]
                       forCharacteristic: self.periodCharacteristic
                                    type: CBCharacteristicWriteWithResponse];
}

- (STAcceleration *)accelerationWithBytes: (uint8_t*) scratchVal;
{
    STAcceleration *acceleration = [[STAcceleration alloc] initWithXComponent: (scratchVal[0] * 1.0 + scratchVal[1] * 256.0) / (65536 / STAccelerometerRange)
                                                                   yComponent: (scratchVal[2] * 1.0 + scratchVal[3] * 256.0) / (65536 / STAccelerometerRange)
                                                                   zComponent: (scratchVal[4] * 1.0 + scratchVal[5] * 256.0) / (65536 / STAccelerometerRange)];
    
    return acceleration;
}

- (STAcceleration *)smoothedAccelerationWithCharacteristicValue: (NSData *)characteristicValue
{
    uint8_t scratchVal[characteristicValue.length];
    [characteristicValue getBytes: &scratchVal length: characteristicValue.length];
    
    STAcceleration *acceleration = [self accelerationWithBytes: &scratchVal[6]];
    
    self.rollingAcceleration.xComponent = (acceleration.xComponent * STAccelerometerHighPassFilteringFactor) +
    (self.rollingAcceleration.xComponent * (1.0 - STAccelerometerHighPassFilteringFactor));
    
    self.rollingAcceleration.yComponent = (acceleration.yComponent * STAccelerometerHighPassFilteringFactor) +
    (self.rollingAcceleration.yComponent * (1.0 - STAccelerometerHighPassFilteringFactor));
    
    self.rollingAcceleration.zComponent = (acceleration.zComponent * STAccelerometerHighPassFilteringFactor) +
    (self.rollingAcceleration.zComponent * (1.0 - STAccelerometerHighPassFilteringFactor));
    
    acceleration.xComponent = acceleration.xComponent - self.rollingAcceleration.xComponent;
    acceleration.yComponent = acceleration.yComponent - self.rollingAcceleration.yComponent;
    acceleration.zComponent = acceleration.zComponent - self.rollingAcceleration.zComponent;
    
    return acceleration;
}

- (float)magneticFieldStrengthWithBytes: (uint8_t*)scratchVal
{
    int16_t rawX = (scratchVal[0] & 0xff) | ((scratchVal[1] << 8) & 0xff00);
    float x = (((float)rawX * 1.0) / (65536 / STMagnetometerRange)) * -1;
    
    int16_t rawY = ((scratchVal[2] & 0xff) | ((scratchVal[3] << 8) & 0xff00));
    float y = (((float)rawY * 1.0) / (65536 / STMagnetometerRange)) * -1;
    
    int16_t rawZ = (scratchVal[4] & 0xff) | ((scratchVal[5] << 8) & 0xff00);
    float z =  ((float)rawZ * 1.0) / (65536 / STMagnetometerRange);
    
    return [STUtilities vectorMagnitudeWithXComponent: x YComponent: y ZComponent: z];
}

@end
