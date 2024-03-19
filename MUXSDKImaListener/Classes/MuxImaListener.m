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
    if ([_playerBinding getCurrentPlayheadTimeMs] < 1000) {
        if (ad != nil) {
            viewData.viewPrerollAdId = ad.adId;
            viewData.viewPrerollCreativeId = ad.creativeID;
            
            adData.adId = ad.adId;
            adData.adCreativeId = ad.creativeID;
            // universalAdIdValue is deprecated, but used for parity with web&android
            adData.adUniversalId = ad.universalAdIdValue;
            event.adData = adData;
        }
    }
    event.viewData = viewData;
}

- (MUXSDKAdEvent *_Nullable) dispatchEvent:(IMAAdEvent *)event {
    NSString *evStr = [self adEventDebugString:event.type];
    
    NSDate *nowish = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm:ss:SSS"];
    NSString *dateStr = [outputFormatter stringFromDate:nowish];
    
    NSLog(@"ADTEST: Ad Event %@ at %@", evStr, dateStr);
    NSDictionary *adData = event.adData;
    if (adData) {
        NSLog(@"ADTEST:\t with metadata:");
        NSEnumerator *e = adData.keyEnumerator;
        id key;
        while (key = [e nextObject]) {
            NSLog(@"ADTEST:\t %@ -> %@", key, [adData objectForKey:key]);
        }
    }
    NSLog(@"ADTEST:\t without metadata:");

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

-(NSString *)adEventDebugString:(IMAAdEventType)forType {
    switch (forType) {
        case kIMAAdEvent_AD_BREAK_READY:
            return @"AD_BREAK_READY";
            break;
        case kIMAAdEvent_AD_BREAK_FETCH_ERROR:
            return @"AD_BREAK_FETCH_ERROR";
            break;
        case kIMAAdEvent_AD_BREAK_ENDED:
            return @"AD_BREAK_ENDED";
            break;
        case kIMAAdEvent_AD_BREAK_STARTED:
            return @"AD_BREAK_STARTED";
            break;
        case kIMAAdEvent_AD_PERIOD_ENDED:
            return @"AD_PERIOD_ENDED";
            break;
        case kIMAAdEvent_AD_PERIOD_STARTED:
            return @"AD_PERIOD_STARTED";
            break;
        case kIMAAdEvent_ALL_ADS_COMPLETED:
            return @"ALL_ADS_COMPLETED";
            break;
        case kIMAAdEvent_CLICKED:
            return @"CLICKED";
            break;
        case kIMAAdEvent_COMPLETE:
            return @"COMPLETE";
            break;
        case kIMAAdEvent_CUEPOINTS_CHANGED:
            return @"CUEPOINTS_CHANGED";
            break;
        case kIMAAdEvent_ICON_FALLBACK_IMAGE_CLOSED:
            return @"ICON_FALLBACK_IMAGE_CLOSED";
            break;
        case kIMAAdEvent_ICON_TAPPED:
            return @"ICON_TAPPED";
            break;
        case kIMAAdEvent_FIRST_QUARTILE:
            return @"FIRST_QUARTILE";
            break;
        case kIMAAdEvent_LOADED:
            return @"LOADED";
            break;
        case kIMAAdEvent_LOG:
            return @"LOG";
            break;
        case kIMAAdEvent_MIDPOINT:
            return @"MIDPOINT";
            break;
        case kIMAAdEvent_PAUSE:
            return @"PAUSE";
            break;
        case kIMAAdEvent_SKIPPED:
            return @"SKIPPED";
            break;
        case kIMAAdEvent_STARTED:
            return @"STARTED";
            break;
        case kIMAAdEvent_STREAM_LOADED:
            return @"STREAM_LOADED";
            break;
        case kIMAAdEvent_STREAM_STARTED:
            return @"STREAM_STARTED";
            break;
        case kIMAAdEvent_TAPPED:
            return @"TAPPED";
            break;
        case kIMAAdEvent_THIRD_QUARTILE:
            return @"THIRD_QUARTILE";
            break;
        default:
            return @"[unknown]";
            break;
    }
}

@end
