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
    // First pass: calculate sizes of FIXED views
    CGFloat sizeOfFixedViews = 0;
    NSInteger numberOfFlexibleViews = 0;
    for(int i = 0; i < self.subviews.count; i++) {
        UIView *view = [self.subviews objectAtIndex:i];
        if(view.hidden || view.alpha == 0)
            continue;
        
        if([self isViewFlexibleInAlignmentDirection:view])
        {
            numberOfFlexibleViews++;
            continue;
        }
        
        if(self.alignment==WSLayoutViewAlignmentVertical)
        {
            sizeOfFixedViews+=[view sizeThatFits:CGSizeMake(size.width, self.frame.size.height)].height;
        }
        else
        {
            sizeOfFixedViews+=[view sizeThatFits:CGSizeMake(self.frame.size.width, size.height)].width;
        }
    }
    
    // Calculate optimum size of view
    CGFloat remainingSize = 0;
    if(self.alignment==WSLayoutViewAlignmentVertical)
    {
        remainingSize = MAX(0, self.frame.size.height - sizeOfFixedViews);
    }
    else
    {
        remainingSize = MAX(0, self.frame.size.width - sizeOfFixedViews);
    }
    
    // Calculate size of flexible views
    CGFloat sizeOfFlexibleViews = 0;
    CGFloat maxSizeInNonAlignmentDirection = 0;
    CGFloat sizeOfEachFlexibleView = remainingSize / numberOfFlexibleViews;
    CGFloat currentLayoutOffset = 0;
    
    // Second pass: Calculate non-alignment sizes of FLEXIBLE views
    // Optionally layout the view (modify the subview frames)
    for(int i = 0; i < self.subviews.count; i++) {
        UIView *view = [self.subviews objectAtIndex:i];
        if(view.hidden || view.alpha == 0)
            continue;
        
        CGFloat sizeInAlignmnetDirection = 0;
        BOOL isFlexible = [self isViewFlexibleInAlignmentDirection:view];
        
        if(self.alignment==WSLayoutViewAlignmentVertical)
        {
            CGSize viewSize = [view sizeThatFits:CGSizeMake(size.width, isFlexible ? sizeOfEachFlexibleView : self.frame.size.height)];
            sizeInAlignmnetDirection = isFlexible ? sizeOfEachFlexibleView : viewSize.height;
            maxSizeInNonAlignmentDirection = MAX(maxSizeInNonAlignmentDirection, viewSize.width);
            
            if(performLayout)
                view.frame = CGRectMake(0, currentLayoutOffset, self.frame.size.width, sizeInAlignmnetDirection);
        }
        else
        {
            CGSize viewSize = [view sizeThatFits:CGSizeMake(isFlexible ? sizeOfEachFlexibleView : self.frame.size.width, size.height)];
            sizeInAlignmnetDirection = isFlexible ? sizeOfEachFlexibleView : viewSize.width;
            maxSizeInNonAlignmentDirection = MAX(maxSizeInNonAlignmentDirection, viewSize.height);
            
            if(performLayout)
                view.frame = CGRectMake(currentLayoutOffset, 0, sizeInAlignmnetDirection, self.frame.size.height);
        }
        
        currentLayoutOffset+=sizeInAlignmnetDirection;        
        
        if(isFlexible)
            sizeOfFlexibleViews+=sizeInAlignmnetDirection;
    }
    
    // Calculate optimum size of view
    if(self.alignment==WSLayoutViewAlignmentVertical)
        _sizeOfContents = CGSizeMake(maxSizeInNonAlignmentDirection, sizeOfFixedViews+sizeOfFlexibleViews);
    else
        _sizeOfContents = CGSizeMake(sizeOfFixedViews+sizeOfFlexibleViews, maxSizeInNonAlignmentDirection);
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