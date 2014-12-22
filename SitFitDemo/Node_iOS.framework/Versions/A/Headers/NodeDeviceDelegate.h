//
//  NodeDeviceDelegate.h
//  Copyright (c) 2013 Variable Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTNodeTypes.h"

@class VTNodeDevice;
@class VTSensorReading;
@class VTQuatReading;

/**
 The `NodeDeviceDelegate` protocol defines the optional methods implemented by delegates of the VTNodeDevice class.
 */
@protocol NodeDeviceDelegate <NSObject>

@optional
#pragma mark - Initialization
/**-----------------------------------------------------------------------------
 * @name Initialization
 * -----------------------------------------------------------------------------
 */
/** Invoked when the Node device is ready for communication
    When this is invoked, the following properties of
    the device will be populated:
        * model
        * firmwareMajorRev
        * firmwareMinorRev
        * module_a_type
        * module_b_type
        * module_a_subtype
        * module_b_subtype
        * module_a_version
        * module_b_version
        * koreSerial
        * moduleASerial
        * moduleBSerial
        * batteryLevel
 @param device The Node device that is ready
 **/
-(void)nodeDeviceIsReadyForCommunication:(VTNodeDevice *)device;

/** Invoked if a Node device fails to initialize.
 If this is invoked, the VTNodeDevice object should be treated as invalid.
 
 @param device      The invalid VTNodeDevice
 */
-(void)nodeDeviceFailedToInit:(VTNodeDevice *)device;
#pragma mark -

#pragma mark - Connection
/**-----------------------------------------------------------------------------
 * @name Connection
 * -----------------------------------------------------------------------------
 */
/** Invoked when the CBPeripheral object belonging to a Node device has updated its RSSI
 
 @param device The device that updated its RSSI
 @param error		If an error occurred, the cause of the failure.
 */
-(void)nodeDeviceDidUpdateRSSI: (VTNodeDevice *)device error:(NSError *)error;
#pragma mark -

#pragma mark - Utility
/**-----------------------------------------------------------------------------
 * @name Utility
 * -----------------------------------------------------------------------------
 */
/** Invoked when the CBPeripheral object belonging to a Node device has updated its name
 
 @param device The device that updated its name
 */
-(void)nodeDeviceDidUpdateName: (VTNodeDevice *)device;

/** Invoked when a Node device communicates its crypto data block (512 bytes)
 @param device The device that communicated its crypto information
 @param dataBlock 512 bytes of data from the crypto chip
 
 */

/** Invoked when a Node device communicates its current battery level
 
 @param device The device that communicated its battery level
 @param reading The current battery level expressed as a raw voltage (typically 3.6 to 4.1 volts)
 */
-(void) nodeDeviceDidUpdateBatteryLevel: (VTNodeDevice *) device withReading: (float) reading;

/** Invoked when a Node device communicates that its hardware button has been depressed.
 
 @param device The device that communicated the event
 */
-(void) nodeDeviceButtonPushed: (VTNodeDevice *) device;

/** Invoked when a Node device communicates that its hardware button has been released.
 
 @param device The device that communicated the event
 */
-(void) nodeDeviceButtonReleased: (VTNodeDevice *) device;

/** Invoked when a Node device has communicated which modules it has attached
 
 @param device The device that communicated its module types
 @param typeA The code of the module attached to port A (for codes, see defines at top of libNode.h)
 @param typeB The code of the module attached to port B (for codes, see defines at top of libNode.h)
 */
-(void) nodeDeviceDidUpdateModuleTypes: (VTNodeDevice *) device typeA: (VTNodeModuleType) typeA typeB: (VTNodeModuleType) typeB;

/** Invoked when a Node device has communicated the subtypes of its connected moduels
 @param device The device that communicated its module types
 @param typeA The subtype of the module connected to port A (for codes, see defines at top of libNode.h)
 @param typeB The subtype of the module connected to port B (for codes, see defines at top of libNode.h)
 */
-(void) nodeDeviceDidUpdateModuleSubTypes: (VTNodeDevice *) device typeA: (VTNodeModuleSubType) typeA typeB: (VTNodeModuleSubType) typeB;

