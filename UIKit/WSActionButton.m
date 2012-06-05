//
//  WSActionButton.m
//
//  Created by Ray Hilton on 31/05/12.
//  Copyright (c) 2012 Wirestorm Pty Ltd. All rights reserved.
//

#import "WSActionButton.h"
#import <QuartzCore/QuartzCore.h>
#import "UILabel+WSFoundation.h"
#import "WSLayoutView.h"

#define LEFT_ACCESSORY_TAG 12032323
#define RIGHT_ACCESSORY_TAG 12032324
#define INNER_PADDING 10.

@interface WSActionButton ()
{
    WSActionButtonStyle _style;
}
@property (nonatomic, retain) UIColor *tintColourActual;
@property (nonatomic, assign) UIEdgeInsets contentInsets;
@end

@implementation WSActionButton
@synthesize tintColourActual=_tintColourActual;
@synthesize titleLabel=_titleLabel;
@synthesize leftAccessoryView=_leftAccessoryView;
@synthesize rightAccessoryView=_rightAccessoryView;
@synthesize contentInsets=_contentInsets;
@synthesize autoresizeWitdh=_autoresizeWitdh;

- (void)dealloc
{
    self.tintColourActual = nil;
    self.titleLabel = nil;
    [super dealloc];
}

+ (WSActionButton*)buttonWithLabel:(NSString *)label style:(WSActionButtonStyle)style
{
    WSActionButton *button = [[[WSActionButton alloc] initWithFrame:CGRectMake(0, 0, 160, 44) style:style] autorelease];
    [button setTitle:label animated:NO];
    return button;
}


- (id)initWithFrame:(CGRect)frame style:(WSActionButtonStyle)style
{
    if(self = [self initWithFrame:frame])
    {
        [self setTintStyle:style];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeButton];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self initializeButton];
    }
    
    return self;
}

- (UILabel*)createButtonLabel:(CGRect)frame
{
    UILabel *label = [UILabel labelWithFrame:frame 
                       font:[UIFont boldSystemFontOfSize:16] 
                     colour:[UIColor colorWithWhite:1. alpha:0.8]
                       text:nil];
    label.userInteractionEnabled = NO;
    label.textAlignment = UITextAlignmentCenter;
    label.shadowColor = [UIColor colorWithWhite:0. alpha:0.4];
    label.shadowOffset = CGSizeMake(-1,-1);
    return label;
}

- (void)initializeButton
{
    self.autoresizeWitdh = YES;
    self.contentInsets = UIEdgeInsetsMake(0, 20, 0, 20);
    self.userInteractionEnabled = YES;
    self.accessibilityTraits = UIAccessibilityTraitButton;
    self.layer.borderColor = [UIColor colorWithWhite:0. alpha:0.2].CGColor;
    self.layer.borderWidth = 1.;
    self.layer.cornerRadius = 4.;
    self.layer.masksToBounds = YES;
        
    self.titleLabel = [self createButtonLabel:self.bounds];
    [self addSubview:self.titleLabel];
}

#pragma mark - accessories

- (UIView *)leftAccessoryView
{
    return [self viewWithTag:LEFT_ACCESSORY_TAG];
}

- (UIView *)rightAccessoryView
{
    return [self viewWithTag:RIGHT_ACCESSORY_TAG];
}

- (void)setLeftAccessoryView:(UIView *)leftAccessoryView
{
    if(!leftAccessoryView)
    {
        [[self leftAccessoryView] removeFromSuperview];
    }
    else
    {
        leftAccessoryView.tag = LEFT_ACCESSORY_TAG;
        [self insertSubview:leftAccessoryView atIndex:0];
    }
}   

- (void)setRightAccessoryView:(UIView *)rightAccessoryView
{
    if(!rightAccessoryView)
    {
        [[self rightAccessoryView] removeFromSuperview];
    }
    else
    {
        rightAccessoryView.tag = LEFT_ACCESSORY_TAG;
        [self insertSubview:rightAccessoryView atIndex:0];
    }
}

- (NSString*)leftAccessoryLabel
{
    if(![self.leftAccessoryView isKindOfClass:[UILabel class]])
    {
        return nil;
    }
         
    return [(UILabel*)self.leftAccessoryView text];
}

