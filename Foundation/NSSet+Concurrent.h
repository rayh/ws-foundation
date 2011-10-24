//
//  NSSet+Concurrent.h
//  
//
//  Created by Ray Hilton on 24/10/11.
//  Copyright (c) 2011 Wirestorm Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSet (Concurrent)
- (NSSet*)concurrentFilter:(BOOL(^)(id object))block
                  priority:(dispatch_queue_priority_t)priority;

- (NSSet*)concurrentMap:(id(^)(id object))block 
               priority:(dispatch_queue_priority_t)priority;

- (void)concurrentEach:(void(^)(id object))block
              priority:(dispatch_queue_priority_t)priority;

// Convenience methods to avoid specifying priority
- (void)concurrentEach:(void(^)(id object))block;
- (NSSet*)concurrentFilter:(BOOL(^)(id object))block;
- (NSSet*)concurrentMap:(id(^)(id object))block;

@end
