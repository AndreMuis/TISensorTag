//
//  STSensorTag.m
//  TISensorTag
//
//  Created by Andre Muis on 11/14/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "STSensorTag.h"

#import "STAccelerometer.h"
#import "STTemperatureSensor.h"

@interface STSensorTag () <CBPeripheralDelegate>

@property (readonly, strong, nonatomic) CBPeripheral *sensorTagPeripheral;
@property (readonly, strong, nonatomic) NSTimer *rssiTimer;

@end

@implementation STSensorTag

- (id)initWithSensorTagPeripheral: (CBPeripheral *)sensorTagPeripheral
{
    self = [super init];
    
    if (self)
    {
        _sensorTagPeripheral = sensorTagPeripheral;
        _sensorTagPeripheral.delegate = self;
        [_sensorTagPeripheral discoverServices: nil];

        _rssiTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                      target: self
                                                    selector: @selector(readRSSI)
                                                    userInfo: nil
                                                     repeats: YES];
        
        _accelerometer = [[STAccelerometer alloc] initWithSensorTagPeripheral: sensorTagPeripheral];
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
            if ([characteristic.UUID isEqual: self.temperatureSensor.dataCharacteristicUUID] == YES)
            {
                self.temperatureSensor.dataCharacteristic = characteristic;
            }
            else if ([characteristic.UUID isEqual: self.temperatureSensor.configurationCharacteristicUUID] == YES)
            {
                self.temperatureSensor.configurationCharacteristic = characteristic;
            }
            else if ([characteristic.UUID isEqual: self.accelerometer.dataCharacteristicUUID] == YES)
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
        }
        
        if (self.temperatureSensor.configured == YES)
        {
            [self.temperatureSensor update];
        }

        if (self.accelerometer.configured == YES)
        {
            [self.accelerometer update];
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
        if ([characteristic.UUID isEqual: self.temperatureSensor.dataCharacteristicUUID] == YES)
        {
            NSLog(@"temp = %f", [self.temperatureSensor temperatureWithCharacteristicValue: characteristic.value]);
            
            //self.temperatureLabel.text = [NSString stringWithFormat: @"%.0f F", ambTemp * 9.0 / 5.0 + 32.0];
        }
        else if ([characteristic.UUID isEqual: self.accelerometer.dataCharacteristicUUID] == YES)
        {
            NSLog(@"accel = %f", [self.accelerometer xAccelerationWithCharacteristicValue: characteristic.value]);
            
            //self.accelerometerLabel.text = [NSString stringWithFormat: @"%f", accelerationX];
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
    NSLog(@"%@", peripheral.RSSI);
}

- (void)disconnect
{
    [self.rssiTimer invalidate];
    _rssiTimer = nil;
}

@end















