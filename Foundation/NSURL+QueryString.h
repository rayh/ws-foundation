//
//  NSURL+QueryString.h
//  
//
//  Created by Ray Hilton on 8/11/10.
//  Copyright 2010 Wirestorm Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (QueryString)
- (NSURL*)URLByRemovingQueryStringParameters;
- (NSDictionary*)dictionaryOfQueryStringParameters;
- (NSURL*)URLBySettingQueryStringParameters:(NSDictionary*)parameters;
- (NSURL*)URLByAppendingQueryStringParameters:(NSDictionary*)parameters;
@end
