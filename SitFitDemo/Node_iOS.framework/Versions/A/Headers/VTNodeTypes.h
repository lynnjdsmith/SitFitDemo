//
//  VTNodeTypes.h
//  Node
//
//  Created by Wade Gasior on 6/9/13.
//  Copyright (c) 2013 Variable Technologies. All rights reserved.
//

#ifndef Node_VTNodeTypes_h
#define Node_VTNodeTypes_h

typedef NS_ENUM(uint8_t, VTNodeAccelerometerScale) {
    VTNodeAccelerometerScale2g   = 0x00,
    VTNodeAccelerometerScale4g   = 0x01,
    VTNodeAccelerometerScale8g   = 0x02,
    /* Note: 16g scale is only valid on NODE 2 devices */
    VTNodeAccelerometerScale16g  = 0x03
};

typedef NS_ENUM(uint8_t, VTNodeGyroScale) {
    VTNodeGyroScale250dps        = 0x00,
    VTNodeGyroScale500dps        = 0x01,
    VTNodeGyroScale1000dps       = 0x02,
    VTNodeGyroScale2000dps       = 0x03
};

typedef NS_ENUM(uint8_t, VTNodeModuleType)
{
    VTNodeModuleTypeNone                = 0xff,
    VTNodeModuleTypeLuma                = 0x00,
    VTNodeModuleTypeClima               = 0x01,
    VTNodeModuleTypeTherma              = 0x02,
    VTNodeModuleTypeOxa                 = 0x03,
    VTNodeModuleTypeChroma              = 0x04,
    VTNodeModuleTypeArrTherma           = 0x05,
    VTNodeModuleTypeGPS                 = 0x06,
    VTNodeModuleTypeThermocouple        = 0x07,
    VTNodeModuleTypeClimaPro            = 0x08,
    VTNodeModuleTypeBarCode             = 0x09,
	VTNodeModuleTypeIOModule            = 0x0A,
    VTNodeModuleTypeAccel               = 0x0D
};

typedef NS_ENUM(uint8_t, VTNodeModuleSubType)
{
    VTNodeModuleSubTypeCO   = 0x00,
    VTNodeModuleTypeChroma10 = 0x00,
    VTNodeModuleSubTypeCL2  = 0x01,
    VTNodeModuleTypeChroma11 = 0x01,
    VTNodeModuleSubTypeSO2  = 0x02,
    VTNodeModuleTypeChroma12 = 0x02,
    VTNodeModuleSubTypeNO   = 0x03,
    VTNodeModuleTypeChroma13 = 0x03,
    VTNodeModuleSubTypeNO2  = 0x04,
    VTNodeModuleTypeChroma20 = 0x04,
    VTNodeModuleSubTypeH2S  = 0x05,
    VTNodeModuleTypeChroma21 = 0x05,
    VTNodeModuleSubTypeCO2  = 0x06
};

typedef NS_ENUM(uint8_t, VTModuleLocation)
{
    VTModuleLocationKore    = 0x00,
    VTModuleLocationA       = 0x01,
    VTModuleLocationB       = 0x02
};

typedef NS_ENUM(uint8_t, VTNodeQuietModeSetting)
{
    VTNodeQuietModeSettingUnknown  = 0xFF,
    VTNodeQuietModeSettingQuiet    = 0x01,
    VTNodeQuietModeSettingNotQuiet = 0x00
};

typedef NS_ENUM(uint8_t, VTNodeDataLoggingDataType)
{
    VTNodeDataLoggingDataTypeMotion = 0x01,
    VTNodeDataLoggingDataTypeClima  = 0x04,
    VTNodeDataLoggingDataTypeOxa    = 0x07,
    VTNodeDataLoggingDataTypeTherma = 0x03,
    VTNodeDataLoggingDataTypeClimaPro = 0x0B
};

typedef NS_ENUM(uint8_t, VTNodeDataLoggingOperation)
{
    VTNodeDataLoggingOperation_DataFetchComplete = 0x00,
    VTnodeDataLoggingOperation_MemEraseComplete  = 0x01
};

typedef NS_ENUM(uint8_t, VTNodeLightinngStatus)
{
    VTNodeStormValid        = 0x00,
    VTNodeStormOutOfRange   = 0x01,
    VTNodeLightningDisturb  = 0x02,
    VTNodeLightningNoise    = 0x03,
    VTNodeLightningNoUpdate = 0x04
};

typedef NS_ENUM(uint8_t, VTNodeIOPinType)
{
    VTNodeGPI       = 0x00,
    VTNodeGPO       = 0x01,
    VTNodeIRQ       = 0x02
};

typedef NS_ENUM(uint8_t, VTNodeOxaStatus)
{
    VTNodeOxaStatusOperationSuccess = 0x01,
    VTNodeOxaStatusOperationFail  = 0x02,
    VTNodeOxaStatusOperationInProgress = 0x03
};

typedef NS_ENUM(uint8_t, VTNodeMotionEventType) {
    VTNodeMotionEventTypeNoMotion = 0x00,
    VTNodeMotionEventTypeMotion = 0x01
};

typedef NS_ENUM(uint8_t, VTNodeHSAEventType) {
    VTNodeHSAEventTypeComplete = 0x00,
    VTNodeHSAEventTypeStart = 0x01,
    VTNodeHSAEventTypeReady = 0x02,
    VTNodeHSAEventTypeFail = 0x03
};

typedef struct {
    uint8_t accel_hpm;
    uint8_t accel_hpcf;
    uint8_t accel_dr;
    uint8_t accel_scale;
    uint8_t gyro_dr_bw;
    uint8_t gyro_hpcf;
    uint8_t gyro_fs;
    uint8_t gyro_hpm;
    uint8_t mag_gain;
    uint8_t mag_dr;
} VTNodeKoreConfig;

#endif
