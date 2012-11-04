#import <UIKit/UIKit.h>

typedef enum {
    WSLayoutViewAlignmentHorizontal,
    WSLayoutViewAlignmentVertical
} WSLayoutViewAlignment;

@interface WSLayoutView : UIView
@property (nonatomic) WSLayoutViewAlignment alignment;
@property (nonatomic) CGFloat animationDuration;
@property (nonatomic, readonly) CGSize sizeOfContents;

+ (WSLayoutView*)layoutInFrame:(CGRect)rect
                         views:(NSArray*)views
                     alignment:(WSLayoutViewAlignment)alignment;

+ (WSLayoutView*)layoutInFrame:(CGRect)rect
                         views:(NSArray*)views
                     alignment:(WSLayoutViewAlignment)alignment
                      duration:(CGFloat)animationDuration;

@end
