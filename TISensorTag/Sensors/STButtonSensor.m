//
//  STButtonSensor.m
//  TISensorTag
//
//  Created by Andre Muis on 11/15/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "STButtonSensor.h"

#import "STConstants.h"
#import "STSensorTagDelegate.h"

@interface STButtonSensor ()

@property (readonly, strong, nonatomic) id<STSensorTagDelegate> sensorTagDelegate;
@property (readonly, strong, nonatomic) CBPeripheral *sensorTagPeripheral;

@end

@implementation STButtonSensor

- (id)initWithSensorTagDelegate: (id<STSensorTagDelegate>)sensorTagDelegate
            sensorTagPeripheral: (CBPeripheral *)sensorTagPeripheral
{
    self = [super init];
    
    if (self)
    {
        _sensorTagDelegate = sensorTagDelegate;
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

- (void)enable
{
    [self.sensorTagPeripheral setNotifyValue: YES
                           forCharacteristic: self.dataCharacteristic];
}

- (void)sensorTagPeripheralDidUpdateValueForCharacteristic: (CBCharacteristic *)characteristic
{
    if ([characteristic.UUID isEqual: self.dataCharacteristicUUID] == YES)
    {
        [self.sensorTagDelegate sensorTagDidUpdateButtonsPressed: [self buttonsPressedWithCharacteristicValue: characteristic.value]];
    }
}

- (void)disable
{
    [self.sensorTagPeripheral setNotifyValue: NO
                           forCharacteristic: self.dataCharacteristic];
}

- (STButtonsPressed)buttonsPressedWithCharacteristicValue: (NSData *)characteristicValue
{
    STButtonsPressed buttonsPressed = STButtonsPressedUnknown;
    
    char scratchVal[characteristicValue.length];
    [characteristicValue getBytes: &scratchVal length: characteristicValue.length];

    switch ((int)scratchVal[0])
    {
        case 0:
            buttonsPressed = STButtonsPressedNone;
            break;
            
        case 1:
            buttonsPressed = STButtonsPressedRight;
            break;
        
        case 2:
            buttonsPressed = STButtonsPressedLeft;
            break;

        case 3:
            buttonsPressed = STButtonsPressedBoth;
            break;

        default:
            NSLog(@"Button with characteristic value %@ not handled.", characteristicValue);
            buttonsPressed = STButtonsPressedUnknown;
            break;
    }
    
    return buttonsPressed;
}

@end


