- (void)setLeftAccessoryLabel:(NSString *)leftAccessoryLabel
{
    if(![self.leftAccessoryView isKindOfClass:[UILabel class]])
    {
        UILabel *label = [self createButtonLabel:CGRectMake(0,0,0,self.bounds.size.height)];
        label.textAlignment = UITextAlignmentLeft;
        [self setLeftAccessoryView:label];
    }
    
    [(UILabel*)self.leftAccessoryView setTextAndAdjustWidth:leftAccessoryLabel];
}



- (NSString*)rightAccessoryLabel
{
    if(![self.rightAccessoryView isKindOfClass:[UILabel class]])
    {
        return nil;
    }
    
    return [(UILabel*)self.rightAccessoryView text];
}

- (void)setRightAccessoryLabel:(NSString *)rightAccessoryLabel
{
    if(![self.rightAccessoryView isKindOfClass:[UILabel class]])
    {
        UILabel *label = [self createButtonLabel:CGRectMake(0,0,0,self.bounds.size.height)];
        label.textAlignment = UITextAlignmentRight;
        [self setRightAccessoryView:label];
    }
    
    [(UILabel*)self.rightAccessoryView setTextAndAdjustWidth:rightAccessoryLabel];
}

#pragma mark - tinting

- (WSActionButtonStyle)tintStyle
{
    return _style;
}

- (void)setTintStyle:(WSActionButtonStyle)style
{
    _style = style;
    switch(style)
    {
        case WSActionButtonStyleDefault:
            [self setTintColour:[UIColor colourWithInt:0xCCCCCC]];
            return;
            
        case WSActionButtonStyleWarning:
            return [self setTintColour:[UIColor colourWithInt:0xFAA732]];
            
        case WSActionButtonStyleDanger:
            return [self setTintColour:[UIColor colourWithInt:0xBD362F]];
            
        case WSActionButtonStyleSuccess:
            return [self setTintColour:[UIColor colourWithInt:0x51A351]];
            
        case WSActionButtonStyleInfo:
            return [self setTintColour:[UIColor colourWithInt:0x2F96B4]];
            
        case WSActionButtonStylePrimary:
            return [self setTintColour:[UIColor colourWithInt:0x0074CC]];
            
    }
}

- (void)setTintColour:(UIColor*)colour
{
    self.tintColourActual = colour;
    [self updateTintColour];
}

- (UIColor *)tintColour
{
    return self.tintColourActual;
}

- (void)updateBackgroundWithGradientTint:(UIColor*)tint
{
    CAGradientLayer *gradient = (CAGradientLayer*)[self layer];
    //    gradient.frame = CGRectMake(0,0,320,44);
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[tint colourByAdjustingHue:0 saturation:0 brightness:0.1 alpha:0] CGColor], 
                       (id)[[tint colourByAdjustingHue:0 saturation:0 brightness:-0.1 alpha:0] CGColor], 
                       nil];
}

- (void)updateBackgroundWithFlatTint:(UIColor*)tint
{
    CAGradientLayer *gradient = (CAGradientLayer*)[self layer];
    //    gradient.frame = CGRectMake(0,0,320,44);
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[tint colourByAdjustingHue:0 saturation:0 brightness:0.1 alpha:0] CGColor], 
                       (id)[[tint colourByAdjustingHue:0 saturation:0 brightness:-0.1 alpha:0] CGColor], 
                       nil];
}

- (void)updateTintColour
{
    switch(_style)
    {
        case WSActionButtonStyleDefault:
            self.titleLabel.textColor = [UIColor colorWithWhite:0. alpha:0.6];
            self.titleLabel.shadowColor = [UIColor clearColor];
            break;
        default:
            self.titleLabel.textColor = [UIColor colorWithWhite:1. alpha:0.8];
            self.titleLabel.shadowColor = [UIColor colorWithWhite:0. alpha:0.3];
            break;
    }
    
            
    if(self.isHighlighted)
    {
        [self updateBackgroundWithGradientTint:[self.tintColourActual colourByAdjustingHue:0 saturation:-0.1 brightness:-0.1 alpha:0]];
    }
    else if(self.isSelected)
    {
        [self updateBackgroundWithGradientTint:[self.tintColourActual colourByAdjustingHue:0 saturation:0.2 brightness:0.3 alpha:0]];
    }
    else if(!self.isEnabled)
    {
        [self updateBackgroundWithFlatTint:[self.tintColourActual colourByAdjustingHue:0 saturation:-0.4 brightness:0.1 alpha:0]];
        self.titleLabel.shadowColor = [UIColor clearColor];
    }
    else {
        [self updateBackgroundWithGradientTint:self.tintColourActual];
    }
    
    [self setNeedsDisplay];
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    [self updateTintColour];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self updateTintColour];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self updateTintColour];
}

