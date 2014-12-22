//
//  ColorPreview.h
//  ChromaCal2
//
//  Created by Andrew T on 12/10/13.
//  Copyright (c) 2013 Variable. All rights reserved.
//

//Used to store sense values and to generate a preview color for UICollectionView

#import <Foundation/Foundation.h>

@interface VTColorSenseObject : NSObject

@property NSString* colorname;
@property (readwrite, nonatomic) uint16_t senseClear, senseRed, senseGreen, senseBlue, senseReds, senseOJs,senseGreens, senseBlues, senseUVs;
-(id) initWithSense:(NSArray*)senseArray name:(NSString*)name;
-(id) initWithClear:(uint16_t)_clear red:(uint16_t)_red green:(uint16_t)_green blue:(uint16_t)_blue name:(NSString*)name;

@end
