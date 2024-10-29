//

//  MUXSDKIMAAdsListener.h
//  MuxStatsGoogleIMAPlugin
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

typedef NS_OPTIONS(NSUInteger, MUXSDKIMAAdsListenerOptions) {
    MUXSDKIMAAdsListenerOptionsNone                    = 0,
    MUXSDKIMAAdsListenerOptionsPictureInPicture        = 1 << 0,
};

@interface MUXSDKIMAAdsListener : NSObject<IMAAdsManagerDelegate, IMAAdsLoaderDelegate>

@property (nonatomic, weak, nullable) id<IMAAdsManagerDelegate> customerAdsManagerDelegate;
@property (nonatomic, weak, nullable) id<IMAAdsLoaderDelegate> customerAdsLoaderDelegate;

- (id)initWithPlayerBinding:(MUXSDKPlayerBinding *)binding
        monitoringAdsLoader:(nullable IMAAdsLoader *)adsLoader;
- (id)initWithPlayerBinding:(MUXSDKPlayerBinding *)binding
                    options:(MUXSDKIMAAdsListenerOptions)options
        monitoringAdsLoader:(nullable IMAAdsLoader *)adsLoader;
- (void)monitorAdsManager:(IMAAdsManager *)adsManager;
- (void)setPictureInPicture:(BOOL)isPictureInPicture;
- (void)clientAdRequest:(IMAAdsRequest *)request;
- (void)daiAdRequest:(IMAStreamRequest *)request;

@end

NS_ASSUME_NONNULL_END
