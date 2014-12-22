#import <Foundation/Foundation.h>
#import "VTChromaMatchColorSet.h"

#if CHROMA_MATCH_ENABLED == 1
typedef void (^ VendorRefreshSuccessBlock)(void);
typedef void (^ VendorRefreshErrorBlock)(NSError *error);

#define VendorRefreshErrorGeneral                   1
#define VendorRefreshErrorGeneralMsg                @"There was an error registering the vendor."
#define VendorRefreshErrorNoWeb                     4
#define VendorRefreshErrorNoWebMsg                  @"No internet connection detected."

@interface VTChromaMatchVendor : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *code;

/** Fetch all available colorsets for this vendor
 @return An array of VTChromaMatchColorSet objects
 */
- (NSArray *) fetchColorsets;

/** Force refresh of all colorsets for this vendor

 */
- (void) refreshColorsetsOnSuccess: (VendorRefreshSuccessBlock)successBlock onError: (VendorRefreshErrorBlock)errorBlock;


/** Removes this vendor from the system
 */
- (void) deregister;

@end
#endif