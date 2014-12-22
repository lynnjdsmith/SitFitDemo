/*!
 *  @header
 *	@file VTQuatReading.h
 *
 *  @discussion Part of the Node API
 *
 *	@copyright 2012 Variable Technologies. All rights reserved.
 */

////////////////////////////////////////////////////////////////////////////////
/** This class represents a quaternion. */
@interface VTQuatReading : NSObject

/**-----------------------------------------------------------------------------
 * @name Properties
 * -----------------------------------------------------------------------------
 */
/** q0 element of quaternion */
@property (readonly, nonatomic) float q0;
/** q1 element of quaternion */
@property (readonly, nonatomic) float q1;
/** q2 element of quaternion */
@property (readonly, nonatomic) float q2;
/** q3 element of quaternion */
@property (readonly, nonatomic) float q3;

/**-----------------------------------------------------------------------------
 * @name Initialization
 * -----------------------------------------------------------------------------
 */
/** Returns a VTQuatReading object intialized with the four provided values.
 
 @param q0 q0 element of quaternion
 @param q1 q1 element of quaternion
 @param q2 q2 element of quaternion
 @param q3 q3 element of quaternion
 @return A VTQuatReading object intialized with the provided values
 */
-(id) initWithQ0:(float)q0 q1:(float)q1 q2:(float)q2 q3:(float)q3;
@end
