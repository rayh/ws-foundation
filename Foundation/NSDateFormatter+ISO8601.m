//
//  NSDateFormatter+ISO8601.m
//  Local
//
//  Created by Ray Hilton on 17/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDateFormatter+ISO8601.h"

@implementation NSDateFormatter (ISO8601)

+ (NSDateFormatter*) iso8601DateFormatter 
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];       
    
    return formatter;
}

@end
