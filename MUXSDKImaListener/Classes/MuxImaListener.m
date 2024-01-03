//
//  MUXSDKImaListener.m
//  Expecta
//
//  Created by Dylan Jhaveri on 9/11/19.
//

#import "MuxImaListener.h"

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
    }
    return(self);
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
    switch(event.type) {
        case kIMAAdEvent_LOADED:
            playbackEvent = [MUXSDKAdResponseEvent new];
            [self setupAdViewData:playbackEvent withAd:event.ad];
            [_playerBinding dispatchAdEvent: playbackEvent];
            playbackEvent = [MUXSDKAdPlayEvent new];
            break;
        case kIMAAdEvent_STARTED:
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
        adData.adTagUrl = adTagUrl;
    }
    
    [self setupAdViewDataAndDispatchEvent: playbackEvent];
}

- (void)setPictureInPicture:(BOOL)isPictureInPicture {
    _isPictureInPicture = isPictureInPicture;
}

@end
