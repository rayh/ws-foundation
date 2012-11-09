#import <UIKit/UIKit.h>
#import "WSProxyView.h"

typedef CGSize (^WSCalculateSizeThatFitsBlock) (UIView *view, CGSize size);

@interface WSFixedSizeView : WSProxyView
@property (nonatomic, copy) WSCalculateSizeThatFitsBlock sizeBlock;

+ (WSFixedSizeView*)sizedView:(UIView*)view withFixedSize:(CGSize)fixedSize;
+ (WSFixedSizeView*)sizedView:(UIView*)view withSizeCalculation:(WSCalculateSizeThatFitsBlock)sizeBlock;
@end
