//
//  WSNetworkService.h
//  Local
//
//  Created by Ray Hilton on 26/06/12.
//  Copyright (c) 2012 Wirestorm Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    WSNetworkServiceParametersEncodingIgnore,
    WSNetworkServiceParametersEncodingJson,
    WSNetworkServiceParametersEncodingQueryString
} WSNetworkServiceParametersEncoding;

typedef void (^WSNetworkRequestModifierBlock) (NSMutableURLRequest *request);
typedef id (^WSNetworkResponseModifierBlock) (NSHTTPURLResponse *response, id object, NSError **error);
typedef void (^WSNetworkSuccessBlock) (NSHTTPURLResponse *response, id object);
typedef void (^WSNetworkFailureBlock) (NSError *error);


@interface WSNetworkService : NSObject
@property (nonatomic, copy) WSNetworkRequestModifierBlock globalRequestModifier;
@property (nonatomic, copy) WSNetworkResponseModifierBlock globalResponseModifier;

+ (WSNetworkService*)sharedService;

- (void)perform:(NSString*)method
            url:(NSURL*)url 
         modify:(WSNetworkRequestModifierBlock)requestModifier 
        success:(WSNetworkSuccessBlock)success
        failure:(WSNetworkFailureBlock)failure;


- (void)perform:(NSString *)method 
            url:(NSURL *)url
     parameters:(NSDictionary*)parameters
       encoding:(WSNetworkServiceParametersEncoding)encoding
         modify:(WSNetworkRequestModifierBlock)requestModifier
        success:(WSNetworkSuccessBlock)success
        failure:(WSNetworkFailureBlock)failure;

@end
