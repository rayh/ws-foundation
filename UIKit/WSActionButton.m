#import "WSActionButton.h"
#import <QuartzCore/QuartzCore.h>
#import "UILabel+WSFoundation.h"
#import "WSLayoutView.h"
#import "UIColor+WSFoundation.h"

#define LEFT_ACCESSORY_TAG 12032323
#define RIGHT_ACCESSORY_TAG 12032324
#define INNER_PADDING 10.

#define LABEL_BRIGHT_COLOUR [UIColor colorWithWhite:1. alpha:0.90]
#define LABEL_DARK_COLOUR [UIColor colorWithWhite:0. alpha:0.6]


@interface WSActionButtonBackgroundView : UIView
@end

@interface WSActionButton ()
{
    WSActionButtonText _textStyle;
}
@property (nonatomic, strong) WSActionButtonBackgroundView *backgroundView;
@property (nonatomic, strong) UIColor *tintColourActual;
@property (nonatomic, strong) UIColor *selectedColourActual;
@end

@implementation WSActionButtonBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = NO;
        self.layer.borderColor = [UIColor colorWithWhite:0. alpha:0.5].CGColor;
        self.layer.borderWidth = 1.;
        self.layer.cornerRadius = 4.;
        self.layer.masksToBounds = YES;
        self.layer.rasterizationScale = 2.;
        self.layer.shouldRasterize = YES;

    }
    return self;
}

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (CAGradientLayer*)gradientLayer
{
    return (CAGradientLayer*)[self layer];
}

- (void)updateBackgroundWithGradientTint:(UIColor*)tint from:(CGFloat)from to:(CGFloat)to
{
    //    gradient.frame = CGRectMake(0,0,320,44);
    [self gradientLayer].colors = [NSArray arrayWithObjects:
                       (id)[[tint colourByAdjustingHue:0 saturation:0 brightness:from alpha:0] CGColor],
                       (id)[[tint colourByAdjustingHue:0 saturation:0 brightness:to alpha:0] CGColor],
                       nil];
}
- (UIColor*)backgroundColor
{
    return [UIColor colorWithCGColor:(CGColorRef)[self gradientLayer].colors[0]];
}
@end

@implementation WSActionButton

+ (UIColor*)colourForTintStyle:(WSActionButtonStyle)style
{
    switch(style)
    {
        case WSActionButtonStyleDefault:
            return [UIColor colourWithInt:0xCCCCCC];
            
        case WSActionButtonStyleWarning:
            return [UIColor colourWithInt:0xFAA732];
            
        case WSActionButtonStyleDanger:
            return [UIColor redColor];
            
        case WSActionButtonStyleSuccess:
            return [UIColor colourWithInt:0x51A351];
            
        case WSActionButtonStyleInfo:
            return [UIColor colourWithInt:0x2F96B4];
            
        case WSActionButtonStylePrimary:
            return [UIColor colourWithInt:0x0074CC];
            
        default:
            return nil;
    }
}

+ (WSActionButtonText)textStyleForTintStyle:(WSActionButtonStyle)style
{
    switch(style)
    {
        case WSActionButtonStyleDefault:
        case WSActionButtonStyleCustom:
            return WSActionButtonTextDark;
            
        default:
            return WSActionButtonTextLight;
    }
}

+ (WSActionButton*)buttonWithLabel:(NSString *)label colour:(UIColor*)colour textStyle:(WSActionButtonText)textStyle
{
    WSActionButton *button = [[WSActionButton alloc] initWithFrame:CGRectMake(0, 0, 160, 44) tintColour:colour textStyle:textStyle];
    [button setTitle:label animated:NO];
    return button;
}

+ (WSActionButton*)buttonWithLabel:(NSString *)label style:(WSActionButtonStyle)style
{
    return [self buttonWithLabel:label colour:[self colourForTintStyle:style] textStyle:[self textStyleForTintStyle:style]];
}


- (id)initWithFrame:(CGRect)frame tintColour:(UIColor*)colour textStyle:(WSActionButtonText)textStyle
{
    if(self = [self initWithFrame:frame])
    {
        [self setTextStyle:textStyle];
        [self setTintColour:colour];
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
                     colour:LABEL_BRIGHT_COLOUR
                       text:nil];
    
    switch(_textStyle)
    {
        case WSActionButtonTextDark:
            label.textColor = LABEL_DARK_COLOUR;
            label.shadowColor = [UIColor colorWithWhite:1. alpha:0.4];
            label.shadowOffset = CGSizeMake(0,1);
            break;
        default:
            label.textColor = LABEL_BRIGHT_COLOUR;
            label.shadowColor = [UIColor colorWithWhite:0. alpha:0.4];
            label.shadowOffset = CGSizeMake(0,-1);
            break;
    }
    
    label.userInteractionEnabled = NO;
    label.textAlignment = UITextAlignmentCenter;
    return label;
}

- (void)initializeButton
{
    self.autoresizeWidth = YES;
    self.contentInsets = UIEdgeInsetsMake(0, 20, 0, 20);
    self.userInteractionEnabled = YES;
    self.accessibilityTraits = UIAccessibilityTraitButton;
    
    self.backgroundView = [[WSActionButtonBackgroundView alloc] initWithFrame:self.bounds];
    [self addSubview:self.backgroundView];
        
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
    [[self leftAccessoryView] removeFromSuperview];

    if(leftAccessoryView)
    {
        leftAccessoryView.tag = LEFT_ACCESSORY_TAG;
        [self addSubview:leftAccessoryView];
    }
}   

- (void)setRightAccessoryView:(UIView *)rightAccessoryView
{
    [[self rightAccessoryView] removeFromSuperview];
    
    if(rightAccessoryView)
    {
        rightAccessoryView.tag = RIGHT_ACCESSORY_TAG;
        [self addSubview:rightAccessoryView];
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

- (void)setTextStyle:(WSActionButtonText)textStyle
{
    _textStyle = textStyle;
}

- (WSActionButtonText)textStyle
{
    return _textStyle;
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

- (void)updateLabelShadow:(UILabel*)label
{
//    BOOL invertedLight = self.isSelected||self.isHighlighted;
    if(self.backgroundView.backgroundColor.contrast>=0.5)
    {
        label.textColor = LABEL_DARK_COLOUR;
        label.shadowColor = [UIColor colorWithWhite:1. alpha:0.4];
        label.shadowOffset = CGSizeMake(0,1);
    } else {
        label.textColor = LABEL_BRIGHT_COLOUR;
        label.shadowColor = [UIColor colorWithWhite:0. alpha:0.4];
        label.shadowOffset = CGSizeMake(0, -1);
    }
}

- (void)updateTintColour
{
    self.backgroundView.layer.borderColor = [UIColor colorWithWhite:0. alpha:0.5].CGColor;
    self.layer.shadowOpacity = 0;
    
    if(self.isHighlighted)
    {
        [self.backgroundView updateBackgroundWithGradientTint:[self.tintColourActual colourByAdjustingHue:0 saturation:0 brightness:-0.1 alpha:0]
                                          from:-0.1 to:0.1];
    }
    else if(self.isSelected)
    {
        self.backgroundView.layer.borderColor = [self.selectedColour colourByAdjustingHue:0 saturation:0 brightness:-0.3 alpha:0].CGColor;
        self.layer.shadowRadius = 5;
        self.layer.shadowColor = self.selectedColour.CGColor;
        self.layer.shadowOpacity = 1;
        self.layer.shadowOffset = CGSizeMake(0,0);
        [self.backgroundView updateBackgroundWithGradientTint:self.selectedColour
                                          from:0.3 to:0];
    }
    else if(!self.isEnabled)
    {
        [self.backgroundView updateBackgroundWithGradientTint:[self.tintColourActual colourByAdjustingHue:0 saturation:-0.4 brightness:0.1 alpha:0]
                                            from:0.03 to:-0.03];
        self.titleLabel.shadowColor = [UIColor clearColor];
    }
    else {
        [self.backgroundView updateBackgroundWithGradientTint:self.tintColourActual from:0 to:-0.2];
    }
    
    [self updateLabelShadow:self.titleLabel];
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

- (void)setSelectedColour:(UIColor*)colour
{
    self.selectedColourActual = colour;
    [self updateTintColour];
}

- (UIColor *)selectedColour
{
    if(self.selectedColourActual)
        return self.selectedColourActual;
    else
        return self.tintColourActual;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self updateTintColour];
}

#pragma mark - layout

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize innerSize = CGSizeMake(size.width-self.contentInsets.left-self.contentInsets.right,
                                  size.height-self.contentInsets.top-self.contentInsets.bottom);
    
    CGSize labelSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(INT32_MAX, innerSize.height)];
    
    if(self.leftAccessoryView && !self.leftAccessoryView.hidden)
        labelSize.width+=self.leftAccessoryView.frame.size.width+INNER_PADDING;
    
    if(self.rightAccessoryView && !self.rightAccessoryView.hidden)
        labelSize.width+=self.rightAccessoryView.frame.size.width+INNER_PADDING;
    
    return CGSizeMake(self.contentInsets.left + labelSize.width + self.contentInsets.right,
                      self.contentInsets.top + labelSize.height + self.contentInsets.bottom);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundView.frame = self.bounds;

    CGRect titleFrame = UIEdgeInsetsInsetRect(self.bounds, self.contentInsets);
    
    if(self.leftAccessoryView && !self.leftAccessoryView.hidden)
    {
        // adjust title frame to be left offset
        titleFrame = CGRectMake(titleFrame.origin.x+self.leftAccessoryView.frame.size.width+INNER_PADDING,
                                titleFrame.origin.y,
                                titleFrame.size.width - self.leftAccessoryView.frame.size.width-INNER_PADDING, 
                                titleFrame.size.height);
        
        self.leftAccessoryView.frame = CGRectMake(self.contentInsets.left,
                                                  (self.frame.size.height-self.leftAccessoryView.frame.size.height)/2,
                                                  self.leftAccessoryView.frame.size.width,
                                                  self.leftAccessoryView.frame.size.height);
    }
    
    if(self.rightAccessoryView && !self.rightAccessoryView.hidden)
    {
        // adjust title frame to be left offset
        titleFrame = CGRectMake(titleFrame.origin.x,
                                titleFrame.origin.y,
                                titleFrame.size.width - self.rightAccessoryView.frame.size.width-INNER_PADDING, 
                                titleFrame.size.height);
        
        self.rightAccessoryView.frame = CGRectMake(self.bounds.size.width-self.contentInsets.right-self.rightAccessoryView.frame.size.width,
                                                  (self.frame.size.height-self.rightAccessoryView.frame.size.height)/2,
                                                  self.rightAccessoryView.frame.size.width,
                                                  self.rightAccessoryView.frame.size.height);
    }
    
    self.titleLabel.frame = titleFrame;
}

- (void)setTitle:(NSString*)title
{
    [self setTitle:title animated:NO];
}

- (NSString*)title
{
    return self.titleLabel.text;
}

- (void)setTitle:(NSString *)title animated:(BOOL)animated
{
    if(!self.autoresizeWidth)
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
