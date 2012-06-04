//
//  WSDispatchProtectedResource.h
//  
//
//  Created by Ray Hilton on 10/05/12.
//  Copyright (c) 2012 Wirestorm Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSDispatchSemaphore.h"

@interface WSDispatchMonitor : NSObject

+ (WSDispatchMonitor*)monitorWithSize:(NSInteger)size;

// Enter the monitor, the block MUST call signal on the sempahore once its work is complete
- (void)enter:(void(^)(WSDispatchSemaphore *semaphore))block;
@end