/** Requires 3.10 Firmware. Invoked when a Node device has communicated the subtypes of its connected moduels
 @param device The device that communicated its module types
 @param verA The version of the module connected to port A (for codes, see defines at top of libNode.h)
 @param verB The version of the module connected to port B (for codes, see defines at top of libNode.h)
 */
-(void) nodeDeviceDidUpdateModuleVersions:(VTNodeDevice *)device verA:(uint8_t)verA verB:(uint8_t)verB;

/** Requires 3.14 Firmware. Invoked when a Node device responds to a request for Module Stat All
 @param device The device that communicated its module types
 @param typeA The code of the module attached to port A (for codes, see defines at top of libNode.h)
 @param typeB The code of the module attached to port B (for codes, see defines at top of libNode.h)
 @param subtypeA The subtype of the module connected to port A (for codes, see defines at top of libNode.h)
 @param subtypeB The subtype of the module connected to port B (for codes, see defines at top of libNode.h)
 @param verA The version of the module connected to port A (for codes, see defines at top of libNode.h)
 @param verB The version of the module connected to port B (for codes, see defines at top of libNode.h)
 @param koreSerial The device's serial number
 @param modASerial MOD A's serial number
 @param modBSerial MOD B's serial number
 */
-(void)nodeDeviceDidUpdateAllModuleStatus:(VTNodeDevice *)device typeA:(VTNodeModuleType)typeA typeB:(VTNodeModuleType)typeB subtypeA:(VTNodeModuleSubType)subtypeA subtypeB:(VTNodeModuleSubType)subtypeB verA:(uint8_t)verA verB:(uint8_t)verB koreSerial:(NSString *)koreSerial modASerial:(NSString *)modASerial modBSerial:(NSString *)modBSerial;

/** Invoked when a Node device has communicated its serial number
 @param device The device that communicated its module types
 @param koreSerial The device's serial number
 
 */
-(void) nodeDeviceDidUpdateSerialNumberForKore: (VTNodeDevice *)device koreSerial: (NSString *)koreSerial;

/** Invoked when a Node device has communicated the serial number of an attached module
 @param device The device that communicated its module types
 @param module Which port the module is on
 @param serial The module's serial number
 */
-(void) nodeDeviceDidUpdateSerialNumberForModule: (VTNodeDevice *)device module: (VTModuleLocation)module serial:(NSString *)serial;

/** Invoked when a Node device has communicated its firmware version number
 @param device The device that communicated its firmware version
 @param majorRev The major revision number
 @param minorRev The minor revision number
 
 */
-(void) nodeDeviceDidUpdateFirmwareVersionNumber: (VTNodeDevice *)device majorRevision: (uint8_t)majorRev minorRevision: (uint8_t)minorRev;

/**
 Invoked when a NODE device transmits a block of data from its crypto storage
 @param device The `VTNodeDevice` object representing the device that transmitted 
 @param dataBlock A pointer to the bytes transmitted
 */
-(void) nodeDeviceDidTransmitCryptoDataBlock: (VTNodeDevice *) device withBlock: (uint8_t *)dataBlock;

/** Invoked when a Node device has ACK'ed an OTA packet
 @param device The device involved in this communication
 @param address The address being ACK'ed
 */
-(void) nodedeviceDidAckOtaPacket:(VTNodeDevice *)device forAddress:(uint32_t)address;
#pragma mark -

#pragma mark - Device Settings
/**-----------------------------------------------------------------------------
 * @name Device Settings
 * -----------------------------------------------------------------------------
 */
/** Invoked when a Node device communicates its quietmode status
 
 @param device The Node device
 @param setting The device's quietmode
 */
-(void) nodeDeviceDIdUpdateQuietModeSetting: (VTNodeDevice *)device withSetting:(VTNodeQuietModeSetting)setting;
#pragma mark -

#pragma mark - Motion
/**-----------------------------------------------------------------------------
 * @name Motion
 * -----------------------------------------------------------------------------
 */
/** Invoked when a Node device communicates a gyroscope reading
 This method is deprecated and should only be used with NK-01 devices. 
 It is advised to use timestamped motion data for NK-02 devices.
 Please use the
 -(void) setStreamModeWithTimestampingEnabledForAcc: (bool)aMode Gyro:(bool)gMode Mag:(bool)mMode withPeriod:(uint16_t)p withLifetime:(uint16_t)life;
 or
 -(void) setStreamModeWithTimestampingEnabledForAcc: (bool)aMode Gyro:(bool)gMode Mag:(bool)mMode;
 functions to start motion streaming, and then use the apropriate timestamp-enabled delegate callbacks to receive motion data.
 
 @param device The device that communicated its Gyro reading
 @param reading A VTSensorReading object containing the gyroscope reading
 */
