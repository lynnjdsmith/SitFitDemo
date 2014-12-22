//
//  VTNodeDeviceCell.h
//  node-demo-2
//
//  Created by Wade Gasior on 10/22/12.
//  Copyright (c) 2012 Variable Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "CBPeripheral+Node.h"

@interface VTNodeDeviceCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *deviceLabel;
@property (strong, nonatomic) IBOutlet UILabel *uuidLabel;
@property (weak, nonatomic) CBPeripheral *cbperipheral;
@property (weak, nonatomic) IBOutlet UIImageView *imgRSSI;

@end
