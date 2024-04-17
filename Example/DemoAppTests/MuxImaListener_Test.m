//
//  MUXSDKImaListenerTests.m
//  MUXSDKImaListenerTests
//
//  Created by Dylan Jhaveri on 09/11/2019.
//  Copyright (c) 2019 Dylan Jhaveri. All rights reserved.
//

// https://github.com/Specta/Specta

@import Mux_Stats_Google_IMA;

@interface MuxMockAVPlayerViewController : AVPlayerViewController
@end

@implementation MuxMockAVPlayerViewController
- (id)init {
    if (self = [super init]) {
        self.player = [[AVPlayer alloc] init];
    }
    return self;
}
@end

@interface MuxMockImaAdEvent : IMAAdEvent {
    enum IMAAdEventType type;
}
    @property (nonatomic) enum IMAAdEventType type;
    @property(nonatomic, copy, nullable) NSDictionary<NSString *, id> *adData;
@end

@implementation MuxMockImaAdEvent

@synthesize type;
@synthesize adData;

- (id)initWithType:(NSInteger)_type {
    type = _type;
    return self;
}

- (id)initWithType:(NSInteger)_type andAdData:(NSDictionary*)_adData {
    type = _type;
    adData = _adData;
    return self;
}
@end

SpecBegin(InitialSpecs)