-(void) nodeDeviceDidUpdateGyroReading: (VTNodeDevice *) device withReading: (VTSensorReading*)reading __deprecated;

/** Invoked when a Node device communicates an accelerometer reading
 This method is deprecated and should only be used with NK-01 devices.
 It is advised to use timestamped motion data for NK-02 devices.
 Please use the
 -(void) setStreamModeWithTimestampingEnabledForAcc: (bool)aMode Gyro:(bool)gMode Mag:(bool)mMode withPeriod:(uint16_t)p withLifetime:(uint16_t)life;
 or
 -(void) setStreamModeWithTimestampingEnabledForAcc: (bool)aMode Gyro:(bool)gMode Mag:(bool)mMode;
 functions to start motion streaming, and then use the apropriate timestamp-enabled delegate callbacks to receive motion data.
 
 @param device The device that communicated an accelerometer reading
 @param reading A VTSensorReading object containing the accelerometer reading
 */
-(void) nodeDeviceDidUpdateAccReading: (VTNodeDevice *) device withReading: (VTSensorReading*)reading __deprecated;

/** Invoked when a Node device communicates a magnetometer reading
 This method is deprecated and should only be used with NK-01 devices.
 It is advised to use timestamped motion data for NK-02 devices.
 Please use the
 -(void) setStreamModeWithTimestampingEnabledForAcc: (bool)aMode Gyro:(bool)gMode Mag:(bool)mMode withPeriod:(uint16_t)p withLifetime:(uint16_t)life;
 or
 -(void) setStreamModeWithTimestampingEnabledForAcc: (bool)aMode Gyro:(bool)gMode Mag:(bool)mMode;
 functions to start motion streaming, and then use the apropriate timestamp-enabled delegate callbacks to receive motion data.
 
 @param device The device that communicated a magnetometer reading
 @param reading A VTSensorReading object containing the magnetometer reading
 */
-(void) nodeDeviceDidUpdateMagReading: (VTNodeDevice *) device withReading: (VTSensorReading*)reading __deprecated;

/** Invoked when a Node device communicates a timestamped gyroscope reading
 
 @param device The device that communicated its Gyro reading
 @param reading A VTSensorReading object containing the gyroscope reading
 @param date The date (timestamp) of this reading, set by NODE
 */
-(void) nodeDeviceDidUpdateGyroReading: (VTNodeDevice *) device withReading: (VTSensorReading*)reading atTime: (NSDate *)date;

/** Invoked when a Node device communicates a timestamped accelerometer reading
 
 @param device The device that communicated an accelerometer reading
 @param reading A VTSensorReading object containing the accelerometer reading
 @param date The date (timestamp) of this reading, set by NODE
 */
-(void) nodeDeviceDidUpdateAccReading: (VTNodeDevice *) device withReading: (VTSensorReading*)reading atTime: (NSDate *)date;

/** Invoked when a Node device communicates a timestamped magnetometer reading
 
 @param device The device that communicated a magnetometer reading
 @param reading A VTSensorReading object containing the magnetometer reading
@param date The date (timestamp) of this reading, set by NODE
 */
-(void) nodeDeviceDidUpdateMagReading: (VTNodeDevice *) device withReading: (VTSensorReading*)reading atTime: (NSDate *)date;

/** Invoked when a Node device communicates its current orientation in quaternion format
 
 @param device The device that communicated its orientation
 @param reading A VTQuatReading object containing a four-dimensional quaternion value that represents the device's orientation
 */
-(void) nodeDeviceDidUpdateQuatReading: (VTNodeDevice *) device withReading: (VTQuatReading *)reading;

/** Invoked when a Node device has communicated its Kore configuration
 @param device The device involved in this communication
 @param config VTNodeKoreConfig struct with settings of unit
 */
-(void) nodeDeviceDidUpdateKoreConfiguration: (VTNodeDevice *)device withConfig:(VTNodeKoreConfig)config;

