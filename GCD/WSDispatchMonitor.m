//
//  WSDispatchProtectedResource.m
//  
//
//  Created by Ray Hilton on 10/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WSDispatchMonitor.h"
#import "WSDispatchSemaphore.h"
#import "WSDispatchQueue.h"

@interface WSDispatchMonitor ()
@property (nonatomic, retain) WSDispatchSemaphore *semaphore;
@property (nonatomic, retain) WSDispatchQueue *queue;
@end

@implementation WSDispatchMonitor
@synthesize semaphore=_semaphore;
@synthesize queue=_queue;


+ (WSDispatchMonitor*)monitorWithSize:(NSInteger)size;
{
    return [[WSDispatchMonitor alloc] initWithLimit:size];
}

- (id)initWithLimit:(NSInteger)size;
{
    if(self = [super init]) {
        self.semaphore = [WSDispatchSemaphore semaphoreWithPoolSize:size];
        self.queue = [WSDispatchQueue defaultPriorityGlobalQueue];
    }
    
    return self;
}

- (void)enter:(void(^)(WSDispatchSemaphore *semaphore))block
{
    WSDispatchQueue *callingQueue = [WSDispatchQueue currentQueue];
    
    [self.queue async:^{
        [self.semaphore waitForever];
        [callingQueue async:^{
            block(self.semaphore);
        }];
    }];
}
@end