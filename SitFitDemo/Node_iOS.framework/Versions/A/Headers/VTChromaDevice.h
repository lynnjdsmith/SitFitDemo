/*!
 *  @header
 *	@file VTChromaDevice.h
 *
 *  @discussion Part of the Node API
 *
 *	@copyright 2012 Variable Technologies. All rights reserved.
 */

////////////////////////////////////////////////////////////////////////////////
/** This class represents the specific device used for getting a color reading from the Chroma module. */

#import <Foundation/Foundation.h>

@protocol VTChromaDeviceDelegate <NSObject>
@optional
-(void)chromaDeviceCalibrationSynchronizing:(float)progress;
@end



@interface VTChromaDevice : NSObject

/**-----------------------------------------------------------------------------
 * @name Properties
 * -----------------------------------------------------------------------------
 */
/** Chroma Type */
@property (readonly, nonatomic) NSString* chromaType;
/** Chroma Batch # */
@property (readonly, nonatomic) NSNumber* chromaBatch;
/** Chroma Calibration Data */
@property (readonly, nonatomic) NSData* chromaCal;
/** Chroma Serial */
@property (readonly, nonatomic) NSString* chromaSerial;
/** Is this Chroma capable of performing whitepoint calibration? */
@property (readonly, nonatomic) BOOL isWhitePointCalibratable;
/** Chroma Device Delegate - update on performing calibration data synchronization */
@property (atomic, assign) id delegate;

/**-----------------------------------------------------------------------------
 * @name Initialization
 * -----------------------------------------------------------------------------
 */
/** Returns a VTChromaDevice object initialized with the four provided values.
 
 @param chromaSerial Chroma module's serial #
 @param chromaModel Chroma Type (1.0, 1.1, 1.2, ...etc)
 @param chromaBatch Batching # of this Chroma (1, 2, 3, ...)
 @param calSet Chroma device specific calibration information
 @return A VTChromaDevice object initialized
 */
-(id) initWithSerial:(NSString*)chromaSerial chromaModelType:(NSString*)chromaModel chromaBatch:(NSNumber*)chromaBatch calSet:(NSData*)calSet;

/** Ensures that the API is synchronized and using the very latest LUTs for this chroma device.
 */
-(BOOL)synchChromaDevice;

@end
