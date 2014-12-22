//
//  VTKoreViewController.m
//  node-demo-2
//
//  Created by Wade Gasior on 10/22/12.
//  Copyright (c) 2012 Variable Technologies. All rights reserved.
//

#import "VTMotionViewController.h"

@interface VTMotionViewController () <NodeDeviceDelegate>

@end

@implementation VTMotionViewController

-(void)viewDidLoad
{    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
        NSLog(@"load!");
    self.view.backgroundColor = UIColor.redColor;
  
    //The below is used to disable the appearance of an "Edit" button in the "More" TabController View
    //self.tabBarController.customizableViewControllers = [NSArray arrayWithObjects:nil];
}



-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    //Grab the Node delegate
    [VTNodeManager getInstance].selectedNodeDevice.delegate = self;
    [[VTNodeManager getInstance].selectedNodeDevice setStreamModeAcc:YES Gyro:YES Mag:YES withTimestampingEnabled:YES];
          NSLog(@"appear!");
}

-(void) viewWillDisappear:(BOOL)animated {
    //Check if the back button was pressed
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        //Stop streaming
        [[VTNodeManager getInstance].selectedNodeDevice setStreamModeAcc:NO Gyro:NO Mag:NO withTimestampingEnabled:NO];
    }
    [super viewWillDisappear:animated];
}

#pragma mark - NodeDeviceDelegate

-(void)nodeDeviceDidUpdateAccReading:(VTNodeDevice *)device withReading:(VTSensorReading *)reading {
    static float accScaleMax = 16.0f;
    
    [self updateBarDisplayWithPercent:reading.x/accScaleMax forBar:self.accXBar withFrame:self.accXFrame];
    self.accXLabel.text = [NSString stringWithFormat:@"%.2f g", reading.x];
    
    [self updateBarDisplayWithPercent:reading.y/accScaleMax forBar:self.accYBar withFrame:self.accYFrame];
    self.accYLabel.text = [NSString stringWithFormat:@"%.2f g", reading.y];
    
    [self updateBarDisplayWithPercent:reading.z/accScaleMax forBar:self.accZBar withFrame:self.accZFrame];
    self.accZLabel.text = [NSString stringWithFormat:@"%.2f g", reading.z];
}

-(void)nodeDeviceDidUpdateGyroReading:(VTNodeDevice *)device withReading:(VTSensorReading *)reading {
    static float gyroScaleMax = 2000.0f;
    
    [self updateBarDisplayWithPercent:reading.x/gyroScaleMax forBar:self.gyroXBar withFrame:self.gyroXFrame];
    self.gyroXLabel.text = [NSString stringWithFormat:@"%i °/s", (int)reading.x];
    
    [self updateBarDisplayWithPercent:reading.y/gyroScaleMax forBar:self.gyroYBar withFrame:self.gyroYFrame];
    self.gyroYLabel.text = [NSString stringWithFormat:@"%i °/s", (int)reading.y];
    
    [self updateBarDisplayWithPercent:reading.z/gyroScaleMax forBar:self.gyroZBar withFrame:self.gyroZFrame];
    self.gyroZLabel.text = [NSString stringWithFormat:@"%i °/s", (int)reading.z];
}

-(void)nodeDeviceDidUpdateMagReading:(VTNodeDevice *)device withReading:(VTSensorReading *)reading {
    static float magScaleMax = 1.5f;
    
    [self updateBarDisplayWithPercent:reading.x/magScaleMax forBar:self.magXBar withFrame:self.magXFrame];
    self.magXLabel.text = [NSString stringWithFormat:@"%.2f G", reading.x];
    
    [self updateBarDisplayWithPercent:reading.y/magScaleMax forBar:self.magYBar withFrame:self.magYFrame];
    self.magYLabel.text = [NSString stringWithFormat:@"%.2f G", reading.y];
    
    [self updateBarDisplayWithPercent:reading.z/magScaleMax forBar:self.magZBar withFrame:self.magZFrame];
    self.magZLabel.text = [NSString stringWithFormat:@"%.2f G", reading.z];
}

-(void)updateBarDisplayWithPercent: (float)percent forBar: (UIView *)theBar withFrame: (UIView *)theFrame {
    static CGPoint newCenter;
    
    newCenter = theFrame.center;
    newCenter.x += percent * (theFrame.frame.size.width/2.0f);
    theBar.center = newCenter;
}

@end
