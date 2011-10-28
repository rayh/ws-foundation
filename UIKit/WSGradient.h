//
//  WSGradient.h
//  CommunityRadio
//
//  Created by Ray Hilton on 28/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSGradient : NSObject
+ (WSGradient*)gradient;
- (void)addColor:(UIColor*)color atLocation:(CGFloat)location;
- (void)drawFrom:(CGPoint)start to:(CGPoint)end;
@end
