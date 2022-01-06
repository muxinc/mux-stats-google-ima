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

@interface MuxImaListener : NSObject {
    @private MUXSDKPlayerBinding *_playerBinding;
    @private BOOL _isPictureInPicture;
}

- (id)initWithPlayerBinding:(MUXSDKPlayerBinding *)binding;
- (MUXSDKPlaybackEvent *_Nullable)dispatchEvent:(IMAAdEvent *)event;
- (void)dispatchError:(NSString *)message;
- (void)onContentPauseOrResume:(bool)isPause;
- (void)setPictureInPicture:(BOOL)isPictureInPicture;

@end

NS_ASSUME_NONNULL_END
