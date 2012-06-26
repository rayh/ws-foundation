//
//  WSGradient.m
//  CommunityRadio
//
//  Created by Ray Hilton on 28/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "WSGradient.h"

@interface WSGradientColorLocation : NSObject
@property (nonatomic, retain) UIColor *color;
@property (nonatomic, assign) CGFloat location;
@end

@implementation WSGradientColorLocation
@synthesize color=color_;
@synthesize location=location_;

+ (WSGradientColorLocation*)color:(UIColor*)color location:(CGFloat)location
{
    WSGradientColorLocation *cl = [[WSGradientColorLocation alloc] init];
    cl.color = color;
    cl.location = location;
    return cl;
}
@end

@interface WSGradient ()
@property (nonatomic, retain) NSMutableArray *colorLocations;
@end

@implementation WSGradient
@synthesize colorLocations=colorLocations_;

+ (WSGradient*)gradient
{
    return [[WSGradient alloc] init];
}

- (id)init
{
    if(self = [super init]) {
        self.colorLocations = [NSMutableArray array];
    }
    return self;
}

- (void)addColor:(UIColor *)color atLocation:(CGFloat)location
{
    [self.colorLocations addObject:[WSGradientColorLocation color:color location:location]];
}

- (void)drawFrom:(CGPoint)start to:(CGPoint)end
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat *locations;
    CGFloat *components;
    
    locations = (CGFloat*)malloc(sizeof(CGFloat) * self.colorLocations.count);
    components = (CGFloat*)malloc(sizeof(CGFloat) * self.colorLocations.count * 4);
    
    for(int i = 0; i < self.colorLocations.count; i++) {
        WSGradientColorLocation *cl = [self.colorLocations objectAtIndex:i];
        locations[i] = cl.location;
        
        const CGFloat *c = CGColorGetComponents(cl.color.CGColor);  
        int numComponents = CGColorGetNumberOfComponents(cl.color.CGColor);
        
        if (numComponents == 4)
        {
            components[i*4 + 0] = c[0];
            components[i*4 + 1] = c[1];
            components[i*4 + 2] = c[2];
            components[i*4 + 3] = c[3];
        }
        else if(numComponents==2)
        {
            components[i*4 + 0] = c[0];
            components[i*4 + 1] = c[0];
            components[i*4 + 2] = c[0];
            components[i*4 + 3] = c[1];
        }
    }
    CGGradientRef myGradient = CGGradientCreateWithColorComponents(colourSpace, components, locations, self.colorLocations.count);
    CGContextDrawLinearGradient (context, myGradient, start, end, 0);
    
    CGColorSpaceRelease(colourSpace);
    CGGradientRelease(myGradient);
    free(locations);
    free(components);
}

@end
