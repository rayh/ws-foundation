//
//  UIColor+WSFoundation.m
//
//  Created by Ray Hilton on 5/06/12.
//  Copyright (c) 2012 Wirestorm Pty Ltd. All rights reserved.
//

#import "UIColor+WSFoundation.h"

@implementation UIColor (WSFoundation)
+ (UIColor*)colourWithInt:(NSInteger)rgbValue
{
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0 
                            blue:((float)(rgbValue & 0xFF))/255.0 
                           alpha:1.0];
}

- (UIColor*)colourByAdjustingHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness alpha:(CGFloat)alpha
{
    CGFloat originalHue, originalSaturation, originalBrightness, originalAlpha;
    [self getHue:&originalHue saturation:&originalSaturation brightness:&originalBrightness alpha:&originalAlpha];
    
    originalHue+=hue;
    originalSaturation+=saturation;
    originalBrightness+=brightness;
    originalAlpha+=alpha;
    
    return [UIColor colorWithHue:originalHue saturation:originalSaturation brightness:originalBrightness alpha:originalAlpha];
}
@end
