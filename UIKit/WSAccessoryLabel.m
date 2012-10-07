//
//  WSAccessoryLabel.m
//  Local
//
//  Created by Ray Hilton on 30/09/12.
//
//

#import "WSAccessoryLabel.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+WSFoundation.h"

#define TEXT_INSET_Y 2
#define TEXT_INSET_X 5

@interface WSAccessoryLabel ()
@property (nonatomic, strong) UILabel *badgeLabel;
@end


@implementation WSAccessoryLabel

+ (WSAccessoryLabel*)accessoryLabel:(NSString*)label colour:(UIColor*)colour;
{
    if(!label || label.length==0)
        return nil;
    
    WSAccessoryLabel *badge = [[WSAccessoryLabel alloc] initWithFrame:CGRectZero];
    [badge setText:label];
    [badge setColour:colour];
    return badge;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isAccessibilityElement = YES;
        self.layer.cornerRadius = 3;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.4].CGColor;
        
        
        self.badgeLabel = [[UILabel alloc] initWithFrame:frame];
        self.badgeLabel.backgroundColor = [UIColor clearColor];
        //        self.badgeLabel.layer.cornerRadius = 3;
        //        self.badgeLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        //        self.badgeLabel.layer.borderWidth = 2;
        self.badgeLabel.textAlignment = UITextAlignmentCenter;
        self.badgeLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.badgeLabel.shadowOffset = CGSizeMake(-1, -1);
        self.badgeLabel.textColor = [UIColor whiteColor];
        self.badgeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10];
        [self addSubview:self.badgeLabel];
    }
    return self;
}

- (void)setText:(NSString*)text
{
    self.badgeLabel.text = text;
    [self sizeToFit];
}

- (void)setColour:(UIColor *)colour
{
    //    self.badgeLabel.textColor = colour;
    //    self.layer.borderColor = colour.CGColor;
    CAGradientLayer *gradientLayer = (CAGradientLayer*)[self layer];
    gradientLayer.colors = @[
    (id)[colour colourByAdjustingHue:0 saturation:0 brightness:0.2 alpha:0].CGColor,
    (id)[colour colourByAdjustingHue:0 saturation:0 brightness:-0.2 alpha:0].CGColor];
    //    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    self.badgeLabel.frame = CGRectInset(self.bounds, TEXT_INSET_X, TEXT_INSET_Y);
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize fitSize = [self.badgeLabel sizeThatFits:CGSizeMake(size.width-TEXT_INSET_X*2, size.height-TEXT_INSET_Y*2)];
    return CGSizeMake(fitSize.width+TEXT_INSET_X*2, fitSize.height+TEXT_INSET_Y*2);
}

+ (Class)layerClass
{
    return [CAGradientLayer class];
}


@end
