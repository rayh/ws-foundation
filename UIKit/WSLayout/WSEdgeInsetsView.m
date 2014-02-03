#import "WSEdgeInsetsView.h"

@interface WSEdgeInsetsView ()
@property (nonatomic, assign) UIEdgeInsets insets;
@end

@implementation WSEdgeInsetsView

- (id)initWithInnerView:(UIView*)view insets:(UIEdgeInsets)insets
{
    if(self = [super initWithInnerView:view])
    {
        self.insets = insets;
    }
    return self;
}

- (void)layoutSubviews
{
    self.innerView.frame = UIEdgeInsetsInsetRect(self.bounds, self.insets);
}

- (CGSize)sizeThatFits:(CGSize)size
{
    if(self.hidden)
        return CGSizeZero;
    
    CGSize innerSize = [self.innerView sizeThatFits:CGSizeMake(size.width-self.insets.left-self.insets.right, size.height-self.insets.top-self.insets.bottom)];

    // If the inner view has no size, then dont pad
    if(innerSize.width==0 || innerSize.height==0)
        return CGSizeZero;

    return CGSizeMake(innerSize.width+self.insets.left+self.insets.right, innerSize.height+self.insets.top+self.insets.bottom);
}
@end
