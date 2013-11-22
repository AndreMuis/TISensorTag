//
//  STAcceleration.h
//  TISensorTag
//
//  Created by Andre Muis on 11/15/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STAcceleration : NSObject

@property (readwrite, assign, nonatomic) float xComponent;
@property (readwrite, assign, nonatomic) float yComponent;
@property (readwrite, assign, nonatomic) float zComponent;

@property (readonly, assign, nonatomic) float magnitude;

- (id)initWithXComponent: (float)xComponent yComponent: (float)yComponent zComponent: (float)zComponent;

@end