describe(@"MuxImaListener", ^{
    __block MUXSDKPlayerBinding *playerBinding = nil;
    beforeEach(^{
        NSString *name = @"Test Player Name";
        MUXSDKCustomerPlayerData *playerData = [[MUXSDKCustomerPlayerData alloc] initWithPropertyKey:@"YOUR_ENVIRONMENT_KEY"];
        MUXSDKCustomerVideoData *videoData = [MUXSDKCustomerVideoData new];
        videoData.videoTitle = @"Big Buck Bunny";
        videoData.videoId = @"bigbuckbunny";
        videoData.videoSeries = @"animation";
        MuxMockAVPlayerViewController *avPlayerController = [[MuxMockAVPlayerViewController alloc] init];
        playerBinding = [MUXSDKStats monitorAVPlayerViewController:avPlayerController
                                                   withPlayerName:name
                                                       playerData:playerData
                                                        videoData:videoData];
    });

    describe(@"initWithPlayerBinding", ^{
        it(@"should initialize an object", ^{
            MuxImaListener *imaListener = [[MuxImaListener alloc] initWithPlayerBinding:playerBinding];
            expect(imaListener).toNot.beNil();
        });
    });
    
    describe(@"initWithPlayerBindingWithOptions", ^{
        it(@"should initialize an object", ^{
            MuxImaListenerOptions options = MuxImaListenerOptionsPictureInPicture;
            MuxImaListener *imaListener = [[MuxImaListener alloc] initWithPlayerBinding:playerBinding options:options];
            expect(imaListener).toNot.beNil();
        });
    });

    describe(@"dispatchEvent", ^{
        __block MuxImaListener *imaListener = nil;
        beforeEach(^{
            imaListener = [[MuxImaListener alloc] initWithPlayerBinding:playerBinding];
        });

        it(@"should dispatch the correct event for kIMAAdEvent_STARTED", ^{
            MuxMockImaAdEvent *adEvent = [[MuxMockImaAdEvent alloc] initWithType:kIMAAdEvent_STARTED];
            MUXSDKPlaybackEvent *playbackEvent = [imaListener dispatchEvent:adEvent];
            expect(playbackEvent).to.beKindOf([MUXSDKAdPlayingEvent class]);
        });

        it(@"should dispatch the correct event for kIMAAdEvent_FIRST_QUARTILE", ^{
            MuxMockImaAdEvent *adEvent = [[MuxMockImaAdEvent alloc] initWithType:kIMAAdEvent_FIRST_QUARTILE];
            MUXSDKPlaybackEvent *playbackEvent = [imaListener dispatchEvent:adEvent];
            expect(playbackEvent).to.beKindOf([MUXSDKAdFirstQuartileEvent class]);
        });

        it(@"should dispatch the correct event for kIMAAdEvent_MIDPOINT", ^{
            MuxMockImaAdEvent *adEvent = [[MuxMockImaAdEvent alloc] initWithType:kIMAAdEvent_MIDPOINT];
            MUXSDKPlaybackEvent *playbackEvent = [imaListener dispatchEvent:adEvent];
            expect(playbackEvent).to.beKindOf([MUXSDKAdMidpointEvent class]);
        });

        it(@"should dispatch the correct event for kIMAAdEvent_THIRD_QUARTILE", ^{
            MuxMockImaAdEvent *adEvent = [[MuxMockImaAdEvent alloc] initWithType:kIMAAdEvent_THIRD_QUARTILE];
            MUXSDKPlaybackEvent *playbackEvent = [imaListener dispatchEvent:adEvent];
            expect(playbackEvent).to.beKindOf([MUXSDKAdThirdQuartileEvent class]);
        });

        it(@"should dispatch the correct event for kIMAAdEvent_SKIPPED", ^{
            MuxMockImaAdEvent *adEvent = [[MuxMockImaAdEvent alloc] initWithType:kIMAAdEvent_SKIPPED];
            MUXSDKPlaybackEvent *playbackEvent = [imaListener dispatchEvent:adEvent];
            expect(playbackEvent).to.beKindOf([MUXSDKAdEndedEvent class]);
        });

        it(@"should dispatch the correct event for kIMAAdEvent_COMPLETE", ^{
            MuxMockImaAdEvent *adEvent = [[MuxMockImaAdEvent alloc] initWithType:kIMAAdEvent_COMPLETE];
            MUXSDKPlaybackEvent *playbackEvent = [imaListener dispatchEvent:adEvent];
            expect(playbackEvent).to.beKindOf([MUXSDKAdEndedEvent class]);
        });

        it(@"should dispatch the correct event for kIMAAdEvent_PAUSE", ^{
            MuxMockImaAdEvent *adEvent = [[MuxMockImaAdEvent alloc] initWithType:kIMAAdEvent_PAUSE];
            MUXSDKPlaybackEvent *playbackEvent = [imaListener dispatchEvent:adEvent];
            expect(playbackEvent).to.beKindOf([MUXSDKAdPauseEvent class]);
        });
        
        it(@"should not dispatch aderror for LOG event *without* error info", ^{
            MuxMockImaAdEvent *adEvent = [[MuxMockImaAdEvent alloc] initWithType:kIMAAdEvent_LOG];
            MUXSDKPlaybackEvent *playbackEvent = [imaListener dispatchEvent:adEvent];
            expect(playbackEvent).to.beNil();
        });
        
        it(@"should dispatch aderror for LOG event with error info", ^{
            NSMutableDictionary *mockErrorData = [[NSMutableDictionary alloc] init];
            [mockErrorData setObject:[NSNumber numberWithInt:110] forKey:@"errorCode"];
            [mockErrorData setObject:@"mock message" forKey:@"errorMessage"];
            [mockErrorData setObject:@"adPlayError" forKey:@"type"];
            NSMutableDictionary *mockLogData = [[NSMutableDictionary alloc] init];
            [mockLogData setObject:mockErrorData forKey:@"logData"];
            
            MuxMockImaAdEvent *adEvent = [[MuxMockImaAdEvent alloc] initWithType:kIMAAdEvent_LOG andAdData:mockLogData];
            
            MUXSDKPlaybackEvent *playbackEvent = [imaListener dispatchEvent:adEvent];
            expect(playbackEvent).to.beKindOf([MUXSDKAdErrorEvent class]);
        });

        it(@"should not dispatch an event for kIMAAdEvent_TAPPED", ^{
            MuxMockImaAdEvent *adEvent = [[MuxMockImaAdEvent alloc] initWithType:kIMAAdEvent_TAPPED];
            MUXSDKPlaybackEvent *playbackEvent = [imaListener dispatchEvent:adEvent];
            expect(playbackEvent).to.beNil();
        });
    });
});

SpecEnd
