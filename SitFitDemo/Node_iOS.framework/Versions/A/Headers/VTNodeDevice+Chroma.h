//
//  VTNodeDevice+Chroma.h
//  Copyright (c) 2013 Variable Technologies. All rights reserved.
//

#include "VTRGBCReading.h"
#include "VTChromaMatchColorSet.h"

/**
 The `NodeChromaDeviceDelegate` protocol defines the optional Chroma module related methods implemented by delegates of the `VTNodeDevice` class
 */
@protocol NodeChromaDeviceDelegate <NSObject>
@optional
/** Invoked to provide app with requested Chroma Device to use for getting Chroma readings. Provided in response to requestVTChromaDeviceInstance
 @param device The device that communicated the reading
 @param chromaDevice - VTChromaDevice for use with requestChromaReading
 */
-(void) nodeDeviceDidUpdate:(VTNodeDevice *)device withVTChromaDevice:(VTChromaDevice*)chromaDevice;

/** Invoked to provide the app with progress information for the handshake process in requestVTChromaDeviceInstance
 @param device The device that communicated the reading
 @param progressPercent A float representation of the % completion of handshake
 @param message NSString information on handshake progress - can be printed to screen in the app if desired. 
 */
-(void) nodeDeviceDidUpdateHandshakeProgress:(VTNodeDevice *)device withProgress:(NSNumber*)progressPercent withMessage:(NSString*)message;

/** Invoked when a Node device has communicated a color reading from an attached Chroma module
 @param device The device that communicated the reading
 @param reading A VTRGBCReading object containing the color values read
 */
-(void) nodeDeviceDidUpdateChromaReading:(VTNodeDevice *) device withReading:(VTRGBCReading *) reading;

/** Invoked when a Node device has communicated a temperature reading in C from an attached Chroma module
 @param device The device that communicated the reading
 @param temperature A float representation of the temp in chroma in deg C
 */
-(void) nodeDeviceDidUpdateChromaTemp:(VTNodeDevice *) device withTemperature:(float)temperature;

/** Invoked to notify app that the connected Chroma has completed the requested whitepoint calibration
 @param device The device that communicated the reading
 @param status Pass/Fail condition of whitepoint calibration
 */
-(void)nodeDeviceDidCompleteChromaWhitePointCal:(VTNodeDevice *) device withStatus:(BOOL)status;

-(void)nodeDeviceDidProvideChromaMatchResults:(VTNodeDevice *) device usingVTChromaDevice: (VTChromaDevice *)chromaDevice usingReading: (VTRGBCReading *)reading withResults:(NSArray *)results error:(NSError*)error;

@end

@interface VTNodeDevice (Chroma)

/** Request the NODE API to create a VTChromaDevice instance with all the required calibration/batching data and provide instance back to the app layer
    This method performs an HTTP request to retrieve the required Chroma data.
 */
-(void)requestVTChromaDeviceInstance;

/** Request a Chroma reading for a specific device 
 @param chromaDevice The Chroma device's class w/ specific parameters for calibration and type
 */
-(void) requestChromaReadingWChromaDevice:(VTChromaDevice *)chromaDevice;

/** Request a "Batch Relative" Chroma reading for a specific device.
 Batch relative readings are readings that guarantee that your color reading will be within ∆E1.5 to the batch master unit that the Chroma belongs to.  
 @param chromaDevice The Chroma device's class w/ specific parameters for calibration and type
 */
-(void) requestBatchRelativeChromaReadingWChromaDevice:(VTChromaDevice *)chromaDevice;

/** Request Chroma  1.1+ to perform whitepoint calibration using end cap and
 @param cryptoSet array from Chroma module (get this using requestCryptoData).
 */
-(void)requestChromaWhitePointCalWith:(VTChromaDevice *)chromaDevice;

/** Clear Chroma  1.1+ whitepoint calibration - use default calibration
 */
-(void)clearChromaWhitePointCal;

/** Request a the temperature in degrees C within the Chroma module (valid for CHroma 1.1 and newer). 
    The requestChromaReadingWChromaDevice: auto-sends temperature to delegate, so the below is depreciated
 @param takeNewTemperatureReading is a bool used to request new temp reading instead of the last reading seen @ color read
 */
-(void) requestChromaTemp:(BOOL)takeNewTemperatureReading __deprecated;;

#if CHROMA_MATCH_ENABLED == 1
/**
    Request a Chroma match reading
    @param colorset The VTChromaMatchColorSet from which to match
    @param device A valid VTChromaDevice object to use for color math
 */
- (void) requestChromaMatchReadingUsingColorSet: (VTChromaMatchColorSet *)colorSet withDevice: (VTChromaDevice *)device;
#endif

@end