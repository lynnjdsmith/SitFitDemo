//
//  VTNodeDeviceCell.m
//  node-demo-2
//
//  Created by Wade Gasior on 10/22/12.
//  Copyright (c) 2012 Variable Technologies. All rights reserved.
//

#import "VTNodeDeviceCell.h"

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif


@implementation VTNodeDeviceCell
@synthesize cbperipheral = _cbperipheral;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCbperipheral:(CBPeripheral *)thePeripheral {
    _cbperipheral = thePeripheral;
    self.deviceLabel.text = thePeripheral.name;
    self.uuidLabel.text = thePeripheral.UUID ? (__bridge NSString *)CFUUIDCreateString(NULL, thePeripheral.UUID) : @"";
    [self setRSSIImage];
}

-(void) setRSSIImage {
    int rssiVal = [self.cbperipheral.rssiAtDiscovery intValue];
    NSString *imageName = @"signal-strength-0";
    if(rssiVal > -130) imageName = @"signal-strength-1";
    if(rssiVal >  -90) imageName = @"signal-strength-2";
    if(rssiVal >  -80) imageName = @"signal-strength-3";
    if(rssiVal >  -70) imageName = @"signal-strength-4";
    self.imgRSSI.image = [UIImage imageNamed:imageName];
}

@end
