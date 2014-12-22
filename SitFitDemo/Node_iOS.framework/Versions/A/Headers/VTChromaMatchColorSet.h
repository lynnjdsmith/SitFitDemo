//
//  VTChromaMatchColorSet.h
//  Node
//
//  Created by Wade Gasior on 3/17/14.
//  Copyright (c) 2014 Variable, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#if CHROMA_MATCH_ENABLED == 1
@class VTChromaMatchVendor;

@interface VTChromaMatchColorSet : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) VTChromaMatchVendor *vendor;

-(NSArray*)fetchColors;

@end
#endif
