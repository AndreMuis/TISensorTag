//
//  STViewController.m
//  TISensorTag
//
//  Created by Andre Muis on 11/14/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "STViewController.h"

#import "STBarMeterView.h"
#import "STButtonSensor.h"
#import "STButtonView.h"
#import "STConstants.h"
#import "STSensorTagManager.h"

@interface STViewController ()

@property (weak, nonatomic) IBOutlet UILabel *centralManagerStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *connectionStatusLabel;

@property (weak, nonatomic) IBOutlet STBarMeterView *signalStrengthBarMeterView;

@property (weak, nonatomic) IBOutlet UIImageView *sensorTagImageView;
@property (readonly, assign, nonatomic) CGPoint sensorTagImageViewCenter;
@property (readonly, assign, nonatomic) CGSize sensorTagImageViewSize;

@property (weak, nonatomic) IBOutlet STBarMeterView *magneticFieldStrengthBarMeterView;

@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;

@property (weak, nonatomic) IBOutlet STButtonView *leftButtonView;
@property (weak, nonatomic) IBOutlet STButtonView *rightButtonView;

@end

@implementation STViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.centralManagerStateLabel.backgroundColor = [UIColor clearColor];
    self.connectionStatusLabel.backgroundColor = [UIColor clearColor];
    
    [self.signalStrengthBarMeterView setupWithBackgroundColor: [UIColor colorWithRed: 0.75 green: 1.0 blue: 0.75 alpha: 1.0]
                                               indicatorColor: [UIColor colorWithRed: 0.0 green: 1.0 blue: 0.0 alpha: 1.0]];
    
    _sensorTagImageViewCenter = self.sensorTagImageView.center;
    _sensorTagImageViewSize = self.sensorTagImageView.frame.size;
    [_sensorTagImageView setImage:[UIImage imageNamed:@"SensorTag"]];
    
    [self.magneticFieldStrengthBarMeterView setupWithBackgroundColor: [UIColor colorWithRed: 0.75 green: 0.75 blue: 1.0 alpha: 1.0]
                                                      indicatorColor: [UIColor colorWithRed: 0.0 green: 0.0 blue: 1.0 alpha: 1.0]];

    self.temperatureLabel.backgroundColor = [UIColor clearColor];
    
    [self.leftButtonView setup];
    [self.rightButtonView setup];
    
    [self resetUI];
}

- (void)sensorTagManagerDidUpdateState: (NSString *)state
{
    self.centralManagerStateLabel.text = state;
}

- (void)sensorTagManagerDidUpdateConnectionStatus: (STConnectionStatus)status
{
    switch (status)
    {
        case STConnectionStatusScanning:
            [self resetUI];
            self.connectionStatusLabel.textColor = [UIColor blackColor];
            self.connectionStatusLabel.text = @"Scanning";
            break;
            
        case STConnectionStatusConnecting:
            [self resetUI];
            self.connectionStatusLabel.textColor = [UIColor blackColor];
            self.connectionStatusLabel.text = @"Connecting";
            break;
            
        case STConnectionStatusConnected:
            self.connectionStatusLabel.textColor = [UIColor blueColor];
            self.connectionStatusLabel.text = @"Connected";
            break;
            
        default:
            [self resetUI];
            NSLog(@"Connection status set to an illegal value: %d", (int)status);
            break;
    }
}

- (void) sensorTagManagerDidIdentifyVersion:(STVersion)version
{
    switch (version) {
        case STVersionCC2451:
            [_sensorTagImageView setImage:[UIImage imageNamed:@"SensorTag"]];
            break;
        case STVersionCC2650:
            [_sensorTagImageView setImage:[UIImage imageNamed:@"SensorTag2"]];
            break;
    }
}

- (void)sensorTagDidUpdateRSSI: (NSNumber *)rssi;
{
    float rssiValue = [rssi floatValue];
    self.signalStrengthBarMeterView.normalizedReading = (rssiValue - STRSSIMinimum) / (STRSSIMaximum - STRSSIMinimum);
}

- (void)sensorTagDidUpdateAcceleration: (STAcceleration *)acceleration
{
}

- (void)sensorTagDidUpdateSmoothedAcceleration: (STAcceleration *)acceleration
{
    CGSize sensorTagImageViewDisplacement =
    CGSizeMake(40.0 * (acceleration.xComponent / (STAccelerometerRange / 2.0)),
               40.0 * (acceleration.yComponent / (STAccelerometerRange / 2.0)));

    CGSize currentSensorTagImageViewSize =
    CGSizeMake(self.sensorTagImageViewSize.width - (acceleration.zComponent / (STAccelerometerRange / 2.0)) * (0.4 * self.sensorTagImageViewSize.width),
               self.sensorTagImageViewSize.height - (acceleration.zComponent / (STAccelerometerRange / 2.0)) * (0.4 * self.sensorTagImageViewSize.height));
    
    self.sensorTagImageView.frame =
    CGRectMake(self.sensorTagImageViewCenter.x - currentSensorTagImageViewSize.width / 2.0 + sensorTagImageViewDisplacement.width,
               self.sensorTagImageViewCenter.y - currentSensorTagImageViewSize.height / 2.0 + sensorTagImageViewDisplacement.height,
               currentSensorTagImageViewSize.width,
               currentSensorTagImageViewSize.height);
}

- (void)sensorTagDidUpdateAngularVelocity: (STAngularVelocity *)angularVelocity
{
    // Log output of angular velocity since it is not presented in the GUI
    // NSLog(@"%@", angularVelocity);
}

- (void)sensorTagDidUpdateMagneticFieldStrength: (float)magneticFieldStrength
{
    self.magneticFieldStrengthBarMeterView.normalizedReading =
    (magneticFieldStrength - STMagneticFieldStrengthMinimum) / (STMagneticFieldStrengthMaximum - STMagneticFieldStrengthMinimum);
}

- (void)sensorTagDidUpdateTemperature: (float)temperature
{
    self.temperatureLabel.text = [NSString stringWithFormat: @"%0.1f °F", temperature];
}

- (void)sensorTagDidUpdateButtonsPressed: (STButtonsPressed)buttonsPressed
{
    switch (buttonsPressed)
    {
        case STButtonsPressedNone:
            [self.leftButtonView depress];
            [self.rightButtonView depress];
            break;
            
        case STButtonsPressedLeft:
            [self.leftButtonView press];
            [self.rightButtonView depress];
            break;
            
        case STButtonsPressedRight:
            [self.leftButtonView depress];
            [self.rightButtonView press];
            break;
            
        case STButtonsPressedBoth:
            [self.leftButtonView press];
            [self.rightButtonView press];
            break;
            
        default:
            [self.leftButtonView depress];
            [self.rightButtonView depress];
            
            NSLog(@"buttonsPressed set to an illegal value: %d", (int)buttonsPressed);
            break;
    }
}

- (void)sensorTagDidEnableSensors
{
}

- (void)sensorTagDidDisableSensors
{
    [self resetUI];
}

- (void)resetUI
{
    self.signalStrengthBarMeterView.normalizedReading = 0.0;
    self.magneticFieldStrengthBarMeterView.normalizedReading = 0.0;
    self.temperatureLabel.text = @"? °F";
}

@end





















