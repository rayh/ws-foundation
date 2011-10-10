//
//  NSString+Comparison.m
//  CommunityRadio
//
//  Created by Ray Hilton on 24/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSString+Comparison.h"

@implementation NSString (NSString_Comparison)

- (BOOL)containsString:(NSString*)string
{
    return [[self lowercaseString] rangeOfString:[string lowercaseString]].location!=NSNotFound;
}
@end
