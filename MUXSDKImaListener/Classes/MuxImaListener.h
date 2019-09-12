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
    @public MUXSDKPlayerBinding *playerBinding;
}

- (id)initWithPlayerBinding:(MUXSDKPlayerBinding *)binding;
- (void)dispatchEvent:(NSString *)event;
//- (void)dispatchError:(NSString *)message;
//- (void)onContentPauseOrResume :(bool)isPause;

@end

NS_ASSUME_NONNULL_END
