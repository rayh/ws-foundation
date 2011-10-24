//
//  WSBenchmark.m
//  CommunityRadio
//
//  Created by Ray Hilton on 25/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "WSBenchmark.h"

@implementation WSBenchmark

+ (NSTimeInterval)name:(NSString*)label benchmark:(void(^)(void))block;
{
    NSDate *date = [NSDate date];
    block();
    NSTimeInterval time =  [[NSDate date] timeIntervalSinceDate:date];
    NSLog(@"%@ (took %0.3fs", label, time);
    return time;
}
@end
