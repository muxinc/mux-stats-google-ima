//
//  MuxImaListener+Private.h
//
//
//  Created by Emily Dixon on 10/29/24.
//

#import "MuxImaListener.h"

@interface MuxImaListener(Private)

// todo nice nullability
- (nullable MUXSDKAdEvent *)dispatchEventOfType:(IMAAdEventType)eventType;
// todo nice nullability
- (nullable MUXSDKAdEvent *)dispatchEvent:(IMAAdEventType)eventType
                               withAdData:(nullable MUXSDKAdData *)adData
                            withIMAAdData:(nullable NSDictionary *)imaAdData;
- (void)dispatchError:(nullable NSString *)message;
- (void)onContentPauseOrResume:(BOOL)isPause;

@end
