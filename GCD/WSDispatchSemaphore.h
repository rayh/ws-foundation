//
//  WSDispatchSemaphore.h
//  CommunityRadio
//
//  Created by Ray Hilton on 24/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSDispatchSemaphore : NSObject
+ (WSDispatchSemaphore*)semaphoreWithPoolSize:(NSInteger)size;
- (void)wait:(NSTimeInterval)timeInterval;
- (void)waitForever;
- (void)signal;
@end
