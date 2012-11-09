#import "WSScrollLayoutView.h"

@implementation WSScrollLayoutView

- (void)layoutSubviews
{
    if(self.subviews.count==0)
        return;
    
    UIView *innerView = self.subviews[0];
    [innerView sizeToFit];
    innerView.frame = CGRectMake(0,0,self.frame.size.width, MAX(innerView.frame.size.height, self.frame.size.height));
    self.contentSize = innerView.frame.size;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    if(self.subviews.count==0)
        return CGSizeZero;
    
    UIView *innerView = self.subviews[0];
    return [innerView sizeThatFits:size];
}

@end
