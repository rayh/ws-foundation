//
//  NSArray+Concurrent.m
//  
//
//  Created by Ray Hilton on 24/10/11.
//  Copyright (c) 2011 Wirestorm Pty Ltd. All rights reserved.
//

#import "NSArray+Concurrent.h"

@implementation NSArray (Concurrent)

- (void)concurrentFilter:(BOOL(^)(id object))filter
                complete:(void(^)(NSSet *result))complete
                priority:(dispatch_queue_priority_t)priority
{
    dispatch_queue_t queue = dispatch_get_global_queue(priority, 0);
    dispatch_async(queue, ^{
        NSMutableSet *results = [NSMutableSet set];
        dispatch_apply(self.count, queue, ^(size_t index) {
            id obj = [self objectAtIndex:index];
            if(filter(obj))
                [results addObject:obj];
        });
        
        complete(results);
    });
}

- (void)concurrentMap:(id(^)(id object))mapBlock 
             complete:(void(^)(NSSet *results))complete
             priority:(dispatch_queue_priority_t)priority
{
    dispatch_queue_t queue = dispatch_get_global_queue(priority, 0);
    dispatch_async(queue, ^{
        NSMutableSet *results = [NSMutableSet set];
        
        // map, concurrent blocks until complete
        dispatch_apply(self.count, queue, ^(size_t index) {
            id result = mapBlock([self objectAtIndex:index]);
            [results addObject:result];
        });
        
        complete(results);
    });
}

- (void)concurrentFilter:(BOOL(^)(id object))filter
                complete:(void(^)(NSSet *result))complete
{
    [self concurrentFilter:filter complete:complete priority:DISPATCH_QUEUE_PRIORITY_DEFAULT];
}

- (void)concurrentMap:(id(^)(id object))mapBlock 
             complete:(void(^)(NSSet *result))complete
{
    [self concurrentMap:mapBlock complete:complete priority:DISPATCH_QUEUE_PRIORITY_DEFAULT];
}
@end
