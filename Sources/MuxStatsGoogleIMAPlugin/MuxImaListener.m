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

@end

@implementation MuxImaListener

- (id)initWithPlayerBinding:(MUXSDKPlayerBinding *)binding {
    return [self initWithPlayerBinding:binding options:MuxImaListenerOptionsNone];
}

- (id)initWithPlayerBinding:(MUXSDKPlayerBinding *)binding options:(MuxImaListenerOptions) options {
    self = [super init];

    if (self) {
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

- (nullable MUXSDKAdEvent *)dispatchEvent:(IMAAdEventType)eventType
                               withAdData:(nullable MUXSDKAdData *)adData
                            withIMAAdData:(nullable NSDictionary *)imaAdData {
    MUXSDKAdEvent *playbackEvent;

    switch(eventType) {
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
    [self setupAdViewData:playbackEvent withAd:nil];
    [[self playerBinding] dispatchAdEvent:playbackEvent];
}

- (void)dispatchAdRequestForAdTag:(NSString *_Nullable)adTagUrl {
    MUXSDKAdEvent* playbackEvent = [[MUXSDKAdRequestEvent alloc] init];
    MUXSDKAdData* adData = [[MUXSDKAdData alloc] init];
    if (adTagUrl) {
        adData.adTagUrl = adTagUrl;
    }
    
    [self setupAdViewData:playbackEvent withAd:nil];
    [[self playerBinding] dispatchAdEvent:playbackEvent];
}

- (void)setPictureInPicture:(BOOL)isPictureInPicture {
    _isPictureInPicture = isPictureInPicture;
}

@end
