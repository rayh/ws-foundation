//
//  NSSet+Concurrent.m
//  
//
//  Created by Ray Hilton on 24/10/11.
//  Copyright (c) 2011 Wirestorm Pty Ltd. All rights reserved.
//

#import "NSSet+Concurrent.h"

@implementation NSSet (Concurrent)

- (NSSet*)concurrentFilter:(BOOL(^)(id object))filter
                  priority:(dispatch_queue_priority_t)priority
{
    NSMutableSet *results = [NSMutableSet set];
    
    [self concurrentEach:^(id object) {
        if(filter(object))
            [results addObject:object];
    } priority:priority];
    
    return results;
}

- (void)concurrentEach:(void(^)(id object))eachBlock 
              priority:(dispatch_queue_priority_t)priority
{
    dispatch_queue_t queue = dispatch_get_global_queue(priority, 0);
    NSArray *input = [self allObjects];
    dispatch_apply(input.count, queue, ^(size_t index) {
        eachBlock([input objectAtIndex:index]);
    });        
}

- (NSSet *)concurrentMap:(id(^)(id object))mapBlock 
                priority:(dispatch_queue_priority_t)priority
{
    NSMutableSet *results = [NSMutableSet set];
    [self concurrentEach:^(id object) {        
        id result = mapBlock(object);
        [results addObject:result];
    } priority:priority];
    
    return results;
}

- (NSSet*)concurrentFilter:(BOOL(^)(id object))filter
{
    return [self concurrentFilter:filter priority:DISPATCH_QUEUE_PRIORITY_DEFAULT];
}

- (NSSet *)concurrentMap:(id(^)(id object))mapBlock 
{
    return [self concurrentMap:mapBlock priority:DISPATCH_QUEUE_PRIORITY_DEFAULT];
}

- (void)concurrentEach:(void(^)(id object))eachBlock 
{
    [self concurrentEach:eachBlock priority:DISPATCH_QUEUE_PRIORITY_DEFAULT];
}
@end
