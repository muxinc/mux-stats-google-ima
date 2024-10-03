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

@interface MuxImaListener : NSObject

- (id)initWithPlayerBinding:(MUXSDKPlayerBinding *)binding;
- (id)initWithPlayerBinding:(MUXSDKPlayerBinding *)binding options:(MuxImaListenerOptions) options;
- (nullable MUXSDKPlaybackEvent *)dispatchEvent:(IMAAdEvent *)event;
- (nullable MUXSDKAdEvent *)dispatchEvent:(IMAAdEventType)eventType
                               withAdData:(nullable MUXSDKAdData *)adData
                            withIMAAdData:(nullable NSDictionary *)imaAdData;
- (void)dispatchError:(NSString *)message;
- (void)dispatchPauseOrResume:(BOOL)isPause;
- (void)onContentPauseOrResume:(BOOL)isPause;
- (void)setPictureInPicture:(BOOL)isPictureInPicture;
- (void)clientAdRequest:(IMAAdsRequest *)request;
- (void)daiAdRequest:(IMAStreamRequest *)request;

@end

NS_ASSUME_NONNULL_END
