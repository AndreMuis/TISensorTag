//
//  STViewController.m
//  TISensorTag
//
//  Created by Andre Muis on 11/14/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "STViewController.h"

#import "STButtonSensor.h"
#import "STButtonView.h"
#import "STConstants.h"
#import "STSensorTagManager.h"

@interface STViewController ()

@property (weak, nonatomic) IBOutlet UILabel *centralManagerStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *connectionStatusLabel;

@property (weak, nonatomic) IBOutlet UIView *signalStrengthBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *signalStrengthView;

@property (weak, nonatomic) IBOutlet UIImageView *sensorTagImageView;
@property (readonly, assign, nonatomic) CGPoint sensorTagImageViewCenter;

@property (weak, nonatomic) IBOutlet UIView *magneticFieldStrengthBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *magneticFieldStrengthView;

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
    
    _sensorTagImageViewCenter = self.sensorTagImageView.center;
    
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

- (void)sensorTagDidUpdateRSSI: (NSNumber *)rssi;
{
    float rssiValue = [rssi floatValue];
    
    if (rssiValue < STRSSIMinimum)
    {
        rssiValue = STRSSIMinimum;
    }
    else if (rssiValue > STRSSIMaximum)
    {
        rssiValue = STRSSIMaximum;
    }
    
    CGFloat signalStrengthViewWidth = self.signalStrengthBackgroundView.frame.size.width *
    (rssiValue - STRSSIMinimum) / (STRSSIMaximum - STRSSIMinimum);
    
    self.signalStrengthView.frame = CGRectMake(self.signalStrengthView.frame.origin.x,
                                               self.signalStrengthView.frame.origin.y,
                                               signalStrengthViewWidth,
                                               self.signalStrengthView.frame.size.height);
}

- (void)sensorTagDidUpdateAcceleration: (STAcceleration *)acceleration
{
    self.sensorTagImageView.center = CGPointMake(self.sensorTagImageViewCenter.x + 50.0 * acceleration.xComponent,
                                                 self.sensorTagImageViewCenter.y + 50.0 * acceleration.yComponent);
}

- (void)sensorTagDidUpdateAngularVelocity: (STAngularVelocity *)angularVelocity
{
}

- (void)sensorTagDidUpdateMagneticFieldStrength: (float)magneticFieldStrength
{
    if (magneticFieldStrength < STMagneticFieldStrengthMinimum)
    {
        magneticFieldStrength = STMagneticFieldStrengthMinimum;
    }
    else if (magneticFieldStrength > STMagneticFieldStrengthMaximum)
    {
        magneticFieldStrength = STMagneticFieldStrengthMaximum;
    }
    
    CGFloat magneticFieldStrengthViewWidth = self.magneticFieldStrengthBackgroundView.frame.size.width *
    (magneticFieldStrength - STMagneticFieldStrengthMinimum) / (STMagneticFieldStrengthMaximum - STMagneticFieldStrengthMinimum);
    
    self.magneticFieldStrengthView.frame = CGRectMake(self.magneticFieldStrengthView.frame.origin.x,
                                                      self.magneticFieldStrengthView.frame.origin.y,
                                                      magneticFieldStrengthViewWidth,
                                                      self.magneticFieldStrengthView.frame.size.height);
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
    self.signalStrengthView.frame = CGRectMake(self.signalStrengthView.frame.origin.x,
                                               self.signalStrengthView.frame.origin.y,
                                               0.0,
                                               self.signalStrengthView.frame.size.height);
    
    self.magneticFieldStrengthView.frame = CGRectMake(self.magneticFieldStrengthView.frame.origin.x,
                                                      self.magneticFieldStrengthView.frame.origin.y,
                                                      0.0,
                                                      self.magneticFieldStrengthView.frame.size.height);

    self.temperatureLabel.text = @"? °F";
}

@end





















