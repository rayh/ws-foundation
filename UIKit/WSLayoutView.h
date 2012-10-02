#import <UIKit/UIKit.h>

typedef enum {
    WSLayoutViewAlignmentHorizontal,
    WSLayoutViewAlignmentVertical
} WSLayoutViewAlignment;

@interface WSLayoutView : UIView
@property (nonatomic) WSLayoutViewAlignment alignment;
@property (nonatomic) CGFloat animationDuration;
@property (nonatomic, readonly) CGSize sizeOfContents;

+ (UIView*)flexibleSpace;
+ (UIView*)fixedSpaceWithSize:(CGFloat)size;

+ (WSLayoutView*)layoutInFrame:(CGRect)rect
                         views:(NSArray*)views
                     alignment:(WSLayoutViewAlignment)alignment;

+ (WSLayoutView*)layoutInFrame:(CGRect)rect
                         views:(NSArray*)views
                     alignment:(WSLayoutViewAlignment)alignment
                      duration:(CGFloat)animationDuration;


- (void)addFlexibleSpace;
- (void)addFixedSpaceWithSize:(CGFloat)size;
@end
