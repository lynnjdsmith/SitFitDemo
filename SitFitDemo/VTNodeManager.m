//
//  VTNodeManager.m
//  node-demo-2
//
//  Created by Wade Gasior on 10/22/12.
//  Copyright (c) 2012 Variable Technologies. All rights reserved.
//

#import "VTNodeManager.h"

#import <Node_iOS/Node.h>

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

@interface VTNodeManager () <CBCentralManagerDelegate, CBPeripheralDelegate, NodeDeviceDelegate>
@property (strong, nonatomic) CBCentralManager *cbcentral;
@property (strong, nonatomic) NSMutableArray *nodeDevices;
@property BOOL isAvailable;
@end

@implementation VTNodeManager

+ (VTNodeManager *)getInstance
{
    static VTNodeManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[VTNodeManager alloc] init];
        // Assume this device does support BLE:
        instance.isAvailable = YES;
        instance.cbcentral = [[CBCentralManager alloc] initWithDelegate:instance queue:nil];
        instance.nodeDevices = [NSMutableArray array];
    });
    return instance;
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            //TODO: Hardware is powered off - take action
            break;
        case CBCentralManagerStatePoweredOn:
            //Ready to use CoreBluetooth
            [VTNodeManager startFindingDevices];
            break;
        case CBCentralManagerStateResetting:
            break;
        case CBCentralManagerStateUnauthorized:
            break;
        case CBCentralManagerStateUnknown:
            break;
        case CBCentralManagerStateUnsupported:
            //TODO: Alert the user - the device does not support BLE
            [VTNodeManager getInstance].isAvailable = NO;
            break;
        default:
            break;
    }
}

+(NSArray *)allNodeDevices {
    //Return a copy of the array of CBPeripheral objects
    return [NSArray arrayWithArray:[VTNodeManager getInstance].nodeDevices];
}

+(void) startFindingDevices {
    [[VTNodeManager getInstance].nodeDevices removeAllObjects];
    //Scan for Node devices
    NSArray *servicesToScanFor = [NSArray arrayWithObject:[VTNodeDevice nodeServiceUUID]];
    [[VTNodeManager getInstance].cbcentral scanForPeripheralsWithServices:servicesToScanFor options:nil];
    
    //Also get already connected devices
    [[VTNodeManager getInstance].cbcentral retrieveConnectedPeripherals];
    [[VTNodeManager getInstance].cbcentral performSelector:@selector(stopScan) withObject:nil afterDelay:4];
}
/*
- (void)stopScan
{
    [self.cbcentral stopScan];
}*/

+ (void)stopFindingDevices {
    [[VTNodeManager getInstance].cbcentral stopScan];
}

+(void)connectToDevice: (CBPeripheral *)theDevice {
    [[VTNodeManager getInstance].cbcentral stopScan];
    [[VTNodeManager getInstance].cbcentral connectPeripheral:theDevice options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnNotificationKey]];
}

+(void)disconnectFromDevice: (CBPeripheral *)theDevice {
    [[VTNodeManager getInstance].cbcentral cancelPeripheralConnection:theDevice];
}

-(void) sortListAndNotify {
    [self.nodeDevices sortUsingComparator:^NSComparisonResult(CBPeripheral *p1, CBPeripheral *p2) {
        return ([p1.rssiAtDiscovery intValue] > [p2.rssiAtDiscovery intValue]) ? NSOrderedAscending : NSOrderedDescending;
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNodeDeviceListUpdate object:[VTNodeManager getInstance] userInfo: nil];
}

#pragma mark - CBCentralManagerDelegate
-(void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals {
    //Unfortunately, we can't filter these by only Node devices - we get all connected BLE devices
    //To check if the device is a Node device, you would need to discover services on the device
    for(CBPeripheral *peripheral in peripherals) {
        if(![self.nodeDevices containsObject:peripheral]) {
            [self.nodeDevices addObject:peripheral];
        }
    }
    [self sortListAndNotify];
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    peripheral.delegate = self;
    peripheral.rssiAtDiscovery = RSSI;
    
    if(![self.nodeDevices containsObject:peripheral]) {
        [self.nodeDevices addObject:peripheral];
    }
    [self sortListAndNotify];
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    //NSLog(@"didConnectPeripheral");
    self.selectedNodeDevice = [[VTNodeDevice alloc] initWithDelegate:self withDevice:peripheral];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    if (peripheral == self.selectedNodeDevice.peripheral) {
        self.selectedNodeDevice = nil;
    }
}


#pragma mark - NodeDeviceDelegate

-(void)nodeDeviceIsReadyForCommunication:(VTNodeDevice *)device {
    //NSLog(@"nodeDeviceIsReadyForCommunication");
    //Send a notification that Node is ready to communicate
    if([device.peripheral isEqual:self.selectedNodeDevice.peripheral]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:VTNodeDeviceIsReadyNotification object:self userInfo: nil];
    }
}

-(void)nodeDeviceFailedToInit:(VTNodeDevice *)device {
    //TODO: Handle error for failed device initialization
}

@end
