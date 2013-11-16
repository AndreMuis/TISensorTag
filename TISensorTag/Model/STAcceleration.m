//
//  STAcceleration.m
//  TISensorTag
//
//  Created by Andre Muis on 11/15/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "STAcceleration.h"

#import "STUtilities.h"

@implementation STAcceleration

- (id)initWithXComponent: (float)xComponent YComponent: (float)yComponent ZComponent: (float)zComponent
{
    self = [super init];
    
    if (self)
    {
        _xComponent = xComponent;
        _yComponent = yComponent;
        _zComponent = zComponent;
    }
    
    return self;
}

- (float)magnitude
{
    return [STUtilities vectorMagnitudeWithXComponent: self.xComponent
                                           YComponent: self.yComponent
                                           ZComponent: self.zComponent];
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat: @"<%@: %p; ", [self class], self];
    desc = [desc stringByAppendingFormat: @"xComponent = %f; ", self.xComponent];
    desc = [desc stringByAppendingFormat: @"yComponent = %f; ", self.yComponent];
    desc = [desc stringByAppendingFormat: @"zComponent = %f>", self.zComponent];
    
    return desc;
}

@end
