//
//  VTNodeConnectionManagerViewController.h
//  node-demo-2
//
//  Created by Wade Gasior on 10/22/12.
//  Copyright (c) 2012 Variable Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTNodeManager.h"
#import "VTNodeDeviceCell.h"

// declare our class
@class VTNodeConnectionManagerViewController;

// define the protocol for the delegate
@protocol customClassDelegate
//@property (nonatomic, weak) id<customClassDelegate> delegate;

// define protocol functions that can be used in any class using this delegate
//-(void)sayHello:(VTNodeConnectionManagerViewController *)customClass;
-(void)sayHello; //:(NSString*)val;

@end



@interface VTNodeConnectionManagerViewController : UITableViewController

// define delegate property
@property (nonatomic, assign) id  delegate;

// define public functions
//-(void)helloDelegate;

@end
