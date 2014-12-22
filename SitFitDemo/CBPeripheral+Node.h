//
//  CBPeripheral+Node.h
//  node-api-demo-public
//
//  Created by Tyler Brown on 5/31/13.
//  Copyright (c) 2013 Variable Technologies. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

#import <Node_iOS/Node.h>
#import <objc/runtime.h>

@interface CBPeripheral (Node)

@property (nonatomic, strong) NSNumber *rssiAtDiscovery;

@end
