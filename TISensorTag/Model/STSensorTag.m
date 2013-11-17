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
#import "STConstants.h"
#import "STGyroscope.h"
#import "STMagnetometer.h"
#import "STRSSISensor.h"
#import "STTemperatureSensor.h"

@interface STSensorTag () <CBPeripheralDelegate>

@property (readonly, strong, nonatomic) id<STSensorTagDelegate> delegate;
@property (readonly, strong, nonatomic) CBPeripheral *sensorTagPeripheral;

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

        _accelerometer = [[STAccelerometer alloc] initWithSensorTagDelegate: self.delegate
                                                        sensorTagPeripheral: sensorTagPeripheral];
        
        _buttonSensor = [[STButtonSensor alloc] initWithSensorTagDelegate: self.delegate
                                                      sensorTagPeripheral: sensorTagPeripheral];
        
        _gyroscope = [[STGyroscope alloc] initWithSensorTagDelegate: self.delegate
                                                sensorTagPeripheral: sensorTagPeripheral];
        
        _magnetometer = [[STMagnetometer alloc] initWithSensorTagDelegate: self.delegate
                                                      sensorTagPeripheral: sensorTagPeripheral];
        
        _rssiSensor = [[STRSSISensor alloc] initWithSensorTagDelegate: self.delegate
                                                  sensorTagPeripheral: sensorTagPeripheral];
        
        _temperatureSensor = [[STTemperatureSensor alloc] initWithSensorTagDelegate: self.delegate
                                                                sensorTagPeripheral: sensorTagPeripheral];
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
        
        [self enableSensors];
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
        [self.accelerometer sensorTagPeripheralDidUpdateValueForCharacteristic: characteristic];
        [self.buttonSensor sensorTagPeripheralDidUpdateValueForCharacteristic: characteristic];
        [self.gyroscope sensorTagPeripheralDidUpdateValueForCharacteristic: characteristic];
        [self.magnetometer sensorTagPeripheralDidUpdateValueForCharacteristic: characteristic];
        [self.temperatureSensor sensorTagPeripheralDidUpdateValueForCharacteristic: characteristic];
    }
    else
    {
        NSLog(@"Error updating characteristic. Error = %@", [error localizedDescription]);
    }
}

- (void)peripheralDidUpdateRSSI: (CBPeripheral *)peripheral error: (NSError *)error
{
    if (error != nil)
    {
        NSLog(@"Error updating RSSI. Error = %@", [error localizedDescription]);
    }    

    [self.rssiSensor sensorTagPeripheralDidUpdateRSSI];
}

- (void)enableSensors
{
    if (self.accelerometer.configured == YES)
    {
        self.accelerometer.enabled = YES;
        [self.accelerometer updateWithPeriodInMilliseconds: STAccelerometerPeriodInMilliseconds];
    }
    
    if (self.buttonSensor.configured == YES)
    {
        self.buttonSensor.enabled = YES;
    }
    
    if (self.gyroscope.configured == YES)
    {
        self.gyroscope.enabled = YES;
    }
    
    if (self.magnetometer.configured == YES)
    {
        self.magnetometer.enabled = YES;
        [self.magnetometer updateWithPeriodInMilliseconds: STMagnetometerPeriodInMilliseconds];
    }
    
    if (self.rssiSensor.configured == YES)
    {
        self.rssiSensor.enabled = YES;
    }
    
    if (self.temperatureSensor.configured == YES)
    {
        self.temperatureSensor.enabled = YES;
    }
    
    [self.delegate sensorTagDidEnableSensors];
}

- (void)disableSensors
{
    if (self.accelerometer.configured == YES)
    {
        self.accelerometer.enabled = NO;
    }
    
    if (self.buttonSensor.configured == YES)
    {
        self.buttonSensor.enabled = NO;
    }
    
    if (self.gyroscope.configured == YES)
    {
        self.gyroscope.enabled = NO;
    }
    
    if (self.magnetometer.configured == YES)
    {
        self.magnetometer.enabled = NO;
    }
    
    if (self.rssiSensor.configured == YES)
    {
        self.rssiSensor.enabled = NO;
    }    

    if (self.temperatureSensor.configured == YES)
    {
        self.temperatureSensor.enabled = NO;
    }

    [self.delegate sensorTagDidDisableSensors];
}

@end















