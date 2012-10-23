#import <UIKit/UIKit.h>

typedef void (^UIViewLayoutConfigureBlock)(UIView *layoutView);

@interface WSProxyView : UIView
@property (nonatomic, readwrite) UIView *innerView;
@end

@interface UIView (WSLayout)

// Create view in which all subviews are stacked verticalled from the top to bottom
+ (UIView*)horizontalLayoutView:(UIViewLayoutConfigureBlock)configure;

// Create view in which all subviews are stackd horizontally from left to right
+ (UIView*)verticalLayoutView:(UIViewLayoutConfigureBlock)configure;

// Create view in which all subviews inherit the view's bounds
+ (UIView*)pinnedToBoundsLayoutView:(UIViewLayoutConfigureBlock)configure;

// Utility methods for spacing layouts
- (void)addFlexibleSpace;
- (void)addFixedSpaceWithSize:(CGFloat)size;


- (UIView*)withEdgeInsets:(UIEdgeInsets)insets;
- (UIView*)withPadding:(CGFloat)padding;
- (UIView*)withContainerView:(UIViewLayoutConfigureBlock)configure;
- (UIView*)withCenteringView;
- (UIView*)withFixedSize:(CGSize)size;

// Inform superviews that this view changed it's size
- (void)notifyViewDidChangeSize;

- (void)debugLayout;
@end
