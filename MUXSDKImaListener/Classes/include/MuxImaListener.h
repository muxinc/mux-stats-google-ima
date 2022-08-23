//
//  MUXSDKImaListener.h
//  Expecta
//
//  Created by Dylan Jhaveri on 9/11/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@import MuxCore;
@import MUXSDKStats;
@import GoogleInteractiveMediaAds;

@class MUXSDKPlayerBinding;

typedef NS_OPTIONS(NSUInteger, MuxImaListenerOptions) {
    MuxImaListenerOptionsNone                    = 0,
    MuxImaListenerOptionsPictureInPicture        = 1 << 0,
    MuxImaListenerOptionsServerSideAdInsertion   = 1 << 1,
};

@interface MuxImaListener : NSObject {
    @private MUXSDKPlayerBinding *_playerBinding;
    @private BOOL _isPictureInPicture;
    @private BOOL _usesServerSideAdInsertion;
}

- (id)initWithPlayerBinding:(MUXSDKPlayerBinding *)binding;
- (id)initWithPlayerBinding:(MUXSDKPlayerBinding *)binding options:(MuxImaListenerOptions) options;
- (MUXSDKPlaybackEvent *_Nullable)dispatchEvent:(IMAAdEvent *)event;
- (void)dispatchError:(NSString *)message;
- (void)onContentPauseOrResume:(bool)isPause;
- (void)setPictureInPicture:(BOOL)isPictureInPicture;

@end

NS_ASSUME_NONNULL_END
