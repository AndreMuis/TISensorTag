//
//  STSensorTag.m
//  TISensorTag
//
//  Created by Andre Muis on 11/14/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "STSensorTag.h"

#import "STAccelerometer.h"
#import "STButtonSensor.h"
#import "STGyroscope.h"
#import "STMagnetometer.h"
#import "STTemperatureSensor.h"

@interface STSensorTag () <CBPeripheralDelegate>

@property (readonly, strong, nonatomic) id<STSensorTagDelegate> delegate;
@property (readonly, strong, nonatomic) CBPeripheral *sensorTagPeripheral;
@property (readonly, strong, nonatomic) NSTimer *rssiTimer;

@end

@implementation STSensorTag

- (id)initWithDelegate: (id<STSensorTagDelegate>)delegate
   sensorTagPeripheral: (CBPeripheral *)sensorTagPeripheral;
{
    self = [super init];
    
    if (self)
    {
        _delegate = delegate;
        
        _sensorTagPeripheral = sensorTagPeripheral;
        _sensorTagPeripheral.delegate = self;
        [_sensorTagPeripheral discoverServices: nil];

        _rssiTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                      target: self
                                                    selector: @selector(readRSSI)
                                                    userInfo: nil
                                                     repeats: YES];
        
        _accelerometer = [[STAccelerometer alloc] initWithSensorTagPeripheral: sensorTagPeripheral];
        _buttonSensor = [[STButtonSensor alloc] initWithSensorTagPeripheral: sensorTagPeripheral];
        _gyroscope = [[STGyroscope alloc] initWithSensorTagPeripheral: sensorTagPeripheral];
        _magnetometer = [[STMagnetometer alloc] initWithSensorTagPeripheral: sensorTagPeripheral];
        _temperatureSensor = [[STTemperatureSensor alloc] initWithSensorTagPeripheral: sensorTagPeripheral];
    }
    
    return self;
}

- (void)peripheral: (CBPeripheral *)peripheral didDiscoverServices: (NSError *)error
{
    if (error == nil)
    {
        for (CBService *service in self.sensorTagPeripheral.services)
        {
            [self.sensorTagPeripheral discoverCharacteristics: nil forService: service];
        }
    }
    else
    {
        NSLog(@"An error occurred while discovering services: Error = %@", error);
    }
}

- (void)peripheral: (CBPeripheral *)peripheral didDiscoverCharacteristicsForService: (CBService *)service error: (NSError *)error
{
    if (error == nil)
    {
        for (CBCharacteristic *characteristic in service.characteristics)
        {
            if ([characteristic.UUID isEqual: self.accelerometer.dataCharacteristicUUID] == YES)
            {
                self.accelerometer.dataCharacteristic = characteristic;
            }
            else if ([characteristic.UUID isEqual: self.accelerometer.configurationCharacteristicUUID] == YES)
            {
                self.accelerometer.configurationCharacteristic = characteristic;
            }
            else if ([characteristic.UUID isEqual: self.accelerometer.periodCharacteristicUUID] == YES)
            {
                self.accelerometer.periodCharacteristic = characteristic;
            }
            else if ([characteristic.UUID isEqual: self.buttonSensor.dataCharacteristicUUID] == YES)
            {
                self.buttonSensor.dataCharacteristic = characteristic;
            }
            else if ([characteristic.UUID isEqual: self.gyroscope.dataCharacteristicUUID] == YES)
            {
                self.gyroscope.dataCharacteristic = characteristic;
            }
            else if ([characteristic.UUID isEqual: self.gyroscope.configurationCharacteristicUUID] == YES)
            {
                self.gyroscope.configurationCharacteristic = characteristic;
            }
            if ([characteristic.UUID isEqual: self.magnetometer.dataCharacteristicUUID] == YES)
            {
                self.magnetometer.dataCharacteristic = characteristic;
            }
            else if ([characteristic.UUID isEqual: self.magnetometer.configurationCharacteristicUUID] == YES)
            {
                self.magnetometer.configurationCharacteristic = characteristic;
            }
            else if ([characteristic.UUID isEqual: self.magnetometer.periodCharacteristicUUID] == YES)
            {
                self.magnetometer.periodCharacteristic = characteristic;
            }
            else if ([characteristic.UUID isEqual: self.temperatureSensor.dataCharacteristicUUID] == YES)
            {
                self.temperatureSensor.dataCharacteristic = characteristic;
            }
            else if ([characteristic.UUID isEqual: self.temperatureSensor.configurationCharacteristicUUID] == YES)
            {
                self.temperatureSensor.configurationCharacteristic = characteristic;
            }
        }
        
        if (self.accelerometer.configured == YES)
        {
            [self.accelerometer update];
        }

        if (self.buttonSensor.configured == YES)
        {
            [self.buttonSensor update];
        }

        if (self.gyroscope.configured == YES)
        {
            [self.gyroscope update];
        }
        
        if (self.magnetometer.configured == YES)
        {
            [self.magnetometer update];
        }

        if (self.temperatureSensor.configured == YES)
        {
            [self.temperatureSensor update];
        }
    }
    else
    {
        NSLog(@"An error occurred while discovering characteristics: Error = %@", error);
    }
}

- (void)peripheral: (CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic: (CBCharacteristic *)characteristic error: (NSError *)error
{
    if (error)
    {
        NSLog(@"Error updating notification state: %@", [error localizedDescription]);
    }
}

- (void)peripheral: (CBPeripheral *)peripheral didUpdateValueForCharacteristic: (CBCharacteristic *)characteristic error: (NSError *)error
{
    if (error == nil)
    {
        if ([characteristic.UUID isEqual: self.accelerometer.dataCharacteristicUUID] == YES)
        {
            [self.delegate sensorTagDidUpdateAcceleration: [self.accelerometer accelerationWithCharacteristicValue: characteristic.value]];
        }
        else if ([characteristic.UUID isEqual: self.buttonSensor.dataCharacteristicUUID] == YES)
        {
            [self.delegate sensorTagDidUpdateButtonPressed: [self.buttonSensor buttonPressedWithCharacteristicValue: characteristic.value]];
        }
        else if ([characteristic.UUID isEqual: self.gyroscope.dataCharacteristicUUID] == YES)
        {
            [self.delegate sensorTagDidUpdateAngularVelocity: [self.gyroscope angularVelocityWithCharacteristicValue: characteristic.value]];
        }
        else if ([characteristic.UUID isEqual: self.magnetometer.dataCharacteristicUUID] == YES)
        {
            [self.delegate sensorTagDidUpdateMagneticFieldStrength: [self.magnetometer magneticFieldStrengthWithCharacteristicValue: characteristic.value]];
        }
        else if ([characteristic.UUID isEqual: self.temperatureSensor.dataCharacteristicUUID] == YES)
        {
            [self.delegate sensorTagDidUpdateTemperature: [self.temperatureSensor temperatureWithCharacteristicValue: characteristic.value]];
        }
    }
    else
    {
        NSLog(@"Error updating characteristic. Error = %@", [error localizedDescription]);
    }
}

- (void)readRSSI
{
    [self.sensorTagPeripheral readRSSI];
}

- (void)peripheralDidUpdateRSSI: (CBPeripheral *)peripheral error: (NSError *)error
{
    if (error == nil)
    {
        [self.delegate sensorTagDidUpdateRSSI: peripheral.RSSI];
    }
    else
    {
        NSLog(@"Error updating RSSI. Error = %@", [error localizedDescription]);
    }
}

- (void)disconnect
{
    [self.rssiTimer invalidate];
    _rssiTimer = nil;
}

@end















