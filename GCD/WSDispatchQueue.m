//
//  WSDispatchQueue.m
//
//  Created by Ray Yamamoto on 30/05/11.
//  Copyright 2011 Wirestorm Pty Ltd. All rights reserved.
//

#import "WSDispatchQueue.h"

@interface WSDispatchQueue ()
- (id)initWithQueue:(dispatch_queue_t)queue_t;
@end

@implementation WSDispatchQueue

+ (WSDispatchQueue*)queueWithName:(NSString *)name
{
    return [[WSDispatchQueue alloc] initWithName:name];
}

+ (WSDispatchQueue*)withQueue:(dispatch_queue_t)queue
{
    return [[WSDispatchQueue alloc] initWithQueue:queue];
}

+ (WSDispatchQueue*)mainQueue {
    return [[WSDispatchQueue alloc] initWithQueue:dispatch_get_main_queue()];
}

+ (WSDispatchQueue*)currentQueue {
    return [[WSDispatchQueue alloc] initWithQueue:dispatch_get_current_queue()];    
}

+ (WSDispatchQueue*)globalQueue:(dispatch_queue_priority_t)priority  {
    return [[WSDispatchQueue alloc] initWithQueue:dispatch_get_global_queue(priority, 0)];    
}

+ (WSDispatchQueue*)defaultPriorityGlobalQueue  {
    return [self globalQueue:DISPATCH_QUEUE_PRIORITY_DEFAULT];
}

+ (WSDispatchQueue*)backgroundPriorityGlobalQueue  {
    return [self globalQueue:DISPATCH_QUEUE_PRIORITY_BACKGROUND];
}

+ (WSDispatchQueue*)highPriorityGlobalQueue  {
    return [self globalQueue:DISPATCH_QUEUE_PRIORITY_HIGH];
}

+ (WSDispatchQueue*)lowPriorityGlobalQueue  {
    return [self globalQueue:DISPATCH_QUEUE_PRIORITY_LOW];
}

- (void)dealloc {
    dispatch_release(queue_);
}

- (id)initWithName:(NSString*)queueName {
    return [self initWithQueue:dispatch_queue_create([queueName cStringUsingEncoding:NSStringEncodingConversionAllowLossy], NULL)];
}

- (id)initWithQueue:(dispatch_queue_t)queue_t {
    if((self = [super init])) {
        queue_ = queue_t;
    }
    return self;
}

- (void)async:(WSDispatchBlock)block 
{
    dispatch_async(queue_, block);
}

- (void)sync:(WSDispatchBlock)block
{
    dispatch_sync(queue_, block);
}


- (void)asyncBarrier:(WSDispatchBlock)block 
{
    dispatch_barrier_async(queue_, block);
}

- (void)syncBarrier:(WSDispatchBlock)block
{
    dispatch_barrier_sync(queue_, block);
}

- (void)after:(NSTimeInterval)timeInterval block:(WSDispatchBlock)block
{
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, timeInterval * NSEC_PER_SEC);
    dispatch_after(delay, queue_, block);
}

- (void)at:(NSDate *)date block:(WSDispatchBlock)block
{
    if([date timeIntervalSinceNow]>0)
        [self after:[date timeIntervalSinceNow] block:block];
}

- (void)suspend
{
    dispatch_suspend(queue_);
}

- (void)resume
{
    dispatch_resume(queue_);
}


- (void)apply:(unsigned long)size block:(WSEnumerationBlock)block
{
    dispatch_apply(size, queue_, block);
}
@end
