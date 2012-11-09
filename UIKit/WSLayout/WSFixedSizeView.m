#import "WSFixedSizeView.h"


@interface WSFixedSizeView ()
@end

@implementation WSFixedSizeView

+ (WSFixedSizeView*)sizedView:(UIView*)view withFixedSize:(CGSize)fixedSize
{
    return [self sizedView:view withSizeCalculation:^CGSize(UIView *view, CGSize size) {
        return fixedSize;
    }];
}

+ (WSFixedSizeView*)sizedView:(UIView*)view withSizeCalculation:(WSCalculateSizeThatFitsBlock)sizeBlock
{
    WSFixedSizeView *sizedView = [[WSFixedSizeView alloc] initWithInnerView:view];
    [sizedView setSizeBlock:sizeBlock];
    return sizedView;
}

- (CGSize) sizeThatFits:(CGSize)size {
    return self.sizeBlock(self, size);
}
@end