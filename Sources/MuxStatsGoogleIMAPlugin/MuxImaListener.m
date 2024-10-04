//
//  MUXSDKImaListener.m
//  Expecta
//
//  Created by Dylan Jhaveri on 9/11/19.
//

#import "MuxImaListener.h"

@interface MuxImaListener ()

@property (nonatomic, nonnull) MUXSDKPlayerBinding *playerBinding;

@property (assign) BOOL sendAdplayOnStarted;
@property (assign) BOOL isPictureInPicture;
@property (assign) BOOL usesServerSideAdInsertion;
@property (assign) BOOL adRequestReported;
@property (assign) NSString *adTagURL;

@end

@implementation MuxImaListener


- (id)initWithPlayerBinding:(MUXSDKPlayerBinding *)binding
      monitoringAdsLoader:(nullable IMAAdsLoader *)adsLoader
{
    return [
        self initWithPlayerBinding:binding
                           options:MuxImaListenerOptionsNone
                     monitoringAdsLoader:adsLoader
    ];
}

- (id)initWithPlayerBinding:(MUXSDKPlayerBinding *)binding
                    options:(MuxImaListenerOptions)options
               monitoringAdsLoader:(IMAAdsLoader *)adsLoader
{
    self = [super init];
    
    if (self) {
        self.customerAdsLoaderDelegate = adsLoader.delegate;
        adsLoader.delegate = self;
        
        // The Ads Manager isn't created until further into the wokflow
        
        _playerBinding = binding;
        if ((options & MuxImaListenerOptionsPictureInPicture) == MuxImaListenerOptionsNone) {
            _isPictureInPicture = NO;
        }
        if ((options & MuxImaListenerOptionsPictureInPicture) == MuxImaListenerOptionsPictureInPicture) {
            _isPictureInPicture = YES;
        }
        _usesServerSideAdInsertion = NO;
        _adRequestReported = NO;
        _sendAdplayOnStarted = NO;
    }
    return(self);

}

- (void)monitorAdsManager:(IMAAdsManager *)adsManager {
    self.customerAdsManagerDelegate = adsManager.delegate;
    adsManager.delegate = self;
}

- (void)setupAdViewData:(MUXSDKAdEvent *)event withAd:(IMAAd *)ad {
    MUXSDKViewData *viewData = [MUXSDKViewData new];
    MUXSDKAdData *adData = [MUXSDKAdData new];
    if (ad != nil) {
        
        if ([_playerBinding getCurrentPlayheadTimeMs] < 1000) {
            viewData.viewPrerollAdId = ad.adId;
            viewData.viewPrerollCreativeId = ad.creativeID;
        }
        
        adData.adId = ad.adId;
        adData.adCreativeId = ad.creativeID;
        
        // TODO: use newer IMA API here. universalAdIdValue
        // is deprecated, but used for time being for parity
        // with web&android
        adData.adUniversalId = ad.universalAdIdValue;
        event.adData = adData;
    }
    event.viewData = viewData;
}

- (MUXSDKAdEvent *_Nullable) dispatchEvent:(IMAAdEvent *)event {
    MUXSDKAdEvent *playbackEvent;
    
    NSDictionary *adData = event.adData;
    
    switch(event.type) {
        case kIMAAdEvent_STARTED:
            if (_sendAdplayOnStarted) {
                playbackEvent = [MUXSDKAdPlayEvent new];
                [_playerBinding dispatchAdEvent: playbackEvent];
            } else {
                _sendAdplayOnStarted = YES;
            }
            playbackEvent = [MUXSDKAdPlayingEvent new];
            break;
        case kIMAAdEvent_FIRST_QUARTILE:
            playbackEvent = [MUXSDKAdFirstQuartileEvent new];
            break;
        case kIMAAdEvent_MIDPOINT:
            playbackEvent = [MUXSDKAdMidpointEvent new];
            break;
        case kIMAAdEvent_THIRD_QUARTILE:
            playbackEvent = [MUXSDKAdThirdQuartileEvent new];
            break;
        case kIMAAdEvent_SKIPPED:
        case kIMAAdEvent_COMPLETE:
            playbackEvent = [MUXSDKAdEndedEvent new];
            break;
        case kIMAAdEvent_PAUSE:
            playbackEvent = [MUXSDKAdPauseEvent new];
            break;
        case kIMAAdEvent_RESUME:
            playbackEvent = [MUXSDKAdPlayEvent new];
            [self setupAdViewData:playbackEvent withAd:event.ad];
            [_playerBinding dispatchAdEvent: playbackEvent];
            playbackEvent = [MUXSDKAdPlayingEvent new];
            break;
        case kIMAAdEvent_LOG:
            if (adData && adData[@"logData"]) {
                NSDictionary *errorLog = (NSDictionary *)adData[@"logData"];
                if (errorLog) {
                    if (errorLog[@"errorCode"] || errorLog[@"errorMessage"] || errorLog[@"type"]) {
                        playbackEvent = [[MUXSDKAdErrorEvent alloc] init];
                    }
                }
            }
            break;
        default:
            break;
    }
    if (playbackEvent != nil) {
        [self setupAdViewData:playbackEvent withAd:event.ad];
        [_playerBinding dispatchAdEvent:playbackEvent];
        return playbackEvent;
    } else {
        return nil;
    }
}

