//
//  STBarMeterView.h
//  TISensorTag
//
//  Created by Andre Muis on 11/22/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STBarMeterView : UIView

@property (readwrite, assign, nonatomic) float normalizedReading;

- (void)setupWithBackgroundColor: (UIColor *)backgroundColor indicatorColor: (UIColor *)indicatorColor;

@end