/** Invoked when a NODE device transmits a motion / no-motion event
 @param device The device involved in this communication
 @param event The event
 */
-(void) nodeDeviceDidTransmitMotionEvent: (VTNodeDevice *)device ofType: (VTNodeMotionEventType) event;

-(void) nodeDeviceDidTransmitHSAEvent: (VTNodeDevice *)device ofType: (VTNodeHSAEventType) event;

-(void) nodeDeviceDidBeginHSATransmission: (VTNodeDevice *)device withNumberOfReadings: (uint32_t)numReadings withFrequency: (float) freq forWave: (uint8_t)wave withNumberOfWaves: (uint8_t)numWaves;

-(void) nodeDeviceDidCompleteHSATransmission: (VTNodeDevice *)device;

-(void) nodeDeviceDidTransmitHSAReading: (VTNodeDevice *)device reading: (VTSensorReading *)reading;

#pragma mark -

#pragma mark IO Module
/**-----------------------------------------------------------------------------
 * @name IO Module
 * -----------------------------------------------------------------------------
 */

/** Invoked when a Node device receives bytes over UART
 
 @param device The device that communicated an ambient temperature reading
 @param packet NSData binary data from UART
 @param payloadSize # of valid bytes contained in the payload.
 */
-(void)nodeDevice:(VTNodeDevice *)device didTransmitIOModuleUartPacket:(NSData*)packet withPayloadSize:(uint8_t)payloadSize;

/** Invoked when a Node device provides the state of IO Modules D7-D0 pins
 @param device The device that communicated an ambient temperature reading
 @param d7_to_d0 On/Off state of D7-D0 pins.
 */
-(void)nodeDevice:(VTNodeDevice *)device didTransmitIOModulePins:(uint8_t)d7_to_d0;

/** Invoked when a Node device provides the state of IO Modules D7-D0 pins
 @param device          The device that communicated an ambient temperature reading
 @param trigger_pins    Which D7-D0 pins triggered the interrupt in question.
 */
-(void)nodeDevice:(VTNodeDevice *)device didTransmitIOModuleIrq:(uint8_t)trigger_pins;


/** Invoked when a Node device provides the state of one of the IO Modules A2D's
 @param device The device that communicated an ambient temperature reading
 @param a0_or_a1 Indicates if A2D reading is from A0 or A1.
 @param value Float val for A2D (0 to 1 represents the % of VDD (3.3V) that the A2D sees).
 */
-(void)nodeDevice:(VTNodeDevice *)device didTransmitIOModuleA2D:(uint8_t)a0_or_a1 value:(float)value;
#pragma mark -

#pragma mark Clima Module
/**-----------------------------------------------------------------------------
 * @name Clima Module
 * -----------------------------------------------------------------------------
 */
/** Invoked when a Node device communicates an ambient temperature reading from an attached Clima module
 
 @param device The device that communicated an ambient temperature reading
 @param reading The ambient temperature in degrees celsius
 @param date The date (timestamp) of this reading, set by NODE
 */
-(void) nodeDeviceDidUpdateClimaTempReading: (VTNodeDevice *) device withReading: (float) reading atTime: (NSDate *)date;

/** Invoked when a Node device communicates an ambient temperature reading from an attached Clima module
 
 @param device The device that communicated an ambient temperature reading
 @param reading The ambient temperature in degrees celsius
 */
-(void) nodeDeviceDidUpdateClimaTempReading: (VTNodeDevice *) device withReading: (float) reading;

/** Invoked when a Node device communicates a humidity reading from an attached Clima module
 
 @param device The device that communicated the reading
 @param reading The relative humidity level (in percent)
 
 */
-(void) nodeDeviceDidUpdateClimaHumidityReading: (VTNodeDevice *) device withReading: (float) reading;

/** Invoked when a Node device communicates a humidity reading from an attached Clima module
 
 @param device The device that communicated the reading
 @param reading The relative humidity level (in percent)
 @param date The date (timestamp) of this reading, set by NODE
 */
-(void) nodeDeviceDidUpdateClimaHumidityReading: (VTNodeDevice *) device withReading: (float) reading atTime: (NSDate *)date;

/** Invoked when a Node device communicates a barometric pressure reading from an attached Clima module
 
 @param device The device that communicated the reading
 @param reading The barometric pressure level in kPa
 
 */
