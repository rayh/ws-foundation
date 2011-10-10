//
//  NSObject+Creation.h
//  CommunityRadio
//
//  Created by Ray Hilton on 15/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (BlockCreate)
+ (id)createWithBlock:(void(^)(id instance))block;
+ (id)create;
@end
