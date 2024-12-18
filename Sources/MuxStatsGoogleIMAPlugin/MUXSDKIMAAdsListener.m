//
//  MUXSDKIMAAdsListener.m
//  MuxStatsGoogleIMAPlugin
//

#import <Foundation/Foundation.h>
#import "MUXSDKIMAAdsListener.h"

@interface MUXSDKIMAAdsListener ()

@property (nonatomic, nonnull) MUXSDKPlayerBinding *playerBinding;

@property (assign) BOOL sendAdplayOnStarted;
@property (assign) BOOL isPictureInPicture;
@property (assign) BOOL usesServerSideAdInsertion;
@property (assign) BOOL adRequestReported;
@property (assign) BOOL isPostRollAdScheduled;
@property (assign) BOOL automaticVideoChange;
@property (assign) NSString *adTagURL;

@end

@implementation MUXSDKIMAAdsListener

- (instancetype)initWithPlayerBinding:(MUXSDKPlayerBinding *)binding
                  monitoringAdsLoader:(nullable IMAAdsLoader *)adsLoader {
    return [self initWithPlayerBinding:binding
                               options:MUXSDKIMAAdsListenerOptionsNone
                   monitoringAdsLoader:adsLoader];
}

- (instancetype)initWithPlayerBinding:(MUXSDKPlayerBinding *)binding
                              options:(MUXSDKIMAAdsListenerOptions)options
                  monitoringAdsLoader:(IMAAdsLoader *)adsLoader {
    self = [super init];

    if (self) {
        _customerAdsLoaderDelegate = adsLoader.delegate;
        adsLoader.delegate = self;

        // The Ads Manager isn't created until further into the wokflow

        _playerBinding = binding;
        
        // We take this over from the base SDK so we can handle postrolls without changing the view
        // TODO: Must also be able to query if automatic video change is enabled (or else an API on playerBinding to tell it when ads are scheduled & completed)
        if (/*not exactly the condition we want*/true) {
            [binding setAutomaticVideoChange:NO];
            _automaticVideoChange = YES;
        }
        
        if ((options & MUXSDKIMAAdsListenerOptionsPictureInPicture) == MUXSDKIMAAdsListenerOptionsNone) {
            _isPictureInPicture = NO;
        }
        if ((options & MUXSDKIMAAdsListenerOptionsPictureInPicture) == MUXSDKIMAAdsListenerOptionsPictureInPicture) {
            _isPictureInPicture = YES;
        }
        _usesServerSideAdInsertion = NO;
        _adRequestReported = NO;
        _sendAdplayOnStarted = NO;
        _isPostRollAdScheduled = NO;
    }

    return self;
}

// TODO move down the file
-(BOOL)adsManagerSchedulesPostroll:(IMAAdsManager *)adsManager {
    NSNumber *postRollCuePointValue = [NSNumber numberWithInt:-1];
    NSUInteger cuePoint = [adsManager.adCuePoints indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([postRollCuePointValue isEqual:obj]) {
                stop = YES;
                return true;
            } else {
                return false;
            }
        }];
    return cuePoint != nil;
}

- (void)monitorAdsManager:(IMAAdsManager *)adsManager {
    // TODO: SDK always disables automaticVideoChange??
    if (adsManager && adsManager.adCuePoints && [self adsManagerSchedulesPostroll:adsManager]) {
        _isPostRollAdScheduled = YES;
    } else {
        _isPostRollAdScheduled = NO;
    }
    
    self.customerAdsManagerDelegate = adsManager.delegate;
    adsManager.delegate = self;
}

