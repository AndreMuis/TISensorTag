//
//  STUtilities.m
//  TISensorTag
//
//  Created by Andre Muis on 11/14/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "STUtilities.h"

@implementation STUtilities

+ (NSString *)stringWithCBUUID: (CBUUID *)uuid
{
    NSData *data = [uuid data];
    
    NSUInteger bytesToConvert = [data length];
    const unsigned char *uuidBytes = [data bytes];
    NSMutableString *outputString = [NSMutableString stringWithCapacity: 16];
    
    for (NSUInteger currentByteIndex = 0; currentByteIndex < bytesToConvert; currentByteIndex++)
    {
        switch (currentByteIndex)
        {
            case 3:
            case 5:
            case 7:
            case 9:
                [outputString appendFormat: @"%02x-", uuidBytes[currentByteIndex]];
                break;
                
            default:
                [outputString appendFormat: @"%02x", uuidBytes[currentByteIndex]];
        }
        
    }
    
    return outputString;
}

+ (float)farenheitWithCelsius: (float)celsius
{
    return celsius * (9.0 / 5.0) + 32.0;
}

@end
