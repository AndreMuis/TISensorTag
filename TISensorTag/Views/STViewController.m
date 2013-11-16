//
//  STViewController.m
//  TISensorTag
//
//  Created by Andre Muis on 11/14/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "STViewController.h"

#import "STButtonSensor.h"
#import "STSensorTagManager.h"

@interface STViewController ()

@property (weak, nonatomic) IBOutlet UILabel *centralManagerStateLabel;

@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;

@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;

@property (weak, nonatomic) IBOutlet UILabel *accelerationLabel;
@property (weak, nonatomic) IBOutlet UILabel *accelerationMagnitudeLabel;

@property (weak, nonatomic) IBOutlet UILabel *angularVelocityLabel;
@property (weak, nonatomic) IBOutlet UILabel *angularVelocityMagnitudeLabel;

@property (weak, nonatomic) IBOutlet UILabel *magneticFieldStrengthLabel;

@property (weak, nonatomic) IBOutlet UILabel *buttonPressedLabel;

@end

@implementation STViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.centralManagerStateLabel.backgroundColor = [UIColor clearColor];
    
    self.rssiLabel.backgroundColor = [UIColor clearColor];
    
    self.temperatureLabel.backgroundColor = [UIColor clearColor];
    
    self.accelerationLabel.backgroundColor = [UIColor clearColor];
    self.accelerationMagnitudeLabel.backgroundColor = [UIColor clearColor];

    self.angularVelocityLabel.backgroundColor = [UIColor clearColor];
    self.angularVelocityMagnitudeLabel.backgroundColor = [UIColor clearColor];

    self.magneticFieldStrengthLabel.backgroundColor = [UIColor clearColor];

    self.buttonPressedLabel.backgroundColor = [UIColor clearColor];
}

- (void)sensorTagManagerDidUpdateState: (NSString *)state
{
    self.centralManagerStateLabel.text = state;
}

- (void)sensorTagDidUpdateRSSI: (NSNumber *)rssi;
{
    self.rssiLabel.text = [rssi stringValue];
}

- (void)sensorTagDidUpdateAcceleration: (STAcceleration *)acceleration
{
    self.accelerationLabel.text = [NSString stringWithFormat: @"<%.2f, %.2f, %.2f>", acceleration.xComponent, acceleration.yComponent, acceleration.zComponent];
    self.accelerationMagnitudeLabel.text = [NSString stringWithFormat: @"%.2f", acceleration.magnitude];
}

- (void)sensorTagDidUpdateButtonPressed: (STButton)button
{
    switch (button)
    {
        case STButtonNone:
            self.buttonPressedLabel.text = @"None";
            break;
            
        case STButtonLeft:
            self.buttonPressedLabel.text = @"Left";
            break;

        case STButtonRight:
            self.buttonPressedLabel.text = @"Right";
            break;

        default:
            NSLog(@"button set to an illegal value: %d", button);
            break;
    }
}

- (void)sensorTagDidUpdateAngularVelocity: (STAngularVelocity *)angularVelocity
{
    self.angularVelocityLabel.text = [NSString stringWithFormat: @"<%.0f, %.0f, %.0f>", angularVelocity.xComponent, angularVelocity.yComponent, angularVelocity.zComponent];
    self.angularVelocityMagnitudeLabel.text = [NSString stringWithFormat: @"%.0f", angularVelocity.magnitude];
}

- (void)sensorTagDidUpdateMagneticFieldStrength: (float)magneticFieldStrength
{
    self.magneticFieldStrengthLabel.text = [NSString stringWithFormat: @"%.0f", magneticFieldStrength];
}

- (void)sensorTagDidUpdateTemperature: (float)temperature
{
    self.temperatureLabel.text = [NSString stringWithFormat: @"%0.1f °F", temperature];
}

@end





















