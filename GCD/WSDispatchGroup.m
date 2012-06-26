//
//  WSDispatchGroup.m
//
//  Created by Ray Hilton on 12/10/11.
//  Copyright (c) 2011 Wirestorm Pty Ltd. All rights reserved.
//

#import "WSDispatchGroup.h"

@interface WSDispatchQueue (WSDispatchGroup)
- (dispatch_queue_t)__ws_dispatch_queue_t;
@end

@implementation WSDispatchQueue (WSDispatchGroup)
- (dispatch_queue_t)__ws_dispatch_queue_t
{
    return queue_;
}
@end

@interface WSDispatchGroup ()
@property (nonatomic, assign) dispatch_group_t dispatchGroup;
@end

@implementation WSDispatchGroup
@synthesize dispatchGroup=dispatchGroup_;

- (void)dealloc
{
    dispatch_release(self.dispatchGroup);
}
- (id)init
{
    if(self = [super init]) {
        self.dispatchGroup = dispatch_group_create();
    }
    return self;
}

+ (WSDispatchGroup*)group 
{
    return [[WSDispatchGroup alloc] init];
}

- (void)async:(WSDispatchBlock)block queue:(WSDispatchQueue*)queue
{
    dispatch_group_async(self.dispatchGroup, [queue __ws_dispatch_queue_t], block);
}

- (void)waitForever 
{
    dispatch_group_wait(self.dispatchGroup, DISPATCH_TIME_FOREVER);
}

- (void)wait:(NSTimeInterval)timeInterval
{
    dispatch_group_wait(self.dispatchGroup, dispatch_time(DISPATCH_TIME_NOW, timeInterval * NSEC_PER_SEC));
}

@end
