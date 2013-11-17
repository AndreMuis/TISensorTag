//
//  STAppDelegate.m
//  TISensorTag
//
//  Created by Andre Muis on 11/14/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "STAppDelegate.h"

#import "STSensorTagManager.h"
#import "STViewController.h"

@interface STAppDelegate ()

@property (readonly, strong, nonatomic) STSensorTagManager *sensorTagManager;

@end

@implementation STAppDelegate

- (BOOL)application: (UIApplication *)application didFinishLaunchingWithOptions: (NSDictionary *)launchOptions
{
    STViewController *viewController = (STViewController *)self.window.rootViewController;
    
    _sensorTagManager = [[STSensorTagManager alloc] initWithDelegate: viewController
                                                   sensorTagDelegate: viewController];
    
    return YES;
}

- (void)applicationDidBecomeActive: (UIApplication *)application
{
    [self.sensorTagManager enableSensors];
}

- (void)applicationWillResignActive: (UIApplication *)application
{
    [self.sensorTagManager disableSensors];
}

@end
