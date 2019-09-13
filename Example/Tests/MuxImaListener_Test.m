//
//  MUXSDKImaListenerTests.m
//  MUXSDKImaListenerTests
//
//  Created by Dylan Jhaveri on 09/11/2019.
//  Copyright (c) 2019 Dylan Jhaveri. All rights reserved.
//

// https://github.com/Specta/Specta

#import "MuxImaListener.h"
//@import MUXSDKImaListener;
//@import MUXSDKStats;

//@interface MuxMockAVPlayerViewController : AVPlayerViewController
//@end
//
//@implementation MuxMockAVPlayerViewController
//- (id)init {
//    if (self = [super init]) {
//        self.player = [[AVPlayer alloc] init];
//    }
//    return self;
//}
//@end
//
@interface MuxMockAVPlayerLayer : AVPlayerLayer
@end

@implementation MuxMockAVPlayerLayer
- (id)init {
    if (self = [super init]) {
        self.player = [[AVPlayer alloc] init];
    }
    return self;
}
@end
//
//@interface MuxMockImaAdEvent : IMAAdEvent
//@end
//
//@implementation MuxMockImaAdEvent
//- (id)init {
////    if (self = [super init]) {
//////        self.player = [[AVPlayer alloc] init];
////    }
//    return self;
//}
//@end

SpecBegin(InitialSpecs)

describe(@"MuxImaListener", ^{
    __block MUXSDKPlayerBinding *playerBinding = nil;
    beforeEach(^{
        NSString *name = @"Test Player Name";
        NSString *software = @"AVPlayerLayer";
        MuxMockAVPlayerLayer *playerLayer = [[MuxMockAVPlayerLayer alloc] init];
        playerBinding = [[MUXSDKAVPlayerLayerBinding alloc] initWithName:name software:software andView:playerLayer];
    });

    describe(@"initWithPlayerBinding", ^{
        it(@"should initialize an object", ^{
            MuxImaListener *imaListener = [[MuxImaListener alloc] initWithPlayerBinding:playerBinding];
            expect(imaListener).toNot.beNil();
        });
    });

//    describe(@"dispatchEvent", ^{
//        it(@"should dispatch an event", ^{
//            IMAAdEvent *adEvent = [[MuxMockImaAdEvent alloc] init];
//            MuxImaListener *imaListener = [[MuxImaListener alloc] initWithPlayerBinding:playerBinding];
//            [imaListener dispatchEvent:adEvent];
//        });
//    });
});

//SpecBegin(InitialSpecs)
//
//describe(@"these will fail", ^{
//
//    it(@"can do maths", ^{
//        expect(1).to.equal(2);
//    });
//
//    it(@"can read", ^{
//        expect(@"number").to.equal(@"string");
//    });
//
//    it(@"will wait for 10 seconds and fail", ^{
//        waitUntil(^(DoneCallback done) {
//
//        });
//    });
//});
//
//describe(@"these will pass", ^{
//
//    it(@"can do maths", ^{
//        expect(1).beLessThan(23);
//    });
//
//    it(@"can read", ^{
//        expect(@"team").toNot.contain(@"I");
//    });
//
//    it(@"will wait and succeed", ^{
//        waitUntil(^(DoneCallback done) {
//            done();
//        });
//    });
//});

SpecEnd

