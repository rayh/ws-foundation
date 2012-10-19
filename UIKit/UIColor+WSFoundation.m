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

- (CGFloat)contrast
{
    NSArray *rgb = [self rgbValues];
    CGFloat red = [[rgb objectAtIndex:0] floatValue] * 255;
    CGFloat green = [[rgb objectAtIndex:1] floatValue] * 255;
    CGFloat blue = [[rgb objectAtIndex:2] floatValue] * 255;
    CGFloat yiq = ((red*299)+(green*587)+(blue*114))/1000;
    return yiq/255.;
}

- (NSArray*)hsbValues
{
    CGFloat originalHue, originalSaturation, originalBrightness, originalAlpha;
    [self getHue:&originalHue saturation:&originalSaturation brightness:&originalBrightness alpha:&originalAlpha];
    return @[@(originalHue), @(originalSaturation), @(originalBrightness), @(originalAlpha)];
}

- (NSArray*)rgbValues
{
    CGFloat red,green,blue, alpha;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    return @[@(red), @(green), @(blue), @(alpha)];
}

- (CGFloat)hue
{
    return [[[self hsbValues] objectAtIndex:0] floatValue];
}

- (CGFloat)saturation
{
    return [[[self hsbValues] objectAtIndex:1] floatValue];
}

- (CGFloat)brightness
{
    return [[[self hsbValues] objectAtIndex:2] floatValue];
}

- (CGFloat)alpha
{
    return [[[self hsbValues] objectAtIndex:3] floatValue];
}

- (CGFloat)red
{
    return [[[self rgbValues] objectAtIndex:0] floatValue];
}

- (CGFloat)green
{
    return [[[self rgbValues] objectAtIndex:1] floatValue];
}

- (CGFloat)blue
{
    return [[[self rgbValues] objectAtIndex:2] floatValue];
}

- (UIColor*)colourByAdjustingHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness alpha:(CGFloat)alpha
{
    CGFloat originalHue, originalSaturation, originalBrightness, originalAlpha;
    [self getHue:&originalHue saturation:&originalSaturation brightness:&originalBrightness alpha:&originalAlpha];
    
    originalHue         =MIN(MAX(0, originalHue+hue), 1.);
    originalSaturation  =MIN(MAX(0, originalSaturation+saturation), 1.);
    originalBrightness  =MIN(MAX(0, originalBrightness+brightness), 1.);
    originalAlpha       =MIN(MAX(0, originalAlpha+alpha), 1.);
    
    return [UIColor colorWithHue:originalHue saturation:originalSaturation brightness:originalBrightness alpha:originalAlpha];
}
@end
