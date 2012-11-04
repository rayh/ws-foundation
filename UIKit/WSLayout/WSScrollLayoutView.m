#import "WSScrollLayoutView.h"

@implementation WSScrollLayoutView

- (void)layoutSubviews
{
    UIView *innerView = self.subviews[0];
    if(!innerView)
        return;
    
    [innerView sizeToFit];
    innerView.frame = CGRectMake(0,0,self.frame.size.width, MAX(innerView.frame.size.height, self.frame.size.height));
    self.contentSize = innerView.frame.size;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    UIView *innerView = self.subviews[0];
    if(!innerView)
        return CGSizeZero;
    
    return [innerView sizeThatFits:size];
}

@end
