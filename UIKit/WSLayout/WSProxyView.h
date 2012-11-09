#import <UIKit/UIKit.h>

typedef void (WSProxyViewLayoutSubviewsBlock) (UIView *view);

@interface WSProxyView : UIView
@property (nonatomic, readwrite) UIView *innerView;
- (id)initWithInnerView:(UIView*)view;
@end
