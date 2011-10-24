//
//  WSDispatchGroup.h
//  CommunityRadio
//
//  Created by Ray Hilton on 12/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSDispatchQueue.h"

@interface WSDispatchGroup : NSObject

+ (WSDispatchGroup*)group;
- (void)async:(WSDispatchBlock)block queue:(WSDispatchQueue*)queue;
- (void)waitForever;
- (void)wait:(NSTimeInterval)timeInterval;

@end
