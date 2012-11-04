#import "WSProxyView.h"

@implementation WSProxyView
- (id)initWithInnerView:(UIView*)view
{
    if(self = [super initWithFrame:view.frame])
    {
        self.backgroundColor = [UIColor clearColor];
        self.innerView = view;
    }
    return self;
}

- (UIView *)innerView
{
    if(self.subviews.count==0)
        return nil;
    
    return [[self subviews] objectAtIndex:0];
}

- (void)setInnerView:(UIView *)innerView
{
    innerView.frame = self.bounds;
    [self insertSubview:innerView atIndex:0];
}

- (void)layoutSubviews
{
    self.innerView.frame = self.bounds;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return [self.innerView sizeThatFits:size];
}
@end