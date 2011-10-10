//
//  NSObject+Creation.h
//
//  Created by Ray Hilton on 15/08/11.
//  Copyright 2011 Wirestorm Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (BlockCreate)
+ (id)createWithBlock:(void(^)(id instance))block;
+ (id)create;
@end
