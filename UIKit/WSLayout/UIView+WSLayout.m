#import "UIView+WSLayout.h"
#import "WSLayoutView.h"
#import <QuartzCore/QuartzCore.h>
#import "WSProxyView.h"
#import "WSCentredView.h"
#import "WSFixedSizeView.h"
#import "WSEdgeInsetsView.h"
#import "WSPinnedLayoutView.h"
#import "WSScrollLayoutView.h"

@implementation UIView (WSLayout)

+ (UIView*)view:(void(^)(UIView *view))configure
{
    UIView *simpleView = [[UIView alloc] initWithFrame:CGRectZero];
    if(simpleView)
        configure(simpleView);
    return simpleView;
}

+ (UIView*)layoutViewWithAlignment:(WSLayoutViewAlignment)alignment configure:(void(^)(UIView *))configure
{
    WSLayoutView *layoutView = [[WSLayoutView alloc] initWithFrame:CGRectZero];
    layoutView.animationDuration = 0;
    layoutView.alignment = alignment;
    
    if(configure)
        configure(layoutView);
    
    return layoutView;
}

+ (UIView*)horizontalLayoutView:(void (^)(UIView *))configure
{
  return [self layoutViewWithAlignment:WSLayoutViewAlignmentHorizontal configure:configure];
}

+ (UIView*)verticalLayoutView:(void (^)(UIView *))configure
{
  return [self layoutViewWithAlignment:WSLayoutViewAlignmentVertical configure:configure];
}

+ (UIView*)pinnedToBoundsLayoutView:(void (^)(UIView *))configure
{
    WSPinnedLayoutView *view = [[WSPinnedLayoutView alloc] initWithFrame:CGRectZero];
    if(configure)
        configure(view);
    return view;
}

@end


@implementation UIView (WSLayoutUtility)

- (void)addFlexibleSpace
{
  [self addSubview:[UIView view:^(UIView *view) {
      view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
  }]];
}

- (void)addFixedSpaceWithSize:(CGFloat)size
{
  [self addSubview:[[UIView alloc] initWithFrame:CGRectMake(0, 0, size, size)]];
}

@end


@implementation UIView (WSWrappedView)

- (UIView*)viewByProxying
{
    return [[WSProxyView alloc] initWithInnerView:self];
}

- (UIView *)apply:(void (^)(UIView *))configure
{
    if(configure)
        configure(self);
    
    return self;
}

- (UIView*)withCentreing
{
    return [[WSCentredView alloc] initWithInnerView:self];
}

- (UIView*)withEdgeInsets:(UIEdgeInsets)insets
{
  return [[WSEdgeInsetsView alloc] initWithInnerView:self insets:insets];
}

- (UIView*)withPadding:(CGFloat)padding
{
  return [self withEdgeInsets:UIEdgeInsetsMake(padding, padding, padding, padding)];
}

- (UIView*)withFixedSize:(CGSize)size {
  return [WSFixedSizeView sizedView:self withFixedSize:size];
}

- (UIView*)withCalculatedSize:(WSCalculateSizeThatFitsBlock)sizeBlock {
    return [WSFixedSizeView sizedView:self withSizeCalculation:sizeBlock];
}


- (UIView *)withScrolling
{
    WSScrollLayoutView *scrollView = [[WSScrollLayoutView alloc] initWithFrame:CGRectZero];
    [scrollView addSubview:self];
    return scrollView;
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
@end


@implementation UIView (WSLayoutDebug)

- (void)debugLayout
{
  [self debugLayoutWithDepth:0];
}
@end