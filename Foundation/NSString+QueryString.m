//
//  NSString+QueryString.m
//  Local
//
//  Created by Ray Hilton on 11/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+QueryString.h"
#import "NSString+UrlEncoding.h"

@implementation NSString (QueryString)

+ (NSString*)stringByEncodingDictionaryAsQueryString:(NSDictionary*)parameters
{
    NSMutableArray *keyValuePairs = [NSMutableArray array];
    for(NSString *key in [parameters allKeys]) {
        if([parameters valueForKey:key]!=[NSNull null] && [[parameters valueForKey:key] description].length>0)
            [keyValuePairs addObject:[NSString stringWithFormat:@"%@=%@", 
                                      key, 
                                      [[[parameters valueForKey:key] description] stringByUrlEncoding]]];
    }
    
    return [keyValuePairs componentsJoinedByString:@"&"];
}

- (NSDictionary*)dictionaryOfQueryStringParameters
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    for(NSString *keyValueString in [self componentsSeparatedByString:@"&"]) {
        NSArray *keyAndValue = [keyValueString componentsSeparatedByString:@"="];
        [parameters setValue:[[keyAndValue objectAtIndex:1] stringByUrlDecoding]
                      forKey:[keyAndValue objectAtIndex:0]];
    }
    
    return [NSDictionary dictionaryWithDictionary:parameters];
}
@end
