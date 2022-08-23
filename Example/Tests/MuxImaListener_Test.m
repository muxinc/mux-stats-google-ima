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
@end

@implementation MuxMockImaAdEvent

@synthesize type;

- (id)initWithType:(NSInteger)_type {
    type = _type;
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
            MuxImaListenerOptions options = MuxImaListenerOptionsPictureInPicture | MuxImaListenerOptionsServerSideAdInsertion;
            MuxImaListener *imaListener = [[MuxImaListener alloc] initWithPlayerBinding:playerBinding options:options];
            expect(imaListener).toNot.beNil();
        });
    });

    describe(@"dispatchEvent", ^{
        __block MuxImaListener *imaListener = nil;
        beforeEach(^{
            imaListener = [[MuxImaListener alloc] initWithPlayerBinding:playerBinding];
        });

        it(@"should dispatch the correct event for kIMAAdEvent_LOADED", ^{
            MuxMockImaAdEvent *adEvent = [[MuxMockImaAdEvent alloc] initWithType:kIMAAdEvent_LOADED];
            MUXSDKPlaybackEvent *playbackEvent = [imaListener dispatchEvent:adEvent];
            expect(playbackEvent).to.beKindOf([MUXSDKAdPlayEvent class]);
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

        it(@"should not dispatch an event for kIMAAdEvent_TAPPED", ^{
            MuxMockImaAdEvent *adEvent = [[MuxMockImaAdEvent alloc] initWithType:kIMAAdEvent_TAPPED];
            MUXSDKPlaybackEvent *playbackEvent = [imaListener dispatchEvent:adEvent];
            expect(playbackEvent).to.beNil();
        });
    });
});

SpecEnd
