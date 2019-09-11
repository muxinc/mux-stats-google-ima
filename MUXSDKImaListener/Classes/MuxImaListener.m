//
//  MUXSDKImaListener.m
//  Expecta
//
//  Created by Dylan Jhaveri on 9/11/19.
//

#import "MuxImaListener.h"

@implementation MuxImaListener

- (id)initWithPlayerBinding:(MUXSDKPlayerBinding *)binding {
    self = [super init];
    NSLog(@"debug initt withPlayerBinding from obj-c");
    if (self) {
        _playerBinding = binding;
    }
    return(self);
}

@end
