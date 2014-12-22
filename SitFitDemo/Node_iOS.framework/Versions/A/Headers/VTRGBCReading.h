//
//  VTRGBCReading.h
//  Copyright (c) 2013 Variable Technologies. All rights reserved.
//

#import "VTChromaDevice.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

#if TARGET_OS_IPHONE
#define SKColor UIColor
#else
@import AppKit;
#define SKColor NSColor
#endif

////////////////////////////////////////////////////////////////////////////////
/** This class represents a color reading from the Chroma module. */
@interface VTRGBCReading : NSObject
/**-----------------------------------------------------------------------------
 * @name Properties
 * -----------------------------------------------------------------------------
 */
/** The clear sense channel */
@property (readonly, nonatomic) uint16_t senseClear;
/** The red sense channel */
@property (readonly, nonatomic) uint16_t senseRed;
/** The green sense channel */
@property (readonly, nonatomic) uint16_t senseGreen;
/** The blue sense channel */
@property (readonly, nonatomic) uint16_t senseBlue;
/** CIE Tristimulus X value */
@property (readonly, nonatomic) double d65X;
/** CIE Tristimulus Y value */
@property (readonly, nonatomic) double d65Y;
/** CIE Tristimulus Z value */
@property (readonly, nonatomic) double d65Z;
/** CIE Lab L value */
@property (readonly, nonatomic) double d65L;
/** CIE Lab a value */
@property (readonly, nonatomic) double d65a;
/** CIE Lab b value */
@property (readonly, nonatomic) double d65b;
/** sRGB R value */
@property (readonly, nonatomic) double d65srgbR;
/** sRGB G value */
@property (readonly, nonatomic) double d65srgbG;
/** sRGB B value */
@property (readonly, nonatomic) double d65srgbB;
/** CIE Tristimulus X value for D50 reference light*/
@property (readonly, nonatomic) double d50X;
/** CIE Tristimulus Y value for D50 reference light*/
@property (readonly, nonatomic) double d50Y;
/** CIE Tristimulus Z value for D50 reference light*/
@property (readonly, nonatomic) double d50Z;
/** CIE Lab L Value for D50 reference light*/
@property (readonly, nonatomic) double d50L;
/** CIE Lab a Value for D50 reference light*/
@property (readonly, nonatomic) double d50a;
/** CIE Lab b Value for D50 reference light*/
@property (readonly, nonatomic) double d50b;
/** sRGB R for D50 reference light*/
@property (readonly, nonatomic) double d50srgbR;
/** sRGB G for D50 reference light*/
@property (readonly, nonatomic) double d50srgbG;
/** sRGB B for D50 reference light*/
@property (readonly, nonatomic) double d50srgbB;

@property (strong, nonatomic, readonly) SKColor *d50Color;
@property (strong, nonatomic, readonly) SKColor *d65Color;


/**-----------------------------------------------------------------------------
 * @name Recalculation
 * -----------------------------------------------------------------------------
 */

/** Updates the VTRGBCReading object's math (in case of server side calibration updates, etc) and resets the
 XYZ,Lab,RGB values of this object.

 */
-(void) recalculateColorVals;

- (void) initSkColorsWithd50R: (double)r_d50 d50G:(double)g_d50 d50B:(double)b_d50 withd65R: (double)r_d65 d65G:(double)g_d65 d65B:(double)b_d65;


@end
