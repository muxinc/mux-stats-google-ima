//
//  MUXSDKImaListener.m
//  Expecta
//
//  Created by Dylan Jhaveri on 9/11/19.
//

#import "MuxImaListener.h"
#import "MUXSDKIMAAdsListener.h"
#import "MUXSDKIMAAdsListener+Private.h"

@interface MuxImaListener ()

@property (nonatomic, strong) MUXSDKIMAAdsListener *adsListener;

@end

@implementation MuxImaListener


- (instancetype)initWithPlayerBinding:(MUXSDKPlayerBinding *)binding
      monitoringAdsLoader:(nullable IMAAdsLoader *)adsLoader {
    return [self initWithPlayerBinding:binding
                               options:MuxImaListenerOptionsNone
                   monitoringAdsLoader:adsLoader];
}

- (instancetype)initWithPlayerBinding:(MUXSDKPlayerBinding *)binding
                    options:(MuxImaListenerOptions)options
               monitoringAdsLoader:(IMAAdsLoader *)adsLoader {
    self = [super init];

    if (self) {

        MUXSDKIMAAdsListenerOptions adsListenerOptions = (options & MUXSDKIMAAdsListenerOptionsPictureInPicture) == 0 ?
        MUXSDKIMAAdsListenerOptionsNone : MUXSDKIMAAdsListenerOptionsPictureInPicture;
        _adsListener = [[MUXSDKIMAAdsListener alloc] initWithPlayerBinding:binding
                                                                   options:adsListenerOptions
                                                       monitoringAdsLoader:adsLoader];
    }
    return self;
}

- (nullable id<IMAAdsManagerDelegate>)customerAdsManagerDelegate {
    return [self.adsListener customerAdsManagerDelegate];
}

- (void)setCustomerAdsManagerDelegate:(id<IMAAdsManagerDelegate>)customerAdsManagerDelegate {
    [self.adsListener setCustomerAdsManagerDelegate:customerAdsManagerDelegate];
}

- (nullable id<IMAAdsLoaderDelegate>)customerAdsLoaderDelegate {
    return [self.adsListener customerAdsLoaderDelegate];
}

- (void) setCustomerAdsLoaderDelegate:(id<IMAAdsLoaderDelegate>)customerAdsLoaderDelegate {
    [self.adsListener setCustomerAdsLoaderDelegate:customerAdsLoaderDelegate];
}

- (void)monitorAdsManager:(IMAAdsManager *)adsManager {
    [self.adsListener monitorAdsManager:adsManager];
}

- (void)setupAdViewData:(MUXSDKAdEvent *)event withAd:(IMAAd *)ad {
    [self.adsListener setupAdViewData:event
                               withAd:ad];
}

- (nullable MUXSDKAdEvent *)dispatchEvent:(IMAAdEvent *)event {
    return [self.adsListener dispatchEvent:event];
}

- (nullable MUXSDKAdEvent *)dispatchEventOfType:(IMAAdEventType)eventType {
    return [self.adsListener dispatchEventOfType:eventType];
}

- (nullable MUXSDKAdEvent *)dispatchEvent:(IMAAdEventType)eventType
                               withAdData:(nullable MUXSDKAdData *)adData
                            withIMAAdData:(nullable NSDictionary *)imaAdData {
    return [self.adsListener dispatchEvent:eventType
                                withAdData:adData
                             withIMAAdData:imaAdData];
}

- (void)dispatchError:(NSString *)message {
    [self.adsListener dispatchError:message];
}

- (void)dispatchPauseOrResume:(BOOL)isPause {
    [self.adsListener dispatchPauseOrResume:isPause];
}

- (void)onContentPauseOrResume:(BOOL)isPause {
    [self.adsListener onContentPauseOrResume:isPause];
}

- (void)setupAdViewDataAndDispatchEvent:(MUXSDKAdEvent *) event {
    [self.adsListener setupAdViewDataAndDispatchEvent:event];
}

- (void)clientAdRequest:(IMAAdsRequest *)request {
    [self.adsListener clientAdRequest:request];
}

- (void)daiAdRequest:(IMAStreamRequest *)request {
    [self.adsListener daiAdRequest:request];
}

- (void)dispatchAdRequestWithoutMetadata {
    [self.adsListener dispatchAdRequestWithoutMetadata];
}

- (void)dispatchAdRequestForAdTag:(nullable NSString *)adTagUrl {
    [self.adsListener dispatchAdRequestForAdTag:adTagUrl];
}

- (void)setPictureInPicture:(BOOL)isPictureInPicture {
    [self.adsListener setPictureInPicture:isPictureInPicture];
}

/* IMAAdsManagerDelegate */

- (void)adsManager:(IMAAdsManager *)adsManager didReceiveAdEvent:(IMAAdEvent *)event {
    [self.adsListener adsManager:adsManager didReceiveAdEvent:event];
}

- (void)adsManager:(nonnull IMAAdsManager *)adsManager didReceiveAdError:(nonnull IMAAdError *)error {
    [self.adsListener adsManager:adsManager
               didReceiveAdError:error];
}

- (void)adsManagerDidRequestContentPause:(nonnull IMAAdsManager *)adsManager {
    [self.adsListener adsManagerDidRequestContentPause:adsManager];
}

- (void)adsManagerDidRequestContentResume:(nonnull IMAAdsManager *)adsManager {
    [self.adsListener adsManagerDidRequestContentResume:adsManager];
}

/* IMAAdsLoaderDelegate */

- (void)adsLoader:(nonnull IMAAdsLoader *)loader adsLoadedWithData:(nonnull IMAAdsLoadedData *)adsLoadedData {
    [self.adsListener adsLoader:loader
              adsLoadedWithData:adsLoadedData];
}

- (void)adsLoader:(nonnull IMAAdsLoader *)loader failedWithErrorData:(nonnull IMAAdLoadingErrorData *)adErrorData {
    [self.adsListener adsLoader:loader
            failedWithErrorData:adErrorData];
}

@end