//- (void)handleTouchDown
//{
//    [self updateBackgroundWithGradientTint:[self.tintColourActual colourByAdjustingHue:0 saturation:-0.1 brightness:-0.1 alpha:0]];
//}
//
//- (void)handleTouchUp
//{
//    [self updateTintColour];
//}

+ (Class)layerClass {
    return [CAGradientLayer class];
}

#pragma mark - layout

- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.layoutView.frame = UIEdgeInsetsInsetRect(self.bounds, self.contentInsets);
    
//    [self.superview setNeedsLayout];
    CGRect titleFrame = UIEdgeInsetsInsetRect(self.bounds, self.contentInsets);
    
    if(self.leftAccessoryView)
    {
        // adjust title frame to be left offset
        titleFrame = CGRectMake(titleFrame.origin.x+self.leftAccessoryView.frame.size.width+INNER_PADDING,
                                titleFrame.origin.y,
                                titleFrame.size.width - self.leftAccessoryView.frame.size.width-INNER_PADDING, 
                                titleFrame.size.height);
        
        self.leftAccessoryView.frame = CGRectMake(self.contentInsets.left,
                                                  self.contentInsets.top,
                                                  self.leftAccessoryView.frame.size.width,
                                                  self.leftAccessoryView.frame.size.height);
    }
    
    if(self.rightAccessoryView)
    {
        // adjust title frame to be left offset
        titleFrame = CGRectMake(titleFrame.origin.x,
                                titleFrame.origin.y,
                                titleFrame.size.width - self.rightAccessoryView.frame.size.width-INNER_PADDING, 
                                titleFrame.size.height);
        
        self.rightAccessoryView.frame = CGRectMake(self.bounds.size.width-self.contentInsets.right-self.rightAccessoryView.frame.size.width,
                                                  self.contentInsets.top,
                                                  self.rightAccessoryView.frame.size.width,
                                                  self.rightAccessoryView.frame.size.height);
    }
    
    self.titleLabel.frame = titleFrame;
}

//- (void)updateTitleLabelAndResizeFrame:(NSString*)title
//{
//    [self.titleLabel setTextAndAdjustWidth:title];
//    self.frame = CGRectMake(self.frame.origin.x,
//                            self.frame.origin.y,
//                            self.layoutView.sizeOfContents.width + self.contentInsets.left + self.contentInsets.right,
//                            self.frame.size.height);
//    [self setNeedsLayout];
//}

- (void)setTitle:(NSString *)title animated:(BOOL)animated
{
    if(!self.autoresizeWitdh)
    {
        self.titleLabel.text = title;
        [self setNeedsLayout];
        return;
    }
    
    // Avoid animation if its the same
    if([self.titleLabel.text isEqualToString:title])
        animated = NO;

    
    CGSize size = [title sizeWithFont:self.titleLabel.font
                    constrainedToSize:CGSizeMake(INT32_MAX, self.frame.size.height)];
    
    CGFloat newWidth = size.width+self.contentInsets.left+self.contentInsets.right;
    
    if(self.leftAccessoryView)
        newWidth+=self.leftAccessoryView.frame.size.width+INNER_PADDING;
    
    if(self.rightAccessoryView)
        newWidth+=self.rightAccessoryView.frame.size.width+INNER_PADDING;
    
    CGRect newFrame = CGRectMake(self.frame.origin.x,
                                 self.frame.origin.y,
                                 newWidth,
                                 self.frame.size.height);    

    
    if(!animated)
    {
        self.frame = newFrame;
        self.titleLabel.text = title;
    }
    else 
    {
        [UIView animateWithDuration:animated ? 0.2 : 0
                         animations:^{
                             self.titleLabel.alpha = 0;
                         } completion:^(BOOL finished) {
                             self.titleLabel.text = title;
                             
                             [UIView animateWithDuration:animated ? 0.2 : 0
                                              animations:^{
                                                  self.frame = newFrame;
                                                  self.titleLabel.alpha = 1;
                                              }];
                         }];
    }
//    

}
@end
