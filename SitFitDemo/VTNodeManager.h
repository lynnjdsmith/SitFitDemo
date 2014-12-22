//
//  VTNodeManager.h
//  node-demo-2
//
//  Created by Wade Gasior on 10/22/12.
//  Copyright (c) 2012 Variable Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import <Node_iOS/Node.h>
#import "CBPeripheral+Node.h"

#define kNodeDeviceListUpdate               @"nodeDeviceListUpdate"
#define VTNodeDeviceIsReadyNotification     @"VTNodeDeviceIsReadyNotification"

@interface VTNodeManager : NSObject

@property (strong, nonatomic) VTNodeDevice *selectedNodeDevice;
// Find out whether or not this device (iPhone etc) can communicate with
// NODE devices.  In essence, find out whether this device supports
// Bluetooth LE.
@property (readonly) BOOL isAvailable;

+(VTNodeManager *)getInstance;
+(void) startFindingDevices;
+(void) stopFindingDevices;
+(NSArray *)allNodeDevices;
+(void)connectToDevice: (CBPeripheral *)theDevice;
+(void)disconnectFromDevice: (CBPeripheral *)theDevice;
@end
