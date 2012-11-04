#import "WSCentredView.h"

@implementation WSCentredView

- (void)layoutSubviews
{
    self.innerView.center = self.center;
}

@end