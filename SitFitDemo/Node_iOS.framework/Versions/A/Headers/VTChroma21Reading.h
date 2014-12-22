//
//  VTChroma21Reading.h
//  LUT Maker
//
//  Created by Andrew T on 4/3/14.
//  Copyright (c) 2014 Variable. All rights reserved.
//

#import "VTColorSenseObject.h"
#import "VTRGBCReading.h"

@interface VTChroma21Reading : VTRGBCReading

@property (strong, nonatomic) VTColorSenseObject *senseObj;
-(id)initWith:(VTColorSenseObject *)senseObj chromaDevice:(VTChromaDevice*)chromaDevice;

-(void)recalculateColorVals;
@end
