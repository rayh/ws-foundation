//
//  WSBenchmark.m
//  CommunityRadio
//
//  Created by Ray Hilton on 25/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "WSBenchmark.h"


@implementation WSBenchmark
@synthesize name=_name;
@synthesize startedAt=_startedAt;
@synthesize lastStepAt=_lastStepAt;
@synthesize finishedAt=_finishedAt;


+ (WSBenchmark*)benchmark:(NSString *)label
{
    WSBenchmark *bm = [[WSBenchmark alloc] init];
    bm.name = label;
    bm.startedAt = [NSDate date];
    bm.lastStepAt = bm.startedAt;
    return bm;
}

- (void)step:(NSString *)stepDescription
{
    NSDate *now = [NSDate date];
    NSLog(@"%@: %@ (at %0.3fs, took %0.3f", self.name, 
          stepDescription, 
          [now timeIntervalSinceDate:self.startedAt], 
          [now timeIntervalSinceDate:self.lastStepAt]);
                                                      
    self.lastStepAt = now;
}

- (void)finish
{
    [self step:@"Finished"];
    self.finishedAt = self.lastStepAt;
}

- (NSTimeInterval)timeTaken
{
    return [self.finishedAt timeIntervalSinceDate:self.startedAt];
}

+ (NSTimeInterval)name:(NSString*)label benchmark:(void(^)(WSBenchmark *benchmark))block;
{
    WSBenchmark *bm = [WSBenchmark benchmark:label];
    block(bm);
    [bm finish];
    return bm.timeTaken;
}
@end
