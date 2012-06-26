//
//  WSNetworkService.h
//  Local
//
//  Created by Ray Hilton on 26/06/12.
//  Copyright (c) 2012 Wirestorm Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WSNetworkRequestModifierBlock) (NSMutableURLRequest *request);
typedef id (^WSNetworkResponseModifierBlock) (NSHTTPURLResponse *response, id object, NSError **error);
typedef void (^WSNetworkSuccessBlock) (NSHTTPURLResponse *response, id object);
typedef void (^WSNetworkFailureBlock) (NSError *error);

@interface WSNetworkService : NSObject
@property (nonatomic, copy) WSNetworkRequestModifierBlock globalRequestModifier;
@property (nonatomic, copy) WSNetworkResponseModifierBlock globalResponseModifier;

- (void)fetchUrl:(NSURL*)url 
          method:(NSString*)method
          modify:(WSNetworkRequestModifierBlock)requestModifier 
         success:(WSNetworkSuccessBlock)success
         failure:(WSNetworkFailureBlock)failure;
@end
