//
//  STConstants.h
//  TISensorTag
//
//  Created by Andre Muis on 11/15/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STConstants : NSObject

extern NSString* const STAccelerometerDataCharacteristicUUIDString;
extern NSString* const STAccelerometerConfigurationCharacteristicUUIDString;
extern NSString* const STAccelerometerPeriodCharacteristicUUIDString;
extern float const STAccelerometerRange;

extern NSString* const STButtonSensorDataCharacteristicUUIDString;

extern NSString* const STGyroscopeDataCharacteristicUUIDString;
extern NSString* const STGyroscopeConfigurationCharacteristicUUIDString;
extern float const STGyroscopeRange;

extern NSString* const STMagnetometerDataCharacteristicUUIDString;
extern NSString* const STMagnetometerConfigurationCharacteristicUUIDString;
extern NSString* const STMagnetometerPeriodCharacteristicUUIDString;
extern float const STMagnetometerRange;

extern NSString* const STTemperatureSensorDataCharacteristicUUIDString;
extern NSString* const STTemperatureSensorConfigurationCharacteristicUUIDString;

@end
