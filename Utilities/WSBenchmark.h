//
//  WSBenchmark.h
//  CommunityRadio
//
//  Created by Ray Hilton on 25/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSBenchmark : NSObject
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSDate *startedAt;
@property (nonatomic, retain) NSDate *lastStepAt;
@property (nonatomic, retain) NSDate *finishedAt;
@property (nonatomic, readonly) NSTimeInterval timeTaken;
+ (WSBenchmark*)benchmark:(NSString *)label;
+ (NSTimeInterval)name:(NSString*)label benchmark:(void(^)(WSBenchmark *benchmark))block;
- (void)step:(NSString *)stepDescription;
- (void)finish;
@end
