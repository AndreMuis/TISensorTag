//
//  STBarMeterView.m
//  TISensorTag
//
//  Created by Andre Muis on 11/22/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "STBarMeterView.h"

@interface STBarMeterView ()

@property (readonly, strong, nonatomic) UIView *indicatorView;

@end

@implementation STBarMeterView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
    }
    
    return self;
}

- (void)setupWithBackgroundColor: (UIColor *)backgroundColor indicatorColor: (UIColor *)indicatorColor
{
    self.backgroundColor = backgroundColor;
    
    _indicatorView = [[UIView alloc] initWithFrame: CGRectMake(0.0,
                                                               0.0,
                                                               0.0,
                                                               self.frame.size.height)];
    [self addSubview: self.indicatorView];
    
    self.indicatorView.backgroundColor = indicatorColor;
}

- (void)setNormalizedReading: (float)normalizedReading
{
    if (normalizedReading < 0.0)
    {
        normalizedReading = 0.0;
    }
    else if (normalizedReading > 1.0)
    {
        normalizedReading = 1.0;
    }
    
    self.indicatorView.frame = CGRectMake(self.indicatorView.frame.origin.x,
                                          self.indicatorView.frame.origin.y,
                                          normalizedReading * self.frame.size.width,
                                          self.indicatorView.frame.size.height);
}

@end
