//
//  VTChroma11Reading.h
//  Node
//
//  Created by Andrew T on 12/19/13.
//  Copyright (c) 2013 Variable, Inc. All rights reserved.
//

#import "VTColorSenseObject.h"
#import "VTRGBCReading.h"

@interface VTChroma11Reading : VTRGBCReading

@property (strong, nonatomic) VTColorSenseObject *senseObj;

-(id)initWith:(VTColorSenseObject *)senseObj chromaDevice:(VTChromaDevice*)chromaDevice;

-(void)recalculateColorVals;
@end
