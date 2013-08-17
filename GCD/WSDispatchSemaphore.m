//
//  WSDispatchSemaphore.m
//
//  Created by Ray Hilton on 24/10/11.
//  Copyright (c) 2011 Wirestorm Pty Ltd. All rights reserved.
//

#import "WSDispatchSemaphore.h"

@interface WSDispatchSemaphore ()
@property dispatch_semaphore_t semaphore;
@end
@implementation WSDispatchSemaphore

+ (WSDispatchSemaphore *)semaphoreWithPoolSize:(NSInteger)size
{
    return [[WSDispatchSemaphore alloc] initWithSize:size];
}

- (id)initWithSize:(NSInteger)size
{
    if(self = [super init]) {
        self.semaphore = dispatch_semaphore_create(size);
    }
    return self;
}

-(void)signal
{
    dispatch_semaphore_signal(self.semaphore);
}

- (void)wait:(NSTimeInterval)timeInterval
{
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, timeInterval * NSEC_PER_SEC);
    dispatch_semaphore_wait(self.semaphore, delay);
}

- (void)waitForever
{
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
}

@end
