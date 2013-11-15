//
//  STViewController.m
//  TISensorTag
//
//  Created by Andre Muis on 11/14/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "STViewController.h"

#import "STSensorTagManager.h"

@interface STViewController ()

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *accelerometerLabel;

@end

@implementation STViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.stateLabel.backgroundColor = [UIColor clearColor];
    self.temperatureLabel.backgroundColor = [UIColor clearColor];
    self.accelerometerLabel.backgroundColor = [UIColor clearColor];
}

- (void)centralManagerDidUpdateState: (NSString *)state
{
    self.stateLabel.text = state;
}

@end





