-(void) nodeDeviceDidUpdateClimaPressureReading: (VTNodeDevice *) device withReading: (float) reading;

/** Invoked when a Node device communicates a barometric pressure reading from an attached Clima module
 
 @param device The device that communicated the reading
 @param reading The barometric pressure level in kPa
 @param date The date (timestamp) of this reading, set by NODE
 */
-(void) nodeDeviceDidUpdateClimaPressureReading: (VTNodeDevice *) device withReading: (float) reading atTime: (NSDate *)date;

/** Invoked when a Node device communicates an ambient light level reading from an attached Clima module
 
 @param device The device that communicated the reading
 @param reading The ambient light level in lux
 
 */
-(void) nodeDeviceDidUpdateClimaLightReading: (VTNodeDevice *) device withReading: (float) reading;

/** Invoked when a Node device communicates an ambient light level reading from an attached Clima module
 
 @param device The device that communicated the reading
 @param reading The ambient light level in lux
 @param date The date (timestamp) of this reading, set by NODE
 */
-(void) nodeDeviceDidUpdateClimaLightReading: (VTNodeDevice *) device withReading: (float) reading atTime: (NSDate *)date;

#pragma mark Clima Pro Specific
/** Invoked when a Node device communicates a humidity reading from an attached Clima Pro module
 
 @param device The device that communicated the reading
 @param reading The relative humidity level (in percent)
 
 */
-(void) nodeDeviceDidUpdateClimaProHumidityReading: (VTNodeDevice *) device withReading: (float) reading;

/** Invoked when a Node device communicates an ambient light level reading from an attached Clima Pro module
 
 @param device The device that communicated the reading
 @param reading The ambient light level in lux
 
 */
-(void) nodeDeviceDidUpdateClimaProLightReading: (VTNodeDevice *) device withReading: (float) reading;

/** Invoked when a Node device communicates a barometric pressure reading from an attached Clima Pro module
 
 @param device The device that communicated the reading
 @param reading The barometric pressure level in kPa
 
 */
-(void) nodeDeviceDidUpdateClimaProPressureReading: (VTNodeDevice *) device withReading: (float) reading;

/** Invoked when a Node device communicates an ambient temperature reading from an attached Clima Pro module
 
 @param device The device that communicated an ambient temperature reading
 @param reading The ambient temperature in degrees celsius
 */
-(void) nodeDeviceDidUpdateClimaProTempReading: (VTNodeDevice *) device withReading: (float) reading;

/** Invoked when a Node device communicates storm data from an attached Clima Pro module
 
 @param device The device that communicated an ambient temperature reading
 @param updateType Update type (valid distance, storm out of range
 @param distance The distance (in km) that NODE+ClimaPro is from the edge of the storm up to 40km
 */
-(void) nodeDeviceDidUpdateClimaProLightningReading:(VTNodeDevice *)device withUpdateType:(VTNodeLightinngStatus)updateType withDistanceToStorm:(uint8_t)distance;
#pragma mark -

#pragma mark OXA Module
/**-----------------------------------------------------------------------------
 * @name OXA Module
 * -----------------------------------------------------------------------------
 */
/** Invoked when a Node device communicates an OXA module reading
 This function is deprecated. It is advised to start OXA module streams using 
 -(void) setStreamModeOxa:(bool)oxaMode forModulePort: (VTModuleLocation)port withPeriod:(uint16_t)p withLifetime:(uint16_t)life;
 or
 -(void) setStreamModeOxa:(bool)oxaMode forModulePort: (VTModuleLocation) port withTiaGain:(uint8_t)tia_gain withRLoad:(uint8_t)rload withRefSource:(uint8_t)ref_source withIntZ:(uint8_t)int_z withBiasSign:(uint8_t)bias_sign withBias:(uint8_t)bias withFetShort:(uint8_t)fet_short withOpMode:(uint8_t)op_mode withPeriod:(uint16_t)p withLifetime:(uint16_t)life
 and then use the 
 -(void) nodeDeviceDidUpdateOxaReading: (VTNodeDevice *) device withReading: (float) reading forPort: (VTModuleLocation)port;
 delegate callback.
 
 @param device The Node device that communicated the reading
 @param reading The reading
 */
