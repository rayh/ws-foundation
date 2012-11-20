#import "WSLayoutView.h"

@interface WSLayoutView () {
    CGSize _sizeOfContents;
    BOOL _hasBeenInitialized;
}
@end

@implementation WSLayoutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.animationDuration = 0.;
        self.alignment = WSLayoutViewAlignmentHorizontal;
    }
    return self;
}

- (BOOL)isViewFlexibleInAlignmentDirection:(UIView*)view
{
    if(self.alignment==WSLayoutViewAlignmentVertical)
        return view.autoresizingMask&UIViewAutoresizingFlexibleHeight;
    else
        return view.autoresizingMask&UIViewAutoresizingFlexibleWidth;
}

- (void)calculateViewSizeThatFits:(CGSize)size andPerformLayout:(BOOL)performLayout
{
    // calculate sizes of views
    CGFloat viewSizes[self.subviews.count];
    CGFloat maxSizeInNonAlignmentDirection = 0;
    CGFloat sizeOfFixedViews = 0;
    CGFloat sizeOfFlexibleViews = 0;
    NSInteger numberOfFlexibleViews = 0;
    for(int i = 0; i < self.subviews.count; i++) {
        UIView *view = [self.subviews objectAtIndex:i];
        if(view.hidden || view.alpha == 0)
            continue;

        CGFloat viewSizeInAlignmentDirection = 0;
        CGSize viewSize;
        
        
        if(self.alignment==WSLayoutViewAlignmentVertical)
        {
            viewSize = [view sizeThatFits:CGSizeMake(size.width, self.frame.size.height)];
            viewSizeInAlignmentDirection=viewSize.height;
            maxSizeInNonAlignmentDirection = MAX(maxSizeInNonAlignmentDirection, viewSize.width);
            viewSizes[i] = viewSize.height;
        }
        else
        {
            viewSize = [view sizeThatFits:CGSizeMake(self.frame.size.width, size.height)];
            viewSizeInAlignmentDirection=viewSize.width;
            maxSizeInNonAlignmentDirection = MAX(maxSizeInNonAlignmentDirection, viewSize.height);
            viewSizes[i] = viewSize.width;
        }
    
        
        // Is this a stretchable view or fixed size?
        if([self isViewFlexibleInAlignmentDirection:view])
        {
            sizeOfFlexibleViews+=viewSizeInAlignmentDirection;
            numberOfFlexibleViews++;
        }
        else
            sizeOfFixedViews+=viewSizeInAlignmentDirection;
    }
    
    // Calculate optimum size of view
    CGFloat remainingSize = 0;
    if(self.alignment==WSLayoutViewAlignmentVertical)
    {
        remainingSize = MAX(0, self.frame.size.height - sizeOfFixedViews);
        _sizeOfContents = CGSizeMake(maxSizeInNonAlignmentDirection, sizeOfFixedViews+sizeOfFlexibleViews);
    }
    else
    {
        remainingSize = MAX(0, self.frame.size.width - sizeOfFixedViews);
        _sizeOfContents = CGSizeMake(sizeOfFixedViews+sizeOfFlexibleViews, maxSizeInNonAlignmentDirection);
    }
    
    if(!performLayout)
        return;

    // Calculate size of flexible views
    CGFloat heightOfEachFlexibleView = remainingSize / numberOfFlexibleViews;
    
    // Layout subviews
    CGFloat offset = 0;
    for(int i = 0; i < self.subviews.count; i++) {
        UIView *view = [self.subviews objectAtIndex:i];
        if(view.hidden || view.alpha == 0)
            continue;
      
        CGFloat sizeInAlignmentDirection = [self isViewFlexibleInAlignmentDirection:view] ? heightOfEachFlexibleView : viewSizes[i];
        
        if(self.alignment==WSLayoutViewAlignmentVertical)
//            if(view.autoresizingMask&UIViewAutoresizingFlexibleWidth)
                view.frame = CGRectMake(0, offset, self.frame.size.width, sizeInAlignmentDirection);
//            else
//                view.frame = CGRectMake(view.frame.origin.x, offset, view.frame.size.width, sizeInAlignmentDirection);
        else
//            if(view.autoresizingMask&UIViewAutoresizingFlexibleHeight)
                view.frame = CGRectMake(offset, 0, sizeInAlignmentDirection, self.frame.size.height);
//            else
//                view.frame = CGRectMake(offset, view.frame.origin.y, sizeInAlignmentDirection, view.frame.size.height);
        
        offset+=sizeInAlignmentDirection;
    }
}

- (void)layoutSubviews
{
    if(self.animationDuration>0 && _hasBeenInitialized)
    {
        [UIView animateWithDuration:self.animationDuration 
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState 
                         animations:^{
            [self calculateViewSizeThatFits:self.frame.size andPerformLayout:YES];
        } completion:nil];
    }
    else 
    {
        [self calculateViewSizeThatFits:self.frame.size andPerformLayout:YES];
        _hasBeenInitialized = YES;
    }
    
}

- (CGSize)sizeThatFits:(CGSize)size {
    [self calculateViewSizeThatFits:self.frame.size andPerformLayout:NO];
    return _sizeOfContents;
}

@end
