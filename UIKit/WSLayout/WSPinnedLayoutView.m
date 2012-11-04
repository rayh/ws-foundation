#import "WSPinnedLayoutView.h"

@implementation WSPinnedLayoutView

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize optimumSize = CGSizeZero;
    for(UIView *subview in self.subviews)
    {
        CGSize subviewSize = [subview sizeThatFits:size]; // or self.bounds.size?
        optimumSize = CGSizeMake(MAX(subviewSize.width, optimumSize.width),
                                 MAX(subviewSize.height,optimumSize.height));

    }
    
    return optimumSize;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for(UIView *view in self.subviews)
        view.frame = self.bounds;
}

@end
