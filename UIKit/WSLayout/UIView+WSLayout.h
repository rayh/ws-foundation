#import <UIKit/UIKit.h>

typedef CGSize (^UIViewSizeCalculationBlock)(UIView *viewToSize, CGSize sizeToFit);

@interface UIView (WSLayout)

// Create a UIView with CGRectZero
+ (UIView*)view:(void(^)(UIView *view))configure;

// Create view in which all subviews are stacked verticalled from the top to bottom
+ (UIView*)horizontalLayoutView:(void(^)(UIView *horizontalView))configure;

// Create view in which all subviews are stackd horizontally from left to right
+ (UIView*)verticalLayoutView:(void(^)(UIView *verticalView))configure;

// Create view in which all subviews inherit the view's bounds
+ (UIView*)pinnedToBoundsLayoutView:(void(^)(UIView *pinnedLayoutView))configure;
@end

@interface UIView (WSLayoutUtility)

// Utility methods for spacing layouts
- (void)addFlexibleSpace;
- (void)addFixedSpaceWithSize:(CGFloat)size;
@end

@interface UIView (WSWrappedView)

// Inset the current view by the given amount.
- (UIView*)withEdgeInsets:(UIEdgeInsets)insets;

// A shortcut for the above when padding by an equal amount in all directions.
- (UIView*)withPadding:(CGFloat)padding;

// Center the current view in whatever the parent views bounds are
- (UIView*)withCentering;

// Wrap the current view in a scrollable region that attempts to stretch the content to
// the scroll view's bounds, unless the content size is larger than those bounds
- (UIView*)withScrolling;

// Override sizeThatFits and provide a fixed size for this view
- (UIView*)withFixedSize:(CGSize)size;

// Override sizeThatFits and provide a block to calculate the view's size
//- (UIView*)withSizeCalculation:(UIViewSizeCalculationBlock)sizingBlock;

// Apply the given configuration block to the current view
- (UIView*)apply:(void(^)(UIView *view))configure;

// Inform superviews that this view changed it's size.  This will force the containing layout
// to adjust it's frame to fit
- (void)notifyViewDidChangeSize;
@end

@interface UIView (WSLayoutDebug)
- (void)debugLayout;
@end
