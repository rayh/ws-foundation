//
//  NSString+QueryString.h
//  Local
//
//  Created by Ray Hilton on 11/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QueryString)
+ (NSString*)stringByEncodingDictionaryAsQueryString:(NSDictionary*)parameters;
- (NSDictionary*)dictionaryOfQueryStringParameters;
@end
