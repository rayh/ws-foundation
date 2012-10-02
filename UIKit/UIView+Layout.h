#import <UIKit/UIKit.h>

typedef void (^UIViewLayoutConfigureBlock)(UIView *layoutView);

@interface UIProxyView : UIView
@property (nonatomic, readwrite) UIView *innerView;
@end

@interface UIView (Layout)
+ (UIView*)horizontalLayoutView:(UIViewLayoutConfigureBlock)configure;
+ (UIView*)verticalLayoutView:(UIViewLayoutConfigureBlock)configure;
- (void)addHorizontallyAlignedView:(UIViewLayoutConfigureBlock)configure;
- (void)addVerticallyAlignedView:(UIViewLayoutConfigureBlock)configure;
- (void)addFlexibleSpace;
- (void)addFixedSpaceWithSize:(CGFloat)size;


- (UIView*)withEdgeInsets:(UIEdgeInsets)insets;
- (UIView*)withPadding:(CGFloat)padding;
- (UIView*)withCornerRadius:(CGFloat)radius;
- (UIView*)withFixedHeight:(CGFloat)height; 

// Inform superviews that this view changed it's size
- (void)notifyViewDidChangeSize;

- (void)debugLayout;
@end
