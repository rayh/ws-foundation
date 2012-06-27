//
//  NSString+UUID.m
//  Local
//
//  Created by Ray Hilton on 27/06/12.
//  Copyright (c) 2012 Wirestorm Pty Ltd. All rights reserved.
//

#import "NSString+UUID.h"

@implementation NSString (UUID)
// return a new autoreleased UUID string
+ (NSString *)stringByGeneratingUuid
{
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
        
    // release the UUID
    CFRelease(uuid);
    
    return uuidString;
}
@end
