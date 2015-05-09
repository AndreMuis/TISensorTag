//
//  STConstants.h
//  TISensorTag
//
//  Created by Andre Muis on 11/15/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STConstants : NSObject

extern NSString* const STAdvertisementDataLocalNameKey;
extern NSString* const STAdvertisementDataLocalNameValue;
extern NSString* const STAdvertisementDataLocalNameValueV1;
extern NSString* const STAdvertisementDataLocalNameValueV2;

extern NSTimeInterval const STRSSITimerIntervalInMilliseconds;
extern float const STRSSIMinimum;
extern float const STRSSIMaximum;

extern uint8_t const STSensorEnableValue;
extern uint8_t const STSensorDisableValue;

extern NSString* const STAccelerometerDataCharacteristicUUIDString;
extern NSString* const STAccelerometerConfigurationCharacteristicUUIDString;
extern NSString* const STAccelerometerPeriodCharacteristicUUIDString;
extern int const STAccelerometerPeriodInMilliseconds;
extern float const STAccelerometerHighPassFilteringFactor;
extern float const STAccelerometerRange;

extern NSString* const STButtonSensorDataCharacteristicUUIDString;

extern NSString* const STGyroscopeDataCharacteristicUUIDString;
extern NSString* const STGyroscopeConfigurationCharacteristicUUIDString;
extern uint8_t const STGyroscopeEnableValue;
extern float const STGyroscopeRange;

extern NSString* const STMagnetometerDataCharacteristicUUIDString;
extern NSString* const STMagnetometerConfigurationCharacteristicUUIDString;
extern NSString* const STMagnetometerPeriodCharacteristicUUIDString;
extern int const STMagnetometerPeriodInMilliseconds;
extern float const STMagnetometerRange;

extern float const STMagneticFieldStrengthMinimum;
extern float const STMagneticFieldStrengthMaximum;

extern NSString* const STTemperatureSensorDataCharacteristicUUIDString;
extern NSString* const STTemperatureSensorConfigurationCharacteristicUUIDString;

@end
