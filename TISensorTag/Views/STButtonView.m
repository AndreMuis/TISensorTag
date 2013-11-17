//
//  STButtonView.m
//  TISensorTag
//
//  Created by Andre Muis on 11/16/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "STButtonView.h"

@interface STButtonView ()

@property (readonly, assign, nonatomic) CGRect depressedFrame;
@property (readonly, assign, nonatomic) CGRect pressedFrame;

@end

@implementation STButtonView

- (id)initWithCoder: (NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    
    if (self)
    {
        _depressedFrame = CGRectZero;
        _pressedFrame = CGRectZero;
    }

    return self;
}

- (void)setup
{
    _depressedFrame = self.frame;

    _pressedFrame = CGRectMake(self.frame.origin.x,
                               self.frame.origin.y + self.frame.size.height * 0.3,
                               self.frame.size.width,
                               self.frame.size.height * 0.7);

    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect: self.bounds
                                                     byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight
                                                           cornerRadii: CGSizeMake(15.0, 15.0)];
        
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.path = bezierPath.CGPath;
        
    self.layer.mask = shapeLayer;
}

- (void)press
{
    self.frame = self.pressedFrame;
}

- (void)depress
{
    self.frame = self.depressedFrame;
}

@end





















