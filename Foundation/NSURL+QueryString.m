//
//  NSURL+QueryString.m
//
//  Created by Ray Hilton on 13/02/12.
//  Copyright (c) 2012 Wirestorm Pty Ltd. All rights reserved.
//

#import "NSURL+QueryString.h"
#import "NSString+UrlEncoding.h"

@implementation NSURL (QueryString)

- (NSURL*)URLByRemovingQueryStringParameters
{
    return [NSURL URLWithString:[[[self absoluteString] componentsSeparatedByString:@"?"] objectAtIndex:0]];
}

- (NSDictionary*)dictionaryOfQueryStringParameters
{
    NSArray *urlComponents = [[self absoluteString] componentsSeparatedByString:@"?"];
    if(urlComponents.count<2)
        return @{};
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSString *queryString = [urlComponents objectAtIndex:1];
    
    for(NSString *keyValueString in [queryString componentsSeparatedByString:@"&"]) {
        NSArray *keyAndValue = [keyValueString componentsSeparatedByString:@"="];
        [parameters setValue:[[keyAndValue objectAtIndex:1] stringByUrlDecoding]
                      forKey:[keyAndValue objectAtIndex:0]];
    }
    
    return [NSDictionary dictionaryWithDictionary:parameters];
}

- (NSURL*)URLBySettingQueryStringParameters:(NSDictionary*)parameters
{
    NSURL *baseUrl = [self URLByRemovingQueryStringParameters];
    NSString *outputUrl = [[baseUrl absoluteString] stringByAppendingString:@"?"];
    
    NSMutableArray *keyValuePairs = [NSMutableArray array];
    for(NSString *key in [parameters allKeys]) {
        if([parameters valueForKey:key]!=[NSNull null] && [[parameters valueForKey:key] description].length>0)
            [keyValuePairs addObject:[NSString stringWithFormat:@"%@=%@", 
                                  key, 
                                  [[[parameters valueForKey:key] description] stringByUrlEncoding]]];
    }
    
    return [NSURL URLWithString:[outputUrl stringByAppendingString:[keyValuePairs componentsJoinedByString:@"&"]]];
}

- (NSURL*)URLByAppendingQueryStringParameters:(NSDictionary*)parameters
{
    NSURL *baseUrl = [self URLByRemovingQueryStringParameters];
    NSMutableDictionary *outputParams = [NSMutableDictionary dictionaryWithDictionary:[self dictionaryOfQueryStringParameters]];
    
    for(NSString *key in [parameters allKeys]) {
        [outputParams setValue:[parameters valueForKey:key] forKey:key];        
    }
    
    return [baseUrl URLBySettingQueryStringParameters:outputParams];
}

@end
