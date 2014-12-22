//
//  VTSensorReading.h
//  Copyright (c) 2013 Variable Technologies. All rights reserved.
//

////////////////////////////////////////////////////////////////////////////////
/** A triple-axis sensor reading. */

@interface VTSensorReading : NSObject
/**-----------------------------------------------------------------------------
 * @name Properties
 * -----------------------------------------------------------------------------
 */
/** The x axis reading */
@property (readonly, nonatomic) float x;
/** The y axis reading */
@property (readonly, nonatomic) float y;
/** The z axis reading */
@property (readonly, nonatomic) float z;

/**-----------------------------------------------------------------------------
 * @name Initialization
 * -----------------------------------------------------------------------------
 */
/** Returns a VTSensorReading object initialized with the three provided values.
 
 @param xVal The x axis value for the new reading
 @param yVal The y axis value for the new reading
 @param zVal The z axis value for the new reading
 @return A VTSensorReading initalized with the given values.
 */
-(id) initWithXValue: (float)xVal y: (float)yVal z: (float)zVal;

@end
