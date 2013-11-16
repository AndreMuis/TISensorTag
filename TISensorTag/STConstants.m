//
//  STConstants.m
//  TISensorTag
//
//  Created by Andre Muis on 11/15/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "STConstants.h"

@implementation STConstants

NSString* const STAccelerometerDataCharacteristicUUIDString = @"F000AA11-0451-4000-B000-000000000000";
NSString* const STAccelerometerConfigurationCharacteristicUUIDString = @"F000AA12-0451-4000-B000-000000000000";
NSString* const STAccelerometerPeriodCharacteristicUUIDString = @"F000AA13-0451-4000-b000-000000000000";
float const STAccelerometerRange = 4.0;

NSString* const STButtonSensorDataCharacteristicUUIDString = @"FFE1";

NSString* const STGyroscopeDataCharacteristicUUIDString = @"F000AA51-0451-4000-B000-000000000000";
NSString* const STGyroscopeConfigurationCharacteristicUUIDString = @"F000AA52-0451-4000-B000-000000000000";
float const STGyroscopeRange = 500.0;

NSString* const STMagnetometerDataCharacteristicUUIDString = @"F000AA31-0451-4000-B000-000000000000";
NSString* const STMagnetometerConfigurationCharacteristicUUIDString = @"F000AA32-0451-4000-B000-000000000000";
NSString* const STMagnetometerPeriodCharacteristicUUIDString = @"F000AA33-0451-4000-b000-000000000000";
float const STMagnetometerRange = 2000.0;

NSString* const STTemperatureSensorDataCharacteristicUUIDString = @"F000AA01-0451-4000-b000-000000000000";
NSString* const STTemperatureSensorConfigurationCharacteristicUUIDString = @"F000AA02-0451-4000-b000-000000000000";

@end
