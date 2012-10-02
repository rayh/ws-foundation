#import "UIView+Layout.h"
#import "WSLayoutView.h"
#import <QuartzCore/QuartzCore.h>

@interface UIProxyView ()
- (id)initWithInnerView:(UIView*)view;
@end

@interface UIInsetView : UIProxyView
@property (nonatomic, assign) UIEdgeInsets insets;
- (id)initWithInnerView:(UIView*)view insets:(UIEdgeInsets)insets;
@end

@interface APForceVerticalView : UIProxyView
@property (nonatomic) CGFloat verticalHeight;
- (id)initWithInnerView:(UIView*)view height:(CGFloat)height;
@end

@implementation UIView (Layout)

+ (UIView*)layoutViewWithAlignment:(WSLayoutViewAlignment)alignment configure:(UIViewLayoutConfigureBlock)configure
{
  UIView *view = [WSLayoutView layoutInFrame:CGRectZero views:@[] alignment:alignment];
  if(configure)
    configure(view);
  return view;
}

+ (UIView*)horizontalLayoutView:(UIViewLayoutConfigureBlock)configure
{
  return [self layoutViewWithAlignment:WSLayoutViewAlignmentHorizontal configure:configure];
}

+ (UIView*)verticalLayoutView:(UIViewLayoutConfigureBlock)configure
{
  return [self layoutViewWithAlignment:WSLayoutViewAlignmentVertical configure:configure];
}

- (void)addHorizontallyAlignedView:(UIViewLayoutConfigureBlock)configure
{
  UIView *view = [UIView horizontalLayoutView:configure];
  view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  [self addSubview:view];
}

- (void)addVerticallyAlignedView:(UIViewLayoutConfigureBlock)configure
{
  UIView *view = [UIView verticalLayoutView:configure];
  view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
  [self addSubview:view];
}

- (void)addFlexibleSpace
{
  [self addSubview:[WSLayoutView flexibleSpace]];
}

- (void)addFixedSpaceWithSize:(CGFloat)size
{
  [self addSubview:[WSLayoutView fixedSpaceWithSize:size]];
}

- (UIView*)withEdgeInsets:(UIEdgeInsets)insets
{
  return [[UIInsetView alloc] initWithInnerView:self insets:insets];
}

- (UIView*)withPadding:(CGFloat)padding
{
  return [self withEdgeInsets:UIEdgeInsetsMake(padding, padding, padding, padding)];
}

- (UIView*)withCornerRadius:(CGFloat)radius
{
  self.layer.cornerRadius = radius;
  self.clipsToBounds = YES;
  return [[UIProxyView alloc] initWithInnerView:self];
}

- (UIView*)withFixedHeight:(CGFloat)height {
  APForceVerticalView *verticalView = [[APForceVerticalView alloc] initWithInnerView:self height:height];
  return verticalView;
}

- (void)notifyViewDidChangeSize
{
  [self setNeedsLayout];
  [self.superview notifyViewDidChangeSize];
}

- (void)debugLayoutWithDepth:(NSInteger)depth
{
  
  self.layer.borderColor = [UIColor colorWithHue:((float)depth/10.) saturation:0.5 brightness:1. alpha:0.8].CGColor;
  self.layer.borderWidth = 1.;  
  self.backgroundColor = [UIColor colorWithHue:((float)depth/10.) saturation:0.5 brightness:1. alpha:0.3];
  
  for(UIView *view in self.subviews)
  {
    [view debugLayoutWithDepth:depth+1];
  }
}

- (void)debugLayout
{
  [self debugLayoutWithDepth:0];
}
@end

@implementation UIProxyView
- (id)initWithInnerView:(UIView*)view
{
  if(self = [super initWithFrame:view.frame])
  {
    self.backgroundColor = [UIColor clearColor];
    self.innerView = view;
  }
  return self;
}

- (UIView *)innerView
{
  if(self.subviews.count==0)
    return nil;
  
  return [[self subviews] objectAtIndex:0];
}

- (void)setInnerView:(UIView *)innerView
{
  innerView.frame = self.bounds;
  [self insertSubview:innerView atIndex:0];
}

- (void)layoutSubviews
{
  self.innerView.frame = self.bounds;
}

- (CGSize)sizeThatFits:(CGSize)size
{
  return [self.innerView sizeThatFits:size];
}
@end


@implementation UIInsetView
- (id)initWithInnerView:(UIView*)view insets:(UIEdgeInsets)insets
{
  if(self = [super initWithInnerView:view])
  {
    self.insets = insets;
  }
  return self;
}
- (void)layoutSubviews
{
  self.innerView.frame = UIEdgeInsetsInsetRect(self.bounds, self.insets);
}
- (CGSize)sizeThatFits:(CGSize)size
{
  CGSize innerSize = [self.innerView sizeThatFits:CGSizeMake(size.width-self.insets.left-self.insets.right, size.height-self.insets.top-self.insets.bottom)];
  return CGSizeMake(innerSize.width+self.insets.left+self.insets.right, innerSize.height+self.insets.top+self.insets.bottom);
}
@end


@implementation APForceVerticalView

- (id)initWithInnerView:(UIView*)view height:(CGFloat)height {
  
  if(self = [super initWithInnerView:view]) {
    self.verticalHeight = height;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  }
  return self;
}

- (CGSize) sizeThatFits:(CGSize)size {
  return CGSizeMake(44., self.verticalHeight);
}

- (void)layoutSubviews {
  [super layoutSubviews];
  self.innerView.frame = self.bounds;
}

@end
