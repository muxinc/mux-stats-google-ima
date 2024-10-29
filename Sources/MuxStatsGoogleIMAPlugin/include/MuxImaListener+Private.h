//
//  Header.h
//  
//
//  Created by Emily Dixon on 10/29/24.
//

#ifndef Header_h
#define Header_h

@interface MuxImaListener(Tests)

// MARK: Manual event reporting
- (MUXSDKAdEvent *_Nullable)dispatchEventOfType:(IMAAdEventType)eventType;
- (void)dispatchError:(NSString *)message;
- (void)onContentPauseOrResume:(bool)isPause;

@end

#endif /* Header_h */
