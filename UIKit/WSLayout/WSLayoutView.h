#import <UIKit/UIKit.h>

typedef enum {
    WSLayoutViewAlignmentHorizontal,
    WSLayoutViewAlignmentVertical
} WSLayoutViewAlignment;

@interface WSLayoutView : UIView
@property (nonatomic) WSLayoutViewAlignment alignment;
@property (nonatomic) CGFloat animationDuration;
@property (nonatomic, readonly) CGSize sizeOfContents;
@property (nonatomic, assign) BOOL traceLayout;
@end
