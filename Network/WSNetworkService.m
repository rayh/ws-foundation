//
//  WSNetworkService.m
//  Local
//
//  Created by Ray Hilton on 26/06/12.
//  Copyright (c) 2012 Wirestorm Pty Ltd. All rights reserved.
//

#import "WSNetworkService.h"


@implementation WSNetworkService
@synthesize globalRequestModifier=_globalRequestModifier;
@synthesize globalResponseModifier=_globalResponseModifier;

- (void)dealloc
{
    self.globalRequestModifier = nil;
    self.globalResponseModifier = nil;
    [super dealloc];
}

- (void)fetchUrl:(NSURL*)url 
          method:(NSString*)method
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
    
    if(self.globalRequestModifier)
        self.globalRequestModifier(request);
    
    if(requestModifier)
        requestModifier(request);
    
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                               
                               if(httpResponse.statusCode>=300)
                                   errorBlock([NSError errorWithDomain:@"VHNetworkServiceHttpErrorDomain" 
                                                                  code:httpResponse.statusCode
                                                              userInfo:[NSDictionary 
                                                                        dictionaryWithObject:[NSHTTPURLResponse
                                                                                              localizedStringForStatusCode:httpResponse.statusCode] 
                                                                        forKey:NSLocalizedDescriptionKey]]);
                               else if(!error) 
                               {
                                   NSLog(@"[VHNetworkService] %@ %@ %d %db %0.2fs %@", 
                                         method,
                                         url, 
                                         httpResponse.statusCode,
                                         [data length],
                                         [[NSDate date] timeIntervalSinceDate:beginTime],
                                         [httpResponse allHeaderFields]);
                                   
                                   NSError *parseError = nil;
                                   id object = data;
                                   
                                   if(self.globalResponseModifier)
                                       object = self.globalResponseModifier(httpResponse, object, &parseError);
                                   
                                   if(parseError)
                                   {
                                       errorBlock(parseError);
                                       return;
                                   }
                                   
//                                   if(responseModifier)
//                                       object = responseModifier(object); 
                                   
                                   success(httpResponse, object);
                               }
                               else
                               {
                                   errorBlock(error);
                               }
                           }];
}
@end
