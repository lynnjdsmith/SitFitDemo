//
//  VTChromaMatch.h
//  Node
//
//  Created by Wade Gasior on 3/13/14.
//  Copyright (c) 2014 Variable, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Node.h"
#import "VTChromaMatchVendor.h"
#import "VTChromaMatchColor.h"

@interface VTChromaMatch : NSObject

#if CHROMA_MATCH_ENABLED == 1
typedef void (^ VendorRegistrationSuccessBlock)(VTChromaMatchVendor *vendor);
typedef void (^ VendorRegistrationErrorBlock)(NSError *error);

#define VendorRegistrationErrorGeneral                  1
#define VendorRegistrationErrorGeneralMsg               @"There was an error registering the vendor."
#define VendorRegistrationErrorAlreadyRegistered        2
#define VendorRegistrationErrorAlreadyRegisteredMsg     @"A vendor with that code is already registered."
#define VendorRegistrationErrorCodeTooShort             3
#define VendorRegistrationErrorCodeTooShortMsg          @"The provided code was too short."
#define VendorRegistrationErrorNoWeb                    4
#define VendorRegistrationErrorNoWebMsg                 @"No internet connection detected."

/** Register a new Chroma Match vendor using a web code
 @param vendorCode Web code for vendor
 */
+ (void) registerVendorWithCode: (NSString *)vendorCode onSuccess: (VendorRegistrationSuccessBlock)successBlock onError:(VendorRegistrationErrorBlock)errorBlock;

/** Fetch all registered Chroma Match vendors
@return An array of VTChromaMatchVendor objects
*/
+ (NSArray *) fetchRegisteredVendors;

/** Fetch all available color sets from all registered vendors
 
 @return An array of VTChromaMatchColorSet objects
 **/
+ (NSArray *) fetchAllColorSets;

/** Checks if a vendor is already registered
 @return TRUE if the vendor is already registered
 **/
+ (BOOL) vendorIsRegisteredWithCode: (NSString *)vendorCode;

#endif
@end
