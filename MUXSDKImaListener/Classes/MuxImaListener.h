//
//  MUXSDKImaListener.h
//  Expecta
//
//  Created by Dylan Jhaveri on 9/11/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@import MuxCore;
@import GoogleInteractiveMediaAds;

@class MUXSDKPlayerBinding;

@interface MuxImaListener : NSObject {
    MUXSDKPlayerBinding *_playerBinding;
}

- (id)initWithPlayerBinding:(MUXSDKPlayerBinding *)binding;
//- (void)dispatchEvent:(IMAAdEvent *)event;
//- (void)dispatchError:(NSString *)message;
//- (void)onContentPauseOrResume :(bool)isPause;

@end

NS_ASSUME_NONNULL_END
