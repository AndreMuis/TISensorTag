//
//  STViewController.h
//  TISensorTag
//
//  Created by Andre Muis on 11/14/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>

@interface STViewController : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate>

@end
