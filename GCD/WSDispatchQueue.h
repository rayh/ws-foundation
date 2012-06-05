//
//  WSDispatchQueue.h
//
//  Created by Ray Yamamoto on 30/05/11.
//  Copyright 2011 Wirestorm Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WSDispatchBlock)(void);
typedef void (^WSEnumerationBlock)(unsigned long index);

@interface WSDispatchQueue : NSObject {
    dispatch_queue_t queue_;    
}

- (id)initWithName:(NSString*)queueName;
- (void)async:(WSDispatchBlock)block;
- (void)sync:(WSDispatchBlock)block;
- (void)asyncBarrier:(WSDispatchBlock)block;
- (void)syncBarrier:(WSDispatchBlock)block;
- (void)at:(NSDate*)date block:(WSDispatchBlock)block;
- (void)after:(NSTimeInterval)timeInterval block:(WSDispatchBlock)block;
- (void)suspend;
- (void)resume;

// Executes a block a given number of times with particular indices.  Will block until all blocks return. 
// Useful for concurrently enumerating arrays
- (void)apply:(unsigned long)size block:(WSEnumerationBlock)block;


+ (WSDispatchQueue*)withQueue:(dispatch_queue_t)queue;
+ (WSDispatchQueue*)mainQueue;
+ (WSDispatchQueue*)currentQueue;
+ (WSDispatchQueue*)queueWithName:(NSString *)name;
+ (WSDispatchQueue*)defaultPriorityGlobalQueue;
+ (WSDispatchQueue*)backgroundPriorityGlobalQueue;
+ (WSDispatchQueue*)highPriorityGlobalQueue;
+ (WSDispatchQueue*)lowPriorityGlobalQueue;
@end

//@interface DispatchSemaphore : NSObject
//- (id)init;
//- (id)initWithCount:(long)count;
//- (long)signal;
//- (long)waitWithTimeout:(NSTimeInterval)timeout;
//- (long)waitForever;
//@end