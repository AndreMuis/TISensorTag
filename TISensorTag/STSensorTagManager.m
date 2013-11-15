//
//  STSensorTagManager.m
//  TISensorTag
//
//  Created by Andre Muis on 11/14/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "STSensorTagManager.h"

#import "STSensorTag.h"

@interface STSensorTagManager () <CBCentralManagerDelegate>

@property (readonly, strong, nonatomic) id<STSensorTagManagerDelegate> delegate;

@property (readonly, strong, nonatomic) CBCentralManager *centralManager;
@property (readonly, strong, nonatomic) CBPeripheral *sensorTagPeripheral;
@property (readonly, strong, nonatomic) STSensorTag *sensorTag;

@end

@implementation STSensorTagManager

- (id)initWithDelegate: (id<STSensorTagManagerDelegate>)delegate
{
    self = [super init];
    
    if (self)
    {
        _delegate = delegate;
        
        _centralManager = [[CBCentralManager alloc] initWithDelegate: self queue: nil options: nil];
        _sensorTag = nil;
    }
    
    return self;
}

- (void)centralManagerDidUpdateState: (CBCentralManager *)central
{
    [self.delegate centralManagerDidUpdateState: [self stringWithCentralManagerState: central.state]];
    
    if (central.state == CBCentralManagerStatePoweredOn)
    {
        [self.centralManager scanForPeripheralsWithServices: nil
                                                    options: nil];
    }
}

- (void)centralManager: (CBCentralManager *)central
 didDiscoverPeripheral: (CBPeripheral *)peripheral
     advertisementData: (NSDictionary *)advertisementData
                  RSSI: (NSNumber *)RSSI
{
    if ([peripheral.name isEqualToString: @"TI BLE Sensor Tag"] == YES)
    {
        _sensorTagPeripheral = peripheral;
        [self.centralManager connectPeripheral: self.sensorTagPeripheral options: nil];
    }
}

- (void)centralManager: (CBCentralManager *)central
  didConnectPeripheral: (CBPeripheral *)peripheral
{
    [self.centralManager stopScan];
    
    _sensorTag = [[STSensorTag alloc] initWithSensorTagPeripheral: self.sensorTagPeripheral];
}

- (void)centralManager: (CBCentralManager *)central didDisconnectPeripheral: (CBPeripheral *)peripheral error: (NSError *)error
{
    if (error != nil)
    {
        NSLog(@"Central manager disconnected sensor tag. Error = %@", error);
    }

    _sensorTagPeripheral = nil;
    
    [self.sensorTag disconnect];
    _sensorTag = nil;
    
    [self.centralManager scanForPeripheralsWithServices: nil
                                                options: nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Central manager failed to connect to sensor tag. Error = %@", error);
    
    _sensorTagPeripheral = nil;

    [self.sensorTag disconnect];
    _sensorTag = nil;
    
    [self.centralManager scanForPeripheralsWithServices: nil
                                                options: nil];
}

- (NSString *)stringWithCentralManagerState: (CBCentralManagerState)state
{
    switch (state)
    {
        case CBCentralManagerStateUnknown:
            return @"unknown";
            break;
            
        case CBCentralManagerStateResetting:
            return @"resetting";
            break;
            
        case CBCentralManagerStateUnsupported:
            return @"unsupported";
            break;
            
        case CBCentralManagerStateUnauthorized:
            return @"unauthorized";
            break;
            
        case CBCentralManagerStatePoweredOff:
            return @"powered off";
            break;
            
        case CBCentralManagerStatePoweredOn:
            return @"powered on";
            break;
            
        default:
            NSLog(@"Unhandled central manager state: %d", state);
            return @"";
            break;
    }
}

@end





















