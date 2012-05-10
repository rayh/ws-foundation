//
//  NSString+UrlEncoding.m
//  
//
//  Created by Ray Hilton on 8/11/10.
//  Copyright 2010 Wirestorm Pty Ltd. All rights reserved.
//

#import "NSString+UrlEncoding.h"


@implementation NSString (UrlEncoding)

- (NSString *)stringByUrlDecoding
{
    NSString *result = [(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

-(NSString*)stringByUrlEncoding {	
	return [(NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[[self mutableCopy] autorelease], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"),kCFStringEncodingUTF8) autorelease];
}
	
@end
