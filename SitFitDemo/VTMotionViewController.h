//
//  VTKoreViewController.h
//  node-demo-2
//
//  Created by Wade Gasior on 10/22/12.
//  Copyright (c) 2012 Variable Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTNodeManager.h"

#import <Node_iOS/Node.h>

@interface VTMotionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *accXBar;
@property (weak, nonatomic) IBOutlet UIView *accXFrame;
@property (weak, nonatomic) IBOutlet UILabel *accXLabel;

@property (weak, nonatomic) IBOutlet UIView *accYFrame;
@property (weak, nonatomic) IBOutlet UIView *accYBar;
@property (weak, nonatomic) IBOutlet UILabel *accYLabel;

@property (weak, nonatomic) IBOutlet UIView *accZFrame;
@property (weak, nonatomic) IBOutlet UIView *accZBar;
@property (weak, nonatomic) IBOutlet UILabel *accZLabel;

@property (weak, nonatomic) IBOutlet UIView *gyroXFrame;
@property (weak, nonatomic) IBOutlet UIView *gyroXBar;
@property (weak, nonatomic) IBOutlet UILabel *gyroXLabel;

@property (weak, nonatomic) IBOutlet UIView *gyroYFrame;
@property (weak, nonatomic) IBOutlet UIView *gyroYBar;
@property (weak, nonatomic) IBOutlet UILabel *gyroYLabel;

@property (weak, nonatomic) IBOutlet UIView *gyroZFrame;
@property (weak, nonatomic) IBOutlet UIView *gyroZBar;
@property (weak, nonatomic) IBOutlet UILabel *gyroZLabel;

@property (weak, nonatomic) IBOutlet UIView *magXFrame;
@property (weak, nonatomic) IBOutlet UIView *magXBar;
@property (weak, nonatomic) IBOutlet UILabel *magXLabel;

@property (weak, nonatomic) IBOutlet UIView *magYFrame;
@property (weak, nonatomic) IBOutlet UIView *magYBar;
@property (weak, nonatomic) IBOutlet UILabel *magYLabel;

@property (weak, nonatomic) IBOutlet UIView *magZFrame;
@property (weak, nonatomic) IBOutlet UIView *magZBar;
@property (weak, nonatomic) IBOutlet UILabel *magZLabel;

@end
