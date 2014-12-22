//
//  VTChroma20Reading.h
//  LUT Maker
//
//  Created by Andrew T on 3/11/14.
//  Copyright (c) 2014 Variable. All rights reserved.
//

#import "VTColorSenseObject.h"
#import "VTRGBCReading.h"

@interface VTChroma20Reading : VTRGBCReading

@property (strong, nonatomic) VTColorSenseObject *senseObj;

-(id)initWith:(VTColorSenseObject *)senseObj chromaDevice:(VTChromaDevice*)chromaDevice;

-(void)recalculateColorVals;
@end
