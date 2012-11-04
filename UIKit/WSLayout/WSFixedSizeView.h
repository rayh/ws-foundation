#import <UIKit/UIKit.h>
#import "WSProxyView.h"

@interface WSFixedSizeView : WSProxyView
- (id)initWithInnerView:(UIView *)view size:(CGSize)size;
@end
