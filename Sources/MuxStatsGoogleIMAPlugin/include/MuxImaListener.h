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

@interface MuxImaListener : NSObject<IMAAdsManagerDelegate, IMAAdsLoaderDelegate>

@property (weak, nullable) id<IMAAdsManagerDelegate> customerAdsManagerDelegate;
@property (weak, nullable) id<IMAAdsLoaderDelegate> customerAdsLoaderDelegate;

- (id)initWithPlayerBinding:(MUXSDKPlayerBinding *)binding
       monitoringAdsLoader:(nullable IMAAdsLoader *)adsLoader;
- (id)initWithPlayerBinding:(MUXSDKPlayerBinding *)binding
                    options:(MuxImaListenerOptions)options
       monitoringAdsLoader:(nullable IMAAdsLoader *)adsLoader;
- (void)monitorAdsManager:(IMAAdsManager *)adsManager;
- (void)setPictureInPicture:(BOOL)isPictureInPicture;
- (void)clientAdRequest:(IMAAdsRequest *)request;
- (void)daiAdRequest:(IMAStreamRequest *)request;

// Removed methods (we can deprecate instead, although we're still on v0.x)
//- (MUXSDKPlaybackEvent *_Nullable)dispatchEvent:(IMAAdEvent *)event;
//- (void)dispatchError:(NSString *)message;
//- (void)onContentPauseOrResume:(bool)isPause;

@end

NS_ASSUME_NONNULL_END