-(void) nodeDeviceDidUpdateOxaReading: (VTNodeDevice *) device withReading: (float) reading __deprecated;

/** Invoked when a Node device communicates an OXA module reading
 @param device The Node device that communicated the reading
 @param reading The reading
 @param port The module port (Port A or Port B) from which the reading was taken
 */
-(void) nodeDeviceDidUpdateOxaReading: (VTNodeDevice *) device withReading: (float) reading forPort: (VTModuleLocation)port;

/** Invoked when a Node device has transmitted the stored Oxa baseline value of an attached Oxa module
 @param device The device involved in this communication
 @param value The stored Oxa baseline value
 */
-(void) nodeDeviceDidUpdateOxaBaselineValue:(VTNodeDevice *)device withValue: (float)value __deprecated;

/** Invoked when a Node device has transmitted the stored Oxa baseline value of an attached Oxa module
 @param device The device involved in this communication
 @param value The stored Oxa baseline value
 @param port The `VTModuleLocation` (port A or port B) of the OXA module that transmitted its stored baseline value
 */
-(void) nodeDeviceDidUpdateOxaBaselineValue:(VTNodeDevice *)device withValue: (float)value forPort: (VTModuleLocation)port;

/** Invoked during OXA module operations (e.g. calibration) to signify status
    Currently this callback is used to pass status updates during OXA CO2 module calibration
    
 @param device The device involved in this communication
 @param status The status being relayed (see VTNodeTypes.h)
 */
-(void) nodeDeviceDiDUpdateOxaStatus:(VTNodeDevice *)device withStatus: (VTNodeOxaStatus) status;
#pragma mark -

#pragma mark - Therma Module
/**-----------------------------------------------------------------------------
 * @name Therma Module
 * -----------------------------------------------------------------------------
 */
/** Invoked when a Node device communicates a temperature reading from an attached IR Therma module
 
 @param device The device that communicated the reading
 @param reading The reading in degrees celsius
 */
-(void) nodeDeviceDidUpdateIRThermaReading: (VTNodeDevice *) device withReading: (float) reading;

/** Invoked when a Node device communicates a temperature reading from an attached IR Therma module
 
 @param device The device that communicated the reading
 @param reading The reading in degrees celsius
 @param date The date (timestamp) of this reading, set by NODE
 */
-(void) nodeDeviceDidUpdateIRThermaReading: (VTNodeDevice *) device withReading: (float) reading atTime: (NSDate *)date;
#pragma mark -

#pragma mark - Radia Module
/**-----------------------------------------------------------------------------
 * @name Radia Module
 * -----------------------------------------------------------------------------
 */
/** Invoked when a Node device communicates a radiation level reading from an attached Radia module.
 
 @param device The device that communicated the reading
 @param cpm Counts per minute as reported by the sensor
 @param mSv_hr Calcualted microsieverts per hour based on observed counts per minute
 */
-(void) nodeDeviceDidUpdateRadiaReading:(VTNodeDevice *) device withCountsPerMinute: (float) cpm withMicroSvPerHr: (float) mSv_hr;

#pragma mark -

#pragma mark - Barcode Module
/**-----------------------------------------------------------------------------
 * @name Barcode Module
 * -----------------------------------------------------------------------------
 */
/** Invoked hwne a Node device transmits a barcode reading
 @param device The device involved in this communication
 @param reading The barcode reading as text
 */
-(void) nodeDeviceDidUpdateBarcodeReading: (VTNodeDevice *)device withReading:(NSString *)reading;
#pragma mark -

#pragma mark - GPS Module
/**-----------------------------------------------------------------------------
 * @name GPS Module
 * -----------------------------------------------------------------------------
 */
/** Invoked when a Node device has communicated GPS coordinates
 @param device The device involved in this communication
 @param latitude latitude
 @param longitude longitude
 @param speed speed in m/s
 @param heading heading in degrees starting from north going clockwise
 */
-(void) nodeDeviceGpsDidUpdate:(VTNodeDevice *)device withLat:(double)latitude withLon:(double)longitude withSpeed:(float)speed withHeading:(float)heading;

