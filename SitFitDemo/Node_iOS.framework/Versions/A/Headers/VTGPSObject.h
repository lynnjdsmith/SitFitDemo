//
//  GPSObject.h
//  Node
//
//  Created by Andrew T on 9/3/13.
//  Copyright (c) 2013 Variable Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@protocol NodeGpsDelegate

-(void)nodeGpsStartMessageReady:(NSData*)data;
@end


@interface VTGPSObject : NSObject

-(id) initAssistedGPS;

@property (assign) id <NodeGpsDelegate> delegate;

@end
