#import <UIKit/UIKit.h>
#import "WSProxyView.h"

@interface WSEdgeInsetsView : WSProxyView
- (id)initWithInnerView:(UIView*)view insets:(UIEdgeInsets)insets;
@end