//
//  NSArray+Concurrent.h
//  
//
//  Created by Ray Hilton on 24/10/11.
//  Copyright (c) 2011 Wirestorm Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Concurrent)
- (NSArray*)concurrentFilter:(BOOL(^)(id object))block
                    priority:(dispatch_queue_priority_t)priority;

- (NSArray*)concurrentMap:(id(^)(id object))block 
                 priority:(dispatch_queue_priority_t)priority;

- (void)concurrentEach:(void(^)(id object))block
              priority:(dispatch_queue_priority_t)priority;

// Convenience methods to avoid specifying priority
- (void)concurrentEach:(void(^)(id object))block;
- (NSArray*)concurrentFilter:(BOOL(^)(id object))block;
- (NSArray*)concurrentMap:(id(^)(id object))block;


@end
