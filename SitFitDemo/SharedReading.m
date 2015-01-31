//
//  SReading.m
//  SitFitDemo
//
//  Created by Clement Wagner on 1/25/15.
//  Copyright (c) 2015 Lynn Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SharedReading.h"

@class SharedReading;

@implementation SharedReading  

static double x = 0;
static double y = 0;

-(id)init
{
    self = [super init];
    return self;
}

+ (id)sharedManager {
    static SharedReading *sharedMyManager = nil;
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager = [[self alloc] init];
    }
    return sharedMyManager;
}

- (void) setX:(double)value { x = value; };
- (void) setY:(double)value { y = value; };

- (double) getX {return x; };
- (double) getY {return y; };


@end

