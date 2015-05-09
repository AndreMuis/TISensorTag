//
//  STConstants.m
//  TISensorTag
//
//  Created by Andre Muis on 11/15/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "STConstants.h"

@implementation STConstants

NSString* const STAdvertisementDataLocalNameKey = @"kCBAdvDataLocalName";
NSString* const STAdvertisementDataLocalNameValue = @"SensorTag";
NSString* const STAdvertisementDataLocalNameValueV1 = @"SensorTag";
NSString* const STAdvertisementDataLocalNameValueV2 = @"CC2650 SensorTag";

uint8_t const STSensorEnableValue = 0x01;
uint8_t const STSensorDisableValue = 0x00;
uint8_t const STMovementEnableValue = 0x02;
uint8_t const STMovementDisableValue = 0x00;

NSString* const STAccelerometerDataCharacteristicUUIDString = @"F000AA11-0451-4000-B000-000000000000";
NSString* const STAccelerometerConfigurationCharacteristicUUIDString = @"F000AA12-0451-4000-B000-000000000000";
NSString* const STAccelerometerPeriodCharacteristicUUIDString = @"F000AA13-0451-4000-b000-000000000000";
int const STAccelerometerPeriodInMilliseconds = 100;
float const STAccelerometerHighPassFilteringFactor = 0.2;
float const STAccelerometerRange = 4.0;

NSString* const STButtonSensorDataCharacteristicUUIDString = @"FFE1";

NSString* const STGyroscopeDataCharacteristicUUIDString = @"F000AA51-0451-4000-B000-000000000000";
NSString* const STGyroscopeConfigurationCharacteristicUUIDString = @"F000AA52-0451-4000-B000-000000000000";
uint8_t const STGyroscopeEnableValue = 0x07;
float const STGyroscopeRange = 500.0;

NSString* const STMagnetometerDataCharacteristicUUIDString = @"F000AA31-0451-4000-B000-000000000000";
NSString* const STMagnetometerConfigurationCharacteristicUUIDString = @"F000AA32-0451-4000-B000-000000000000";
NSString* const STMagnetometerPeriodCharacteristicUUIDString = @"F000AA33-0451-4000-b000-000000000000";
int const STMagnetometerPeriodInMilliseconds = 250;
float const STMagnetometerRange = 2000.0;
float const STMagneticFieldStrengthMinimum = 0.0;
float const STMagneticFieldStrengthMaximum = 300.0;

NSTimeInterval const STRSSITimerIntervalInMilliseconds = 1000.0;
float const STRSSIMinimum = -100.0;
float const STRSSIMaximum = 0.0;

NSString* const STTemperatureSensorDataCharacteristicUUIDString = @"F000AA01-0451-4000-b000-000000000000";
NSString* const STTemperatureSensorConfigurationCharacteristicUUIDString = @"F000AA02-0451-4000-b000-000000000000";

NSString* const STMovementDataCharacteristicUUIDString = @"F000AA81-0451-4000-B000-000000000000";
NSString* const STMovementConfigurationCharacteristicUUIDString = @"F000AA82-0451-4000-B000-000000000000";
NSString* const STMovementPeriodCharacteristicUUIDString = @"F000AA83-0451-4000-b000-000000000000";
int const STMovementPeriodInMilliseconds = 100;


@end