- (void)setupAdViewData:(MUXSDKAdEvent *)event withAd:(IMAAd *)ad {
    MUXSDKViewData *viewData = [[MUXSDKViewData alloc] init];
    MUXSDKAdData *adData = [[MUXSDKAdData alloc] init];
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

- (nullable MUXSDKAdEvent *)dispatchEvent:(IMAAdEvent *)event {

    MUXSDKAdData *adData = [[MUXSDKAdData alloc] init];
    if (event.ad != nil) {
        adData.adId = event.ad.adId;
        adData.adCreativeId = event.ad.creativeID;

        // TODO: use newer IMA API here. universalAdIdValue
        // is deprecated, but used for time being for parity
        // with web&android
        adData.adUniversalId = event.ad.universalAdIdValue;
    }

    return [self dispatchEvent:event.type
                    withAdData:adData
                 withIMAAdData:event.adData];
}

- (nullable MUXSDKAdEvent *)dispatchEventOfType:(IMAAdEventType)eventType {
    return [self dispatchEvent:eventType
                    withAdData:nil
                 withIMAAdData:nil];
}

- (nullable MUXSDKAdEvent *)dispatchEvent:(IMAAdEventType)eventType
                               withAdData:(nullable MUXSDKAdData *)adData
                            withIMAAdData:(nullable NSDictionary *)imaAdData {
    MUXSDKAdEvent *playbackEvent;

    switch(eventType) {
        case kIMAAdEvent_ALL_ADS_COMPLETED: {
            if (_isPostRollAdScheduled && _automaticVideoChange) {
                NSLog(@">>dispatchEvent: Postroll was scheduled and automatic video change");
                if (_playerBinding) {
                    [MUXSDKStats videoChangeForPlayer:<#(nonnull NSString *)#> withCustomerData:[[MUXSDKCustomData alloc] init]];
                }
            }
        }
        case kIMAAdEvent_STARTED: {
            if (_sendAdplayOnStarted) {
                playbackEvent = [[MUXSDKAdPlayEvent alloc] init];
                [_playerBinding dispatchAdEvent: playbackEvent];
            } else {
                _sendAdplayOnStarted = YES;
            }
            playbackEvent = [[MUXSDKAdPlayingEvent alloc] init];
            break;
        }
        case kIMAAdEvent_FIRST_QUARTILE: {
            playbackEvent = [[MUXSDKAdFirstQuartileEvent alloc] init];
            break;
        }
        case kIMAAdEvent_MIDPOINT: {
            playbackEvent = [[MUXSDKAdMidpointEvent alloc] init];
            break;
        }
        case kIMAAdEvent_THIRD_QUARTILE: {
            playbackEvent = [[MUXSDKAdThirdQuartileEvent alloc] init];
            break;
        }
        case kIMAAdEvent_SKIPPED: {
            playbackEvent = [[MUXSDKAdEndedEvent alloc] init];
            break;
        }
        case kIMAAdEvent_COMPLETE: {
            playbackEvent = [[MUXSDKAdEndedEvent alloc] init];
            break;
        }
        case kIMAAdEvent_PAUSE: {
            playbackEvent = [[MUXSDKAdPauseEvent alloc] init];
            break;
        }
        case kIMAAdEvent_RESUME: {
            playbackEvent = [[MUXSDKAdPlayEvent alloc] init];
            MUXSDKViewData *viewData = [[MUXSDKViewData alloc] init];
            if ([_playerBinding getCurrentPlayheadTimeMs] < 1000) {
                viewData.viewPrerollAdId = adData.adId;
                viewData.viewPrerollCreativeId = adData.adCreativeId;
            }
            playbackEvent.viewData = viewData;
            playbackEvent.adData = adData;
            [_playerBinding dispatchAdEvent: playbackEvent];
            playbackEvent = [[MUXSDKAdPlayingEvent alloc] init];
            break;
        }
        case kIMAAdEvent_LOG: {
            if (imaAdData && imaAdData[@"logData"]) {
                NSDictionary *errorLog = (NSDictionary *)imaAdData[@"logData"];
                if (errorLog) {
                    if (errorLog[@"errorCode"] || errorLog[@"errorMessage"] || errorLog[@"type"]) {
                        playbackEvent = [[MUXSDKAdErrorEvent alloc] init];
                    }
                }
            }
            break;
        }
        default:
            break;
    }

    if (playbackEvent != nil) {
        MUXSDKViewData *viewData = [[MUXSDKViewData alloc] init];
        if ([_playerBinding getCurrentPlayheadTimeMs] < 1000) {
            viewData.viewPrerollAdId = adData.adId;
            viewData.viewPrerollCreativeId = adData.adCreativeId;
        }
        playbackEvent.viewData = viewData;
        playbackEvent.adData = adData;
        [_playerBinding dispatchAdEvent:playbackEvent];
        return playbackEvent;
    } else {
        return nil;
    }
}

- (void)dispatchError:(NSString *)message {
    MUXSDKAdEvent *playbackEvent = [[MUXSDKAdErrorEvent alloc] init];
    [self setupAdViewData:playbackEvent withAd:nil];
    [_playerBinding dispatchAdEvent:playbackEvent];
}

- (void)dispatchPauseOrResume:(BOOL)isPause {
    MUXSDKAdEvent *playbackEvent;
    if (isPause) {
        if (_isPictureInPicture) {
            [_playerBinding setAdPlaying:YES];
        }
        if (!_adRequestReported) {
            // TODO: This is for backward compatability. Callers should call one of the *AdRequest methods. Remove this check in the next major rev
            [self dispatchAdRequestWithoutMetadata];
        }
        MUXSDKAdEvent *playbackEvent = [[MUXSDKAdBreakStartEvent alloc] init];
        [self setupAdViewData:playbackEvent withAd:nil];
        [_playerBinding dispatchAdEvent: playbackEvent];

        _sendAdplayOnStarted = NO;
        [_playerBinding dispatchAdEvent: [[MUXSDKAdPlayEvent alloc] init]];

        return;
    } else {
        if (_isPictureInPicture) {
            [_playerBinding setAdPlaying:NO];
        }
        playbackEvent = [[MUXSDKAdBreakEndEvent alloc] init];
        [self setupAdViewDataAndDispatchEvent: playbackEvent];
        if (_usesServerSideAdInsertion) {
            [_playerBinding dispatchPlay];
            [_playerBinding dispatchPlaying];
        }
    }
}

- (void)onContentPauseOrResume:(BOOL)isPause {
    [self dispatchPauseOrResume:isPause];
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
    MUXSDKAdEvent* playbackEvent = [[MUXSDKAdRequestEvent alloc] init];
    [self setupAdViewDataAndDispatchEvent: playbackEvent];
}

- (void)dispatchAdRequestForAdTag:(nullable NSString *)adTagUrl {
    MUXSDKAdEvent* playbackEvent = [[MUXSDKAdRequestEvent alloc] init];
    MUXSDKAdData* adData = [[MUXSDKAdData alloc] init];
    if(adTagUrl) {
        self.adTagURL = adTagUrl;
        adData.adTagUrl = adTagUrl;
    }

    [self setupAdViewDataAndDispatchEvent: playbackEvent];
}

- (void)setPictureInPicture:(BOOL)isPictureInPicture {
    _isPictureInPicture = isPictureInPicture;
}

#pragma mark IMAAdsManagerDelegate required methods

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
    // record content-resume first so adbreakend happens before playing (brackets the ad break)
    [self onContentPauseOrResume:false];
    if (self.customerAdsManagerDelegate) {
        [self.customerAdsManagerDelegate adsManagerDidRequestContentResume:adsManager];
    }
}

#pragma mark IMAAdsManagerDelegate optional methods

- (void)adsManager:(IMAAdsManager *)adsManager
adDidProgressToTime:(NSTimeInterval)mediaTime
         totalTime:(NSTimeInterval)totalTime {
    if (self.customerAdsManagerDelegate &&
        [(id)(self.customerAdsManagerDelegate) respondsToSelector:@selector(adsManager:adDidProgressToTime:totalTime:)]) {
            [self.customerAdsManagerDelegate adsManager:adsManager
                                    adDidProgressToTime:mediaTime
                                              totalTime:totalTime];
        }
}

- (void)adsManagerAdPlaybackReady:(IMAAdsManager *)adsManager {
    if (self.customerAdsManagerDelegate &&
        [(id)(self.customerAdsManagerDelegate) respondsToSelector:@selector(adsManagerAdPlaybackReady:)]) {
        [self.customerAdsManagerDelegate adsManagerAdPlaybackReady:adsManager];
    }
}

- (void)adsManagerAdDidStartBuffering:(IMAAdsManager *)adsManager {
    if (self.customerAdsManagerDelegate &&
        [(id)(self.customerAdsManagerDelegate) respondsToSelector:@selector(adsManagerAdDidStartBuffering:)]) {
        [self.customerAdsManagerDelegate adsManagerAdDidStartBuffering:adsManager];
    }
}

- (void)adsManager:(IMAAdsManager *)adsManager
adDidBufferToMediaTime:(NSTimeInterval)mediaTime {
    if (self.customerAdsManagerDelegate &&
        [(id)(self.customerAdsManagerDelegate) respondsToSelector:@selector(adsManager:adDidBufferToMediaTime:)]) {
        [self.customerAdsManagerDelegate adsManager:adsManager adDidBufferToMediaTime:mediaTime];
    }
}

#pragma mark IMAAdsLoaderDelegate

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
