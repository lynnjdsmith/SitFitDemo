//
//  SReading.h
//  SitFitDemo
//
//  Created by Clement Wagner on 1/25/15. It works but I don't understand it. Thank you internet people.
//  Sets up singleton class for sharing sensor readings globally, hopefully with minimal latency (should be possible)
//
//  Copyright (c) 2015 Lynn Smith. All rights reserved.


#import <Foundation/Foundation.h>

@interface SharedReading : NSObject

- (void)setX:(double)value;
- (void)setY:(double)value;

- (double)getX;
- (double)getY;

+ (id)sharedManager;

@end
