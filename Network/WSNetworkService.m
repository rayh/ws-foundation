//
//  WSNetworkService.m
//  Local
//
//  Created by Ray Hilton on 26/06/12.
//  Copyright (c) 2012 Wirestorm Pty Ltd. All rights reserved.
//

#import "WSNetworkService.h"
#import "NSURL+QueryString.h"

@implementation WSNetworkService
@synthesize globalRequestModifier=_globalRequestModifier;
@synthesize globalResponseModifier=_globalResponseModifier;

+ (WSNetworkService*)sharedService
{
    static WSNetworkService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[WSNetworkService alloc] init];
    });
    return service;
}

- (NSError*)encodeParameters:(NSDictionary*)parameters 
                    encoding:(WSNetworkServiceParametersEncoding)encoding
                     request:(NSMutableURLRequest*)request;
{
    NSError *error = nil;
    
    switch (encoding) {
        case WSNetworkServiceParametersEncodingIgnore:
            break;
            
        case WSNetworkServiceParametersEncodingJson:
        {
            @try {
                NSData *postdata = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
                if(error)
                    return error;
                
                [request setHTTPBody:postdata];

            }
            @catch (NSException *exception) {
                NSLog(@"Json Encoding failued: %@", exception);
                return [NSError errorWithDomain:@"WSNetworkJsonEncodeException" code:-1 
                                       userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 exception,@"exception",
                                                 exception.name, NSLocalizedDescriptionKey,
                                                 exception.reason, NSLocalizedFailureReasonErrorKey,
                                                 nil]];
            }
            break;
        }
            
        case WSNetworkServiceParametersEncodingQueryString:
        {
            request.URL = [request.URL URLByAppendingQueryStringParameters:parameters];
            break;
        }
            
        default:
            break;
    }
    
    return nil;
}


- (void)perform:(NSString *)method 
            url:(NSURL *)url
         modify:(WSNetworkRequestModifierBlock)requestModifier
        success:(WSNetworkSuccessBlock)success
        failure:(WSNetworkFailureBlock)failure
{
    [self perform:method url:url parameters:nil encoding:WSNetworkServiceParametersEncodingIgnore
           modify:requestModifier success:success failure:failure];
}

- (void)perform:(NSString *)method 
            url:(NSURL *)url
     parameters:(NSDictionary*)parameters
       encoding:(WSNetworkServiceParametersEncoding)encoding
         modify:(WSNetworkRequestModifierBlock)requestModifier
        success:(WSNetworkSuccessBlock)success
        failure:(WSNetworkFailureBlock)failure
{
    if(!url)
    {
        NSLog(@"[WSNetworkService] url is nil!");
        
        if(failure)
            failure([NSError errorWithDomain:@"WSNetworkServiceHttpErrorDomain" 
                                        code:0
                                    userInfo:[NSDictionary 
                                              dictionaryWithObject:@"The supplied url is nil" 
                                              forKey:NSLocalizedDescriptionKey]]);
        
        return;
    }
    
    NSDate *beginTime = [NSDate date];
    
    
    WSNetworkFailureBlock errorBlock = ^(NSError *error) 
    {
        NSLog(@"[WSNetworkService] %@ %@ %d 0b %0.2fs : %@", 
              method,
              url, 
              error.code,
              [[NSDate date] timeIntervalSinceDate:beginTime],
              [error localizedDescription]);
        
        if(failure)
            failure(error);
    };
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url 
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:30.];
    [request setHTTPMethod:method];
    
    
    // Query params
    NSError *encodingError = [self encodeParameters:parameters encoding:encoding request:request];
    
    if(encodingError)
    {
        errorBlock(encodingError);
        return;
    }
    
    // Request Modification
    if(self.globalRequestModifier)
        self.globalRequestModifier(request);
    
    if(requestModifier)
        requestModifier(request);
    
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                               
                               if(error)
                               {
                                   errorBlock(error);
                                   return;
                               }
                               
                               if(httpResponse.statusCode>=300)
                               {
                                   errorBlock([NSError errorWithDomain:@"WSNetworkServiceHttpErrorDomain" 
                                                                  code:httpResponse.statusCode
                                                              userInfo:[NSDictionary 
                                                                        dictionaryWithObject:[NSHTTPURLResponse
                                                                                              localizedStringForStatusCode:httpResponse.statusCode] 
                                                                        forKey:NSLocalizedDescriptionKey]]);
                                   return;
                               }
                               
                               
                               // Parsing
                               id object = data;
                               if(httpResponse.statusCode!=204 && data.length>0)
                               {
                                   NSError *parseError = nil;
                                   
                                   if(self.globalResponseModifier)
                                       object = self.globalResponseModifier(httpResponse, object, &parseError);
                                   
                                   if(parseError)
                                   {
                                       errorBlock(parseError);
                                       return;
                                   }                                   
                               }
                               
                               NSLog(@"[WSNetworkService] %@ %@ %d %db %0.2fs %@", 
                                     method,
                                     url, 
                                     httpResponse.statusCode,
                                     [data length],
                                     [[NSDate date] timeIntervalSinceDate:beginTime],
                                     [httpResponse allHeaderFields]);
                               
                               success(httpResponse, object);
                           }];
}

@end
