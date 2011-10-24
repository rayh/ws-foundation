//
//  NSArray+Concurrent.h
//  
//
//  Created by Ray Hilton on 24/10/11.
//  Copyright (c) 2011 Wirestorm Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Concurrent)
- (void)concurrentFilter:(BOOL(^)(id object))filter
                complete:(void(^)(NSSet *result))complete
                priority:(dispatch_queue_priority_t)priority;

- (void)concurrentMap:(id(^)(id object))mapBlock 
             complete:(void(^)(NSSet *result))complete
             priority:(dispatch_queue_priority_t)priority;

- (void)concurrentFilter:(BOOL(^)(id object))filter
                complete:(void(^)(NSSet *result))complete;

- (void)concurrentMap:(id(^)(id object))mapBlock 
             complete:(void(^)(NSSet *result))complete;

@end
