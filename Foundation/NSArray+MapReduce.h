//
//  NSArray+MapReduce.h
//  CommunityRadio
//
//  Created by Ray Hilton on 24/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (MapReduce)
- (void)concurrentFilter:(BOOL(^)(id object))filter
                complete:(void(^)(NSSet *result))complete
                priority:(dispatch_queue_priority_t)priority;

- (void)concurrentMap:(id(^)(id object))mapBlock 
               reduce:(id (^)(id current, id object))reduceBlock 
              initial:(id)initial
             complete:(void(^)(id result))complete
             priority:(dispatch_queue_priority_t)priority;
@end
