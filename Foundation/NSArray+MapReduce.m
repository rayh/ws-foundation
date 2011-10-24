//
//  NSArray+MapReduce.m
//  
//
//  Created by Ray Hilton on 24/10/11.
//  Copyright (c) 2011 Wirestorm Pty Ltd. All rights reserved.
//

#import "NSArray+MapReduce.h"

@implementation NSArray (MapReduce)

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
               reduce:(id (^)(id current, id object))reduceBlock 
              initial:(id)initial
             complete:(void(^)(id result))complete
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
        
        // reduce, serial
        id result = initial;
        for(id object in results) {
            result = reduceBlock(result, object);
        }
            
        complete(result);
    });
}
@end
