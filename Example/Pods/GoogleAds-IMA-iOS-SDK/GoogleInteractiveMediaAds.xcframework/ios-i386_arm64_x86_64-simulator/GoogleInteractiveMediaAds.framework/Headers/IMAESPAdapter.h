#import <UIKit/UIKit.h>

@class IMAESPVersion;

NS_ASSUME_NONNULL_BEGIN

/** Completion handler for signal generation. Returns either signals or an error object. */
typedef void (^IMAESPSignalCompletionHandler)(NSString *_Nullable signals,
                                              NSError *_Nullable error);

/** Adapter that provides signals to the IMA SDK to be included in an auction. */
@protocol IMAESPAdapter <NSObject>

/** Initializes the ESP adapter. */
- (nullable instancetype)init;

/** The version of the adapter. */
+ (IMAESPVersion *)adapterVersion;

/** The version of the ad SDK. */
+ (IMAESPVersion *)adSDKVersion;

/**
 * Asks the receiver for encrypted signals. Signals are provided to the 3PAS at request time. The
 * receiver must call @c completionHandler with signals or an error.
 * This method is called on a non-main thread. The receiver should avoid using the main thread to
 * prevent signal collection timeouts.
 * @param completion The block to call when signal collection is complete.
 */
- (void)collectSignalsWithCompletion:(IMAESPSignalCompletionHandler)completion;

@end

NS_ASSUME_NONNULL_END
