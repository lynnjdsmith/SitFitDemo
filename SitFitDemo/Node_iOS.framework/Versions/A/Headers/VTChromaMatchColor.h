//
//  VTChromaMatchColor.h
//  Node
//
//  Created by Wade Gasior on 3/19/14.
//  Copyright (c) 2014 Variable, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTChromaMatchVendor.h"

#if CHROMA_MATCH_ENABLED == 1

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

@interface VTChromaMatchColor : NSObject

@property (strong, nonatomic, readonly) VTChromaMatchColorSet *colorSet;
@property (strong, nonatomic, readonly) NSString *name;

#if TARGET_OS_IPHONE
#define SKColor UIColor
#else
#define SKColor NSColor
#endif
@property (strong, nonatomic, readonly) SKColor *color;

@property (nonatomic, readonly) double deltaEFromReading;

+ (VTChromaMatchColor *)color;
+ (VTChromaMatchColor *)colorWithdE: (double)dE set: (VTChromaMatchColorSet *)set name: (NSString *)name withColor: (SKColor *)color;

@end
#endif