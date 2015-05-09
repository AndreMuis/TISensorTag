//
//  STSensorTagManager.m
//  TISensorTag
//
//  Created by Andre Muis on 11/14/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "STSensorTagManager.h"

#import "CBCentralManager+STExtensions.h"
#import "STConstants.h"
#import "STSensorTag.h"

@interface STSensorTagManager () <CBCentralManagerDelegate>

@property (readonly, strong, nonatomic) id<STSensorTagManagerDelegate> delegate;

@property (readonly, strong, nonatomic) CBCentralManager *centralManager;
@property (readonly, strong, nonatomic) CBPeripheral *sensorTagPeripheral;

@property (readonly, strong, nonatomic) STSensorTag *sensorTag;
@property (readonly, strong, nonatomic) id<STSensorTagDelegate> sensorTagDelegate;

@end

@implementation STSensorTagManager

- (id)initWithDelegate: (id<STSensorTagManagerDelegate>)delegate
     sensorTagDelegate: (id<STSensorTagDelegate>)sensorTagDelegate
{
    self = [super init];
    
    if (self)
    {
        _delegate = delegate;
        
        _centralManager = [[CBCentralManager alloc] initWithDelegate: self queue: nil options: nil];
        _sensorTagPeripheral = nil;
        
        _sensorTag = nil;
        _sensorTagDelegate = sensorTagDelegate;
    }
    
    return self;
}

- (void)centralManagerDidUpdateState: (CBCentralManager *)central
{
    [self.delegate sensorTagManagerDidUpdateState: [central stateAsString]];
    
    if (central.state == CBCentralManagerStatePoweredOn)
    {
        [self.centralManager scanForPeripheralsWithServices: nil
                                                    options: nil];
        
        [self.delegate sensorTagManagerDidUpdateConnectionStatus: STConnectionStatusScanning];
    }
}

- (void)centralManager: (CBCentralManager *)central
 didDiscoverPeripheral: (CBPeripheral *)peripheral
     advertisementData: (NSDictionary *)advertisementData
                  RSSI: (NSNumber *)RSSI
{
    if ([[advertisementData allKeys] containsObject: STAdvertisementDataLocalNameKey] == YES)
    {
        NSString *localName = [advertisementData objectForKey: STAdvertisementDataLocalNameKey];
        
        // look for any version of the TISensorTag based on the string
        if ([localName containsString: STAdvertisementDataLocalNameValue] == YES)
        {
            // identify the different SensorTag versions by the advertised local name value, this isn't a great way to
            // do things but it is consistent with the previous implementation
            if ([localName isEqualToString: STAdvertisementDataLocalNameValueV2])
            {
                _version = STVersionCC2650;
            }
            else if ([localName isEqualToString: STAdvertisementDataLocalNameValueV1])
            {
                _version = STVersionCC2451;
            }
            else
            {
                NSLog(@"Couldn't clearly identify the SensorTag version by name %@ - going with v1", localName);
                _version = STVersionCC2451;
            }
            [self.delegate sensorTagManagerDidIdentifyVersion:_version];
            
            _sensorTagPeripheral = peripheral;
            [self.centralManager connectPeripheral: self.sensorTagPeripheral options: nil];

            [self.delegate sensorTagManagerDidUpdateConnectionStatus: STConnectionStatusConnecting];
        }
        else
        {
            NSLog(@"Advertisement data local name %@ does not contain %@", localName, STAdvertisementDataLocalNameValue);
        }
    }
    else
    {
        NSLog(@"Local name key %@ not found in advertisement data: %@", STAdvertisementDataLocalNameKey, advertisementData);
    }
}

- (void)centralManager: (CBCentralManager *)central
  didConnectPeripheral: (CBPeripheral *)peripheral
{
    [self.centralManager stopScan];
    
    _sensorTag = [[STSensorTag alloc] initWithDelegate: self.sensorTagDelegate
                                   sensorTagPeripheral: self.sensorTagPeripheral];
    
    [self.delegate sensorTagManagerDidUpdateConnectionStatus: STConnectionStatusConnected];
}

- (void)centralManager: (CBCentralManager *)central didDisconnectPeripheral: (CBPeripheral *)peripheral error: (NSError *)error
{
    if (error != nil)
    {
        NSLog(@"Central manager disconnected sensor tag. Error = %@", error);
    }

    _sensorTagPeripheral = nil;
    _sensorTag = nil;
    
    [self.centralManager scanForPeripheralsWithServices: nil
                                                options: nil];

    [self.delegate sensorTagManagerDidUpdateConnectionStatus: STConnectionStatusScanning];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Central manager failed to connect to sensor tag. Error = %@", error);
    
    _sensorTagPeripheral = nil;
    _sensorTag = nil;
    
    [self.centralManager scanForPeripheralsWithServices: nil
                                                options: nil];

    [self.delegate sensorTagManagerDidUpdateConnectionStatus: STConnectionStatusScanning];
}

- (void)enableSensors
{
    if (self.sensorTag != nil)
    {
        [self.sensorTag enableSensors];
    }
}

- (void)disableSensors
{
    if (self.sensorTag != nil)
    {
        [self.sensorTag disableSensors];
    }
}

@end





















