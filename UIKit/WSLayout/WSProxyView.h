#import <UIKit/UIKit.h>

@interface WSProxyView : UIView
@property (nonatomic, readwrite) UIView *innerView;
- (id)initWithInnerView:(UIView*)view;
@end
