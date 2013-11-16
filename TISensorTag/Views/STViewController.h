//
//  STViewController.h
//  TISensorTag
//
//  Created by Andre Muis on 11/14/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "STSensorTagDelegate.h"
#import "STSensorTagManagerDelegate.h"

@class STSensorTagManager;

@interface STViewController : UIViewController <STSensorTagManagerDelegate, STSensorTagDelegate>

@end
