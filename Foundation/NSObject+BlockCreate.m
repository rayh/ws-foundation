//
//  NSObject+Creation.m
//
//  Created by Ray Hilton on 15/08/11.
//  Copyright 2011 Wirestorm Pty Ltd. All rights reserved.
//

#import "NSObject+BlockCreate.h"

@implementation NSObject (BlockCreate)

+ (id)createWithBlock:(void(^)(id instance))block
{
    id instance = [[[self class] alloc] init];
    if(block)
        block(instance);
    
    return instance;
}

+ (id)create
{
    return [self createWithBlock:nil];
}

@end
