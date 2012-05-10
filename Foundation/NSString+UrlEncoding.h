//
//  NSString+UrlEncoding.h
//  
//
//  Created by Ray Hilton on 8/11/10.
//  Copyright 2010 Wirestorm Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (UrlEncoding)

-(NSString *)stringByUrlDecoding;
-(NSString *)stringByUrlEncoding;

@end
