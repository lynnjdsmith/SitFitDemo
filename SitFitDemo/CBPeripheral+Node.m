//
//  CBPeripheral+Node.m
//  node-api-demo-public
//
//  Created by Tyler Brown on 5/31/13.
//  Copyright (c) 2013 Variable Technologies. All rights reserved.
//

#import "CBPeripheral+Node.h"

static char const * const kRssiAtDiscoveryKey = "kRssiAtDiscoveryKey";

@implementation CBPeripheral (Node)

-(NSNumber*) rssiAtDiscovery {
    // default if nil before returning
    NSNumber *rssi = objc_getAssociatedObject(self, kRssiAtDiscoveryKey);
    if(rssi == nil) rssi = [NSNumber numberWithInt:-120];
    return rssi;
}

-(void) setRssiAtDiscovery:(NSNumber*)rssiAtDiscovery {
    objc_setAssociatedObject(self, kRssiAtDiscoveryKey, rssiAtDiscovery, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