/** Invoked when a Node device has communicated GPS coordinates
 @param device The device involved in this communication
 @param numberSatellites #satellites used in this reading
 @param hdop horizontal dilution of precision
 @param altitude altitude
 @param wgs84_minus_altitude - WGS84 - Alt
 @param fixType - 0=no fix, 1=GPS, 2=DGPS, ...
 */

-(void)nodeDeviceGpsDidUpdate:(VTNodeDevice *)device withSatellites:(uint8_t)numberSatellites withHDOP:(float)hdop withAltitude:(float)altitude withWgs84:(float)wgs84_minus_altitude withFixType:(uint8_t)fixType;

/** Invoked when a Node device has communicated a GPS no fix message
 @param device The device involved in this communication
 */
-(void) nodeDeviceGpsNoFix:(VTNodeDevice *)device;
#pragma mark -

#pragma mark - Datalogging
/**-----------------------------------------------------------------------------
 * @name Data logging
 * -----------------------------------------------------------------------------
 */
/** Invoked when a Node device has communicated its data logging state
 @param device The device involved in this communication
 @param state YES if data logging is currently enabled
 */
-(void) nodeDeviceDidUpdateDataLoggingState:(VTNodeDevice *)device withState: (bool)state;

/** Invoked when a Node device has completed a data logging operation
 @param device The device involved in this communication
 @param op The data logging operation that has completed
 */
-(void) nodeDeviceDidCompleteDataloggingOperation:(VTNodeDevice *)device operation:(VTNodeDataLoggingOperation)op;

/** Invoked when a Node device has communicated its data logging allowed state
 @param device The device involved in this communication
 @param state YES if data logging is permitted
 */
-(void) nodeDeviceDidUpdateDataLoggingAllowedState: (VTNodeDevice *)device withState: (bool)state;

/** Invoked when a Node device has transmitted its data logging period
 @param device The device involved in this communication
 @param period The data logging period in units of 4s
 */
-(void) nodeDeviceDidUpdateDataLoggingPeriod:(VTNodeDevice *)device withPeriod: (uint8_t)period;

/** Invoked when a Node device has transmitted the count of the number of datalog entries
 currently stored on the device.
 
 @param device The device involved in this communication
 @param count The number of datalog entries
 
 */
-(void) nodeDeviceDidTransmitDatalogEntryCount:(VTNodeDevice *)device withCount: (uint32_t)count;

/** Invoked when a Node device has communicated its amount of free data log space
 @param device The device involved in this communication
 @param free_space The amount of free space in bytes
 */
-(void) nodeDeviceDidTransmitDataLoggingFreeSpace:(VTNodeDevice *)device withFreeSpace:(uint32_t)free_space;

#pragma mark Clima Datalogging
/** Invoked when a Node device has transmitted a data logged clima temperature reading
 @param device The device involved in this communication
 @param timestamp Unix timestamp of data logging entry
 @param temperature Temperature in deg. C
 
 */
-(void) nodeDeviceDidTransmitDataloggedClimaTempReading:(VTNodeDevice *)device withTimeStamp:(int32_t)timestamp withReading: (float)temperature;

/** Invoked when a Node device has transmitted a data logged clima humidity reading
 @param device The device involved in this communication
 @param timestamp Unix timestamp of data logging entry
 @param humidity Relative humidity in %
 
 */
-(void) nodeDeviceDidTransmitDataloggedClimaHumidityReading: (VTNodeDevice *)device withTimeStamp:(int32_t) timestamp withReading:(float)humidity;

/** Invoked when a Node device has transmitted a data logged clima pressure reading
 @param device The device involved in this communication
 @param timestamp Unix timestamp of data logging entry
 @param pressure  The barometric pressure level in kPa
 */
-(void) nodeDeviceDidTransmitDataloggedClimaPressureReading: (VTNodeDevice *)device withTimeStamp:(int32_t) timestamp withReading:(float)pressure;

/** Invoked when a Node device has transmitted a data logged clima light reading
 @param device The device involved in this communication
 @param timestamp Unix timestamp of data logging entry
 @param light_level Ambient light level in lux
 */
-(void) nodeDeviceDidTransmitDataloggedClimaLightReading: (VTNodeDevice *)device withTimeStamp:(int32_t) timestamp withReading:(float)light_level;


