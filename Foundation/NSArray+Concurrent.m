//
//  NSArray+Concurrent.m
//  
//
//  Created by Ray Hilton on 24/10/11.
//  Copyright (c) 2011 Wirestorm Pty Ltd. All rights reserved.
//

#import "NSArray+Concurrent.h"

@implementation NSArray (Concurrent)

- (NSArray*)concurrentFilter:(BOOL(^)(id object))filter
                    priority:(dispatch_queue_priority_t)priority
{
    NSMutableArray *results = [NSMutableArray array];
    
    [self concurrentEach:^(id object) {
        if(filter(object))
            [results addObject:object];
    } priority:priority];
    
    return results;
}

- (void)concurrentEach:(void(^)(id object))eachBlock 
                stride:(NSUInteger)stride
              priority:(dispatch_queue_priority_t)priority
{
    dispatch_queue_t queue = dispatch_get_global_queue(priority, 0);
    dispatch_apply(ceil(self.count / stride), queue, ^(size_t idx){
        size_t current_index = idx * stride;
        size_t segment_stop_index = current_index + stride;
        
        if(segment_stop_index >= self.count)
            segment_stop_index = self.count-1;
        
        do {
            eachBlock([self objectAtIndex:current_index++]);
        } while (current_index < segment_stop_index);
    });
}

- (void)concurrentEach:(void(^)(id object))eachBlock 
              priority:(dispatch_queue_priority_t)priority
{
    dispatch_queue_t queue = dispatch_get_global_queue(priority, 0);
    dispatch_apply(self.count, queue, ^(size_t index) {
        eachBlock([self objectAtIndex:index]);
    });        
}

- (NSArray *)concurrentMap:(id(^)(id object))mapBlock 
                  priority:(dispatch_queue_priority_t)priority
{
    NSMutableArray *results = [NSMutableArray array];
    [self concurrentEach:^(id object) {        
        id result = mapBlock(object);
        [[result retain] autorelease];
        [results addObject:result];
    } priority:priority];
    
    return results;
}

- (NSArray*)concurrentFilter:(BOOL(^)(id object))filter
{
    return [self concurrentFilter:filter priority:DISPATCH_QUEUE_PRIORITY_DEFAULT];
}

- (NSArray*)concurrentMap:(id(^)(id object))mapBlock 
{
    return [self concurrentMap:mapBlock priority:DISPATCH_QUEUE_PRIORITY_DEFAULT];
}

- (void)concurrentEach:(void(^)(id object))eachBlock stride:(NSUInteger)stride
{
    [self concurrentEach:eachBlock stride:stride priority:DISPATCH_QUEUE_PRIORITY_DEFAULT];
}

- (void)concurrentEach:(void(^)(id object))eachBlock 
{
    [self concurrentEach:eachBlock priority:DISPATCH_QUEUE_PRIORITY_DEFAULT];
}
@end
