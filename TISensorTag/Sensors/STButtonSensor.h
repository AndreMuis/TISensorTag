//
//  STButtonSensor.h
//  TISensorTag
//
//  Created by Andre Muis on 11/15/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, STButton)
{
    STButtonUnknown,
    STButtonNone,
    STButtonRight,
    STButtonLeft
};

@interface STButtonSensor : NSObject

@property (readonly, strong, nonatomic) CBUUID *dataCharacteristicUUID;
@property (readwrite, strong, nonatomic) CBCharacteristic *dataCharacteristic;

@property (readonly, assign, nonatomic) BOOL configured;

- (id)initWithSensorTagPeripheral: (CBPeripheral *)sensorTagPeripheral;

- (void)update;

- (int)buttonPressedWithCharacteristicValue: (NSData *)characteristicValue;

@end
