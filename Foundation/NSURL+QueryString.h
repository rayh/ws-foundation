//
//  NSURL+QueryString.h
//
//  Created by Ray Hilton on 13/02/12.
//  Copyright (c) 2012 Wirestorm Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (QueryString)
- (NSURL*)URLByRemovingQueryStringParameters;
- (NSDictionary*)dictionaryOfQueryStringParameters;
- (NSURL*)URLBySettingQueryStringParameters:(NSDictionary*)parameters;
- (NSURL*)URLByAppendingQueryStringParameters:(NSDictionary*)parameters;
@end