- (void)dispatchError:(NSString *)message {
    MUXSDKAdEvent *playbackEvent = [MUXSDKAdErrorEvent new];
    [self setupAdViewData:playbackEvent withAd:nil];
    [_playerBinding dispatchAdEvent:playbackEvent];
}

- (void)onContentPauseOrResume:(bool)isPause {
    MUXSDKAdEvent *playbackEvent;
    if (isPause) {
        if (_isPictureInPicture) {
            [_playerBinding setAdPlaying:YES];
        }
        if (!_adRequestReported) {
            // TODO: This is for backward compatability. Callers should call one of the *AdRequest methods. Remove this check in the next major rev
            [self dispatchAdRequestWithoutMetadata];
        }
        MUXSDKAdEvent *playbackEvent = [MUXSDKAdBreakStartEvent new];
        [self setupAdViewData:playbackEvent withAd:nil];
        [_playerBinding dispatchAdEvent: playbackEvent];
        
        _sendAdplayOnStarted = NO;
        [_playerBinding dispatchAdEvent: [[MUXSDKAdPlayEvent alloc] init]];
        
        return;
    } else {
        if (_isPictureInPicture) {
            [_playerBinding setAdPlaying:NO];
        }
        playbackEvent = [MUXSDKAdBreakEndEvent new];
        [self setupAdViewDataAndDispatchEvent: playbackEvent];
        if (_usesServerSideAdInsertion) {
            [_playerBinding dispatchPlay];
            [_playerBinding dispatchPlaying];
        }
    }
}

- (void)setupAdViewDataAndDispatchEvent:(MUXSDKAdEvent *) event {
    [self setupAdViewData:event withAd:nil];
    [_playerBinding dispatchAdEvent:event];
}

- (void)clientAdRequest:(IMAAdsRequest *)request {
    _usesServerSideAdInsertion = NO;
    _adRequestReported = YES;
    
    [self dispatchAdRequestForAdTag:request.adTagUrl];
}

- (void)daiAdRequest:(IMAStreamRequest *)request {
    _usesServerSideAdInsertion = YES;
    _adRequestReported = YES;
    
    [self dispatchAdRequestWithoutMetadata];
}

- (void)dispatchAdRequestWithoutMetadata {
    MUXSDKAdEvent* playbackEvent = [MUXSDKAdRequestEvent new];
    [self setupAdViewDataAndDispatchEvent: playbackEvent];
}

- (void)dispatchAdRequestForAdTag:(NSString *_Nullable)adTagUrl {
    MUXSDKAdEvent* playbackEvent = [MUXSDKAdRequestEvent new];
    MUXSDKAdData* adData = [MUXSDKAdData new];
    if(adTagUrl) {
        self.adTagURL = adTagUrl;
        adData.adTagUrl = adTagUrl;
    }
    
    [self setupAdViewDataAndDispatchEvent: playbackEvent];
}

- (void)setPictureInPicture:(BOOL)isPictureInPicture {
    _isPictureInPicture = isPictureInPicture;
}

/* IMAAdsManagerDelegate */

- (void)adsManager:(IMAAdsManager *)adsManager didReceiveAdEvent:(IMAAdEvent *)event {
    if (self.customerAdsManagerDelegate) {
        [self.customerAdsManagerDelegate adsManager:adsManager didReceiveAdEvent:event];
    }
    [self dispatchEvent: event];
}

- (void)adsManager:(nonnull IMAAdsManager *)adsManager didReceiveAdError:(nonnull IMAAdError *)error {
    if (self.customerAdsManagerDelegate) {
        [self.customerAdsManagerDelegate adsManager:adsManager didReceiveAdError:error];
    }
    [self dispatchError: error.message];
}

- (void)adsManagerDidRequestContentPause:(nonnull IMAAdsManager *)adsManager {
    if (self.customerAdsManagerDelegate) {
        [self.customerAdsManagerDelegate adsManagerDidRequestContentPause:adsManager];
    }
    // record content-pause last so adbreakstart happens after pause, to bracket the adbreak correctly
    [self onContentPauseOrResume:true];
}

- (void)adsManagerDidRequestContentResume:(nonnull IMAAdsManager *)adsManager {
    // record content-resume first so adbreakend happens before playing (brackets the ad break
    [self onContentPauseOrResume:false];
    if (self.customerAdsManagerDelegate) {
        [self.customerAdsManagerDelegate adsManagerDidRequestContentResume:adsManager];
    }
}

/* IMAAdsLoaderDelegate */

- (void)adsLoader:(nonnull IMAAdsLoader *)loader adsLoadedWithData:(nonnull IMAAdsLoadedData *)adsLoadedData {
    if (self.customerAdsLoaderDelegate) {
        [self.customerAdsLoaderDelegate adsLoader:loader adsLoadedWithData:adsLoadedData];
    }
    [self.playerBinding dispatchAdEvent:[[MUXSDKAdResponseEvent alloc] init]];
}

- (void)adsLoader:(nonnull IMAAdsLoader *)loader failedWithErrorData:(nonnull IMAAdLoadingErrorData *)adErrorData {
    if (self.customerAdsLoaderDelegate) {
        [self.customerAdsLoaderDelegate adsLoader:loader failedWithErrorData:adErrorData];
    }
    [self dispatchError:adErrorData.adError.message];
}

@end
