//
//  NSURL+QueryString.m
//  
//
//  Created by Ray Hilton on 8/11/10.
//  Copyright 2010 Wirestorm Pty Ltd. All rights reserved.
//

#import "NSURL+QueryString.h"
#import "NSString+UrlEncoding.h"
#import "NSString+QueryString.h"

@implementation NSURL (QueryString)

- (NSURL*)URLByRemovingQueryStringParameters
{
    return [NSURL URLWithString:[[[self absoluteString] componentsSeparatedByString:@"?"] objectAtIndex:0]];
}

- (NSDictionary*)dictionaryOfQueryStringParameters
{
    NSArray *urlComponents = [[self absoluteString] componentsSeparatedByString:@"?"];
    if(urlComponents.count<2)
        return [NSDictionary dictionary];
        
    NSString *queryString = [urlComponents objectAtIndex:1];
    return [queryString dictionaryOfQueryStringParameters];
}

- (NSURL*)URLBySettingQueryStringParameters:(NSDictionary*)parameters
{
    NSURL *baseUrl = [self URLByRemovingQueryStringParameters];
    NSString *outputUrl = [[baseUrl absoluteString] stringByAppendingFormat:@"?%@",[NSString stringByEncodingDictionaryAsQueryString:parameters]];
    
    return [NSURL URLWithString:outputUrl];
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
