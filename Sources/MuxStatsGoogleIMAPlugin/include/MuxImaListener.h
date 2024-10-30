//
//  MUXSDKImaListener.h
//  Expecta
//
//  Created by Dylan Jhaveri on 9/11/19.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_TV
#import <MuxCore/MuxCoreTv.h>
#else
#import <MuxCore/MuxCore.h>
#endif

#import <MUXSDKStats/MUXSDKStats.h>
#import <GoogleInteractiveMediaAds/GoogleInteractiveMediaAds.h>

NS_ASSUME_NONNULL_BEGIN

@class MUXSDKPlayerBinding;

typedef NS_OPTIONS(NSUInteger, MuxImaListenerOptions) {
    MuxImaListenerOptionsNone                    = 0,
    MuxImaListenerOptionsPictureInPicture        = 1 << 0,
};

/// Use `MuxImaListener` to intercept `IMAAdsManager`
/// and `IMAAdsLoader` events from the IMA SDK on behalf of
/// your application.
///
/// **Note: this class is deprecated and will be removed in
/// a future SDK release. Please switch to using `MUXSDKIMAAdsListener`.**
NS_CLASS_DEPRECATED_IOS(2_0, 12_0, "Use MUXSDKIMAAdsListener instead.")
@interface MuxImaListener : NSObject<IMAAdsManagerDelegate, IMAAdsLoaderDelegate>

/// Your applications ads manager delegate, if configured
@property (nonatomic, weak, nullable) id<IMAAdsManagerDelegate> customerAdsManagerDelegate;

/// Your applications ads loader delegate, if configured
@property (nonatomic, weak, nullable) id<IMAAdsLoaderDelegate> customerAdsLoaderDelegate;

/// Initializes `MUXSDKIMAAdsListener`, automatically monitors
/// the IMA ad playback, and notifies the Mux Data SDK at key
/// points in the ad lifecycle.
///
/// After initialization, delegate calls from the provided
/// IMA ads loader will be intercepted and translated into
/// `MUXSDKPlaybackEvent`.
///
/// These playback events will then be forwarded on to the
/// supplied player binding and when reported to Mux will
/// appear on your Dashboard event timeline with other
/// playback events.
///
/// - Parameters:
///   - binding: player binding that will receive events
///   concerning ad playback
///   - adsLoader: ads loader whose delegate calls will be
///   monitored, make sure to set your own `IMAAdsLoaderDelegate`
///   **before** calling this initializer. Delegate calls
///   will then be automatically forwarded to your delegate.
- (instancetype)initWithPlayerBinding:(MUXSDKPlayerBinding *)binding
                  monitoringAdsLoader:(nullable IMAAdsLoader *)adsLoader;


/// Initializes `MuxImaListener` automatically monitors the IMA
/// ad lifecycle and notifies the Mux Data SDK of key points
/// in the ad lifecycle.
///
/// After initialization delegate calls from the provided
/// IMA ads loader will be intercepted and translated into
/// `MUXSDKPlaybackEvent`.
///
/// These playback events will then be forwarded on to the
/// supplied player binding and when reported to Mux will
/// appear on your Dashboard event timeline with other
/// playback events.
///
/// - Parameters:
///   - binding: player binding that will receive events
///   concerning ad playback
///   - options: options to indicate the starting state
///   of the player
///   - adsLoader: ads loader whose delegate calls will be
///   monitored, make sure to set your own `IMAAdsLoaderDelegate`
///   **before** calling this initializer. Delegate calls
///   will then be automatically forwarded to your delegate.
- (instancetype)initWithPlayerBinding:(MUXSDKPlayerBinding *)binding
                              options:(MuxImaListenerOptions)options
                  monitoringAdsLoader:(nullable IMAAdsLoader *)adsLoader;


/// Called when an `IMAAdsManager` is available to your
/// application. Like `IMAAdsLoader`, delegate
/// calls from the ads manager will be intercepted. Playback
/// events will be forwarded to the Mux Data player binding
/// configured during initialization
///
/// - Parameter adsManager: ads manager who delegate calls
/// will be monitored, make sure to set your own `IMAAdsManagerDelegate`
///   **before** calling this initializer. Delegate calls
///   will then be automatically forwarded to your delegate.
- (void)monitorAdsManager:(IMAAdsManager *)adsManager;


/// Signals if the monitored player is being displayed as
/// picture in picture during ad playback.
/// - Parameter isPictureInPicture: Pass ``YES`` to indicate
/// the player is current displayed using picture in picture.
/// Pass ``NO`` otherwise.
- (void)setPictureInPicture:(BOOL)isPictureInPicture;


/// Signals a client ad request made by your application.
///
/// Call as soon as possible after sending the request to
/// ensure accuracy.
///
/// - Parameter request: a client ad request your application
/// just made
- (void)clientAdRequest:(IMAAdsRequest *)request;


/// Signals a stream ad request has been made by your
/// application.
///
/// Call as soon as possible after sending the request to
/// ensure accuracy.
///
/// - Parameter request: a client ad request your application
/// just made
- (void)daiAdRequest:(IMAStreamRequest *)request;

@end

NS_ASSUME_NONNULL_END
