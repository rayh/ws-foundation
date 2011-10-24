//
//  WSBenchmark.h
//  CommunityRadio
//
//  Created by Ray Hilton on 25/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSBenchmark : NSObject

+ (NSTimeInterval)name:(NSString*)label benchmark:(void(^)(void))block;
@end
