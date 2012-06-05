//
//  UIColor+WSFoundation.h
//
//  Created by Ray Hilton on 5/06/12.
//  Copyright (c) 2012 Wirestorm Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (WSFoundation)
+ (UIColor*)colourWithInt:(NSInteger)intValue;
- (UIColor*)colourByAdjustingHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness alpha:(CGFloat)alpha;

@end
