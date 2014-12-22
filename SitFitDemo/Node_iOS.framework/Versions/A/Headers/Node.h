//
//  Node.h
//  Node
//
//  Created by Wade Gasior on 6/9/13.
//  Copyright (c) 2013 Variable Technologies. All rights reserved.
//

#ifndef Node_Node_h
#define Node_Node_h

/*!
 *  @header
 *	@file Node.h
 *
 *  @discussion Node API
 *
 *	@copyright 2012 Variable Technologies. All rights reserved.
 */

#define NODE_API_REVISION 4.0.2

#import <CoreBluetooth/CoreBluetooth.h>
#import <Foundation/Foundation.h>
#import "VTNodeTypes.h"
#import "NodeDeviceDelegate.h"
#import "VTSensorReading.h"
#import "VTQuatReading.h"
#import "VTNodeDevice.h"
#import "VTChromaDevice.h"
#import "VTRGBCReading.h"
#import "VTChroma10Reading.h"
#import "VTChroma11Reading.h"
#import "VTChroma20Reading.h"
#import "VTChroma21Reading.h"
#import "VTNodeDevice+Chroma.h"
#import "VTChromaMatch.h"
#import "VTChromaMatchColor.h"
#import "VTChromaMatchVendor.h"
#import "VTGPSObject.h"

#if CHROMA_MATCH_ENABLED == 1
#import "VTChromaMatch.h"
#endif

#endif
