#import "UIView+Layout.h"
#import "WSLayoutView.h"
#import <QuartzCore/QuartzCore.h>

@interface WSProxyView ()
- (id)initWithInnerView:(UIView*)view;
@end

@interface WSCenteredView : WSProxyView
@end

@interface WSInsetView : WSProxyView
@property (nonatomic, assign) UIEdgeInsets insets;
- (id)initWithInnerView:(UIView*)view insets:(UIEdgeInsets)insets;
@end

@interface WSLayoutExplicitSizeView : WSProxyView
@property (nonatomic) CGSize size;
- (id)initWithInnerView:(UIView*)view size:(CGSize)size;
@end

@interface WSPinnedToBoundsView : UIView
@end

@implementation UIView (WSLayout)

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

+ (UIView*)pinnedToBoundsLayoutView:(UIViewLayoutConfigureBlock)configure
{
    WSPinnedToBoundsView *view = [[WSPinnedToBoundsView alloc] initWithFrame:CGRectZero];
    if(configure)
        configure(view);
    return view;
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


#pragma mark - single-view methods

- (UIView*)withContainerView:(UIViewLayoutConfigureBlock)configure
{
    WSProxyView *view = [[WSProxyView alloc] initWithInnerView:self];
    if(configure)
        configure(view);
    return view;
}

- (UIView*)withCenteringView
{
    return [[WSCenteredView alloc] initWithInnerView:self];
}

- (UIView*)withEdgeInsets:(UIEdgeInsets)insets
{
  return [[WSInsetView alloc] initWithInnerView:self insets:insets];
}

- (UIView*)withPadding:(CGFloat)padding
{
  return [self withEdgeInsets:UIEdgeInsetsMake(padding, padding, padding, padding)];
}

- (UIView*)withFixedSize:(CGSize)size {
  WSLayoutExplicitSizeView *verticalView = [[WSLayoutExplicitSizeView alloc] initWithInnerView:self size:size];
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

#pragma mark - Private view implementations

@implementation WSProxyView
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

@implementation WSCenteredView
- (void)layoutSubviews
{
    self.innerView.center = self.center;
}
@end

@implementation WSInsetView
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


@implementation WSLayoutExplicitSizeView

- (id)initWithInnerView:(UIView *)view size:(CGSize)size
{
  if(self = [super initWithInnerView:view]) {
    self.size = size;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  }
  return self;
}

- (CGSize) sizeThatFits:(CGSize)size {
  return size;
}

@end

@implementation WSPinnedToBoundsView

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize maxSize = CGSizeZero;
    for(UIView *subview in self.subviews)
    {
        CGSize subviewSize = [subview sizeThatFits:size];
        if(subviewSize.width>maxSize.width)
            maxSize = CGSizeMake(subviewSize.width, maxSize.height);
        if(subviewSize.height>maxSize.height)
            maxSize = CGSizeMake(maxSize.width, subviewSize.height);
    }
    
    return maxSize;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for(UIView *view in self.subviews)
        view.frame = self.bounds;
}

@end