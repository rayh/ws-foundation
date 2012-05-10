//
//  NSObject+WSDispatchMonitor.m
//  Cardola
//
//  Created by Ray Hilton on 10/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSObject+WSDispatchMonitor.h"
#import "WSDispatchQueue.h"
#import "WSDispatchMonitor.h"

@implementation NSObject (WSDispatchMonitor)

- (void)wait:(void(^)(WSDispatchSemaphore *sempahore))block
{
    static WSDispatchMonitor *monitor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        monitor = [WSDispatchMonitor monitorWithSize:1];
    });
    
    [monitor enter:block];
}

@end
