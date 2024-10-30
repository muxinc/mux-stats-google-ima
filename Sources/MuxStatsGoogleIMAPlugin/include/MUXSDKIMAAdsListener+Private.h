//
//  MUXSDKIMAAdsListener+Private.h
//  MuxStatsGoogleIMAPlugin
//

#import "MUXSDKIMAAdsListener.h"

@interface MUXSDKIMAAdsListener(Private)

NS_ASSUME_NONNULL_BEGIN

- (nullable MUXSDKAdEvent *)dispatchEventOfType:(IMAAdEventType)eventType;
- (nullable MUXSDKAdEvent *)dispatchEvent:(IMAAdEventType)eventType
                               withAdData:(nullable MUXSDKAdData *)adData
                            withIMAAdData:(nullable NSDictionary *)imaAdData;
- (void)dispatchError:(nullable NSString *)message;
- (void)onContentPauseOrResume:(BOOL)isPause;

- (void)setupAdViewData:(MUXSDKAdEvent *)event withAd:(IMAAd *)ad;
- (nullable MUXSDKAdEvent *)dispatchEvent:(IMAAdEvent *)event;
- (void)dispatchPauseOrResume:(BOOL)isPause;
- (void)setupAdViewDataAndDispatchEvent:(MUXSDKAdEvent *) event;
- (void)dispatchAdRequestWithoutMetadata;
- (void)dispatchAdRequestForAdTag:(nullable NSString *)adTagUrl;

NS_ASSUME_NONNULL_END

@end
