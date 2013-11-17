//
//  STRSSISensor.m
//  TISensorTag
//
//  Created by Andre Muis on 11/16/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "STRSSISensor.h"

#import "STConstants.h"

@interface STRSSISensor ()

@property (readonly, strong, nonatomic) id<STSensorTagDelegate> sensorTagDelegate;
@property (readonly, strong, nonatomic) CBPeripheral *sensorTagPeripheral;

@property (readwrite, strong, nonatomic) NSTimer *timer;
@property (readwrite, assign, nonatomic) int timerIntervalInMilliseconds;

@end

@implementation STRSSISensor

- (id)initWithSensorTagDelegate: (id<STSensorTagDelegate>)sensorTagDelegate
            sensorTagPeripheral: (CBPeripheral *)sensorTagPeripheral
{
    self = [super init];
    
    if (self)
    {
        _sensorTagDelegate = sensorTagDelegate;
        _sensorTagPeripheral = sensorTagPeripheral;
        
        _timer = nil;
        _timerIntervalInMilliseconds = STRSSITimerIntervalInMilliseconds;
    }
    
    return self;
}

- (void)enable
{
    [self readRSSI];
}

- (void)readRSSI
{
    [self.sensorTagPeripheral readRSSI];
}

- (void)sensorTagPeripheralDidUpdateRSSI
{
    [self.sensorTagDelegate sensorTagDidUpdateRSSI: self.sensorTagPeripheral.RSSI];

    [self setTimer];
}

- (void)setTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval: self.timerIntervalInMilliseconds / 1000.0
                                                  target: self
                                                selector: @selector(readRSSI)
                                                userInfo: nil
                                                 repeats: NO];
}

- (void)updateWithTimerIntervalInMilliseconds: (int)timerIntervalInMilliseconds
{
    self.timerIntervalInMilliseconds = timerIntervalInMilliseconds;
}

- (void)disable
{
    [self.timer invalidate];
    self.timer = nil;
}

@end
















