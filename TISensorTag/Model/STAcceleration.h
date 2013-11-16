//
//  STAcceleration.h
//  TISensorTag
//
//  Created by Andre Muis on 11/15/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STAcceleration : NSObject

@property (readonly, assign, nonatomic) float xComponent;
@property (readonly, assign, nonatomic) float yComponent;
@property (readonly, assign, nonatomic) float zComponent;

@property (readonly, assign, nonatomic) float magnitude;

- (id)initWithXComponent: (float)xComponent YComponent: (float)yComponent ZComponent: (float)zComponent;

@end
