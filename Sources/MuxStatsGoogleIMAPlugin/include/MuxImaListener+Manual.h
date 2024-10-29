//
//  Header.h
//  
//
//  Created by Emily Dixon on 10/29/24.
//

#ifndef Header_h
#define Header_h

#import "MuxImaListener.h"

// todo - (Private)
@interface MuxImaListener(Manual)

// todo nice nullability
- (MUXSDKAdEvent *_Nullable)dispatchEventOfType:(IMAAdEventType)eventType;
// todo nice nullability
- (MUXSDKAdEvent *_Nullable)dispatchEvent:(IMAAdEventType)eventType
                                     withAdData:(nullable MUXSDKAdData *)adData 
                                  withIMAAdData:(nullable NSDictionary *)imaAdData;
- (void)dispatchError:(nullable NSString *)message;
- (void)onContentPauseOrResume:(bool)isPause;

@end

#endif /* Header_h */