#pragma mark Clima Pro Datalogging
/** Invoked when a Node device has transmitted a data logged Clima Pro humidity reading
 @param device The device involved in this communication
 @param timestamp Unix timestamp of data logging entry
 @param humidity Relative humidity in %
 
 */
-(void)nodeDeviceDidTransmitDataloggedClimaProHumidityReading: (VTNodeDevice *)device withTimeStamp:(int32_t) timestamp withReading:(float)humidity;


/** Invoked when a Node device has transmitted a data logged clima pro light reading
 @param device The device involved in this communication
 @param timestamp Unix timestamp of data logging entry
 @param light_level Ambient light level in lux
 */
-(void) nodeDeviceDidTransmitDataloggedClimaProLightReading: (VTNodeDevice *)device withTimeStamp:(int32_t) timestamp withReading:(float)light_level;

/** Invoked when a Node device has transmitted a data logged clima pro pressure reading
 @param device The device involved in this communication
 @param timestamp Unix timestamp of data logging entry
 @param pressure  The barometric pressure level in kPa
 */
-(void) nodeDeviceDidTransmitDataloggedClimaProPressureReading: (VTNodeDevice *)device withTimeStamp:(int32_t) timestamp withReading:(float)pressure;

/** Invoked when a Node device has transmitted a data logged clima pro temperature reading
 @param device The device involved in this communication
 @param timestamp Unix timestamp of data logging entry
 @param temperature Temperature in deg. C
 
 */
-(void) nodeDeviceDidTransmitDataloggedClimaProTempReading:(VTNodeDevice *)device withTimeStamp:(int32_t)timestamp withReading: (float)temperature;


/** Invoked when a Node device has transmitted a data logged clima pro lightning/storm reading
 @param device The device involved in this communication
 @param timestamp Unix timestamp of data logging entry
 @param updateType Update type (valid distance, storm out of range
 @param distance The distance (in km) that NODE+ClimaPro is from the edge of the storm up to 40km
 
 */
-(void) nodeDeviceDidTransmitDataloggedClimaProLightningReading:(VTNodeDevice *)device withTimeStamp:(int32_t)timestamp withUpdateType:(VTNodeLightinngStatus)updateType withDistanceToStorm:(uint8_t)distance;

#pragma mark Motion Event Datalogging
/** Invoked when a Node device transmits a data logged motion shock event
 @param device The device involved in this communication
 @param timestamp Unix timestamp of datalog entry
 @param magnitude The magnitude of this shock event
 @param reading The accelerometer reading at the time of the motion event
 
 When a motion event (such as NODE being dropped) occurs, several accelerometer readings 
 will be logged by NODE throughout the event.
 */
-(void) nodeDeviceDidTransmitDataloggedMotionShockEvent:(VTNodeDevice *)device withTimeStamp: (int32_t)timestamp withMagnitude:(float)magnitude  withReading: (VTSensorReading *)reading;

/** Invoked when a Node device transmits a data logged motion rotation event
 @param device The device involved in this communication
 @param timestamp Unix timestamp of datalog entry
 @param roll The calculated roll for this event
 @param pitch The calculated pitch for this event
 @param reading The accelerometer reading at the time of the motion event
 
 When a motion event (such as NODE being dropped) occurs, several accelerometer readings
 will be logged by NODE throughout the event.
 */
-(void) nodeDeviceDidTransmitDataloggedMotionRotationEvent:(VTNodeDevice *)device withTimeStamp: (int32_t)timestamp withRoll: (float)roll withPitch:(float)pitch withReading: (VTSensorReading *)reading;
#pragma mark -

/**-----------------------------------------------------------------------------
 * @name Thermocouple Module
 * -----------------------------------------------------------------------------
 */
#pragma mark - Thermocouple Module
/** Invoked when a Node device has transmitted a reading from an attached thermocouple module
 @param device The device involved in this communication
 @param reading The thermocouple reading in deg. C
 */
-(void) nodeDeviceDidTransmitThermocoupleReading:(VTNodeDevice *)device withReading: (float)reading;
#pragma mark -

- (void) nodeDeviceDidUpdateNanoReading:(VTNodeDevice *)device withReading: (uint16_t)reading forChannel: (uint8_t)channel;

- (void) nodeDeviceDidUpdateNanoTemperature:(VTNodeDevice *)device withReading: (float)reading;
@end
