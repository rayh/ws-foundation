#import "WSFixedSizeView.h"


@interface WSFixedSizeView ()
@property (nonatomic, assign) CGSize fixedSize;
@end

@implementation WSFixedSizeView

- (id)initWithInnerView:(UIView *)view size:(CGSize)size
{
    if(self = [super initWithInnerView:view]) {
        self.fixedSize = size;
//        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (CGSize) sizeThatFits:(CGSize)size {
    return self.fixedSize;
}
@end