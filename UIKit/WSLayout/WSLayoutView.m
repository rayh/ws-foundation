#import "WSLayoutView.h"

@interface WSLayoutView () {
    CGSize _sizeOfContents;
    BOOL _hasBeenInitialized;
}
@end

@implementation WSLayoutView


+ (WSLayoutView*)layoutInFrame:(CGRect)rect 
                         views:(NSArray*)views
                     alignment:(WSLayoutViewAlignment)alignment
{
    WSLayoutView *layoutView = [[WSLayoutView alloc] initWithFrame:rect];
    layoutView.animationDuration = 0;
    layoutView.alignment = alignment;
    for(UIView *view in views) {
        [layoutView addSubview:view];
    }
    
    [layoutView updateSubviewPostionsWithSize:rect.size];
    return layoutView;
}

+ (WSLayoutView*)layoutInFrame:(CGRect)rect 
                         views:(NSArray*)views
                     alignment:(WSLayoutViewAlignment)alignment
                      duration:(CGFloat)animationDuration
{
    WSLayoutView *layoutView = [self layoutInFrame:rect views:views alignment:alignment];
    layoutView.animationDuration = animationDuration;
    return layoutView;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.animationDuration = 0.;
        self.alignment = WSLayoutViewAlignmentHorizontal;
    }
    return self;
}

- (void)adjustViewFrameOriginAndSizeInNonAlignmentDirection:(UIView*)view
{
    if(self.alignment==WSLayoutViewAlignmentVertical)
        if(view.autoresizingMask&UIViewAutoresizingFlexibleWidth)
            view.frame = CGRectMake(0, 0, self.frame.size.width, view.frame.size.height);
        else
            view.frame = CGRectMake(view.frame.origin.x, 0, view.frame.size.width, view.frame.size.height);
    else
        if(view.autoresizingMask&UIViewAutoresizingFlexibleHeight)
            view.frame = CGRectMake(0, 0, view.frame.size.width, self.frame.size.height);
        else
            view.frame = CGRectMake(0, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
}

- (CGFloat)setFrameOnView:(UIView*)view withOffset:(CGFloat)offset flexibleViewSize:(CGFloat)sizeOfFlexibleViews
{
    [self adjustViewFrameOriginAndSizeInNonAlignmentDirection:view];
    
    if([self isViewFlexibleInAlignmentDirection:view])
    {
        if(self.alignment==WSLayoutViewAlignmentVertical)
            view.frame = CGRectMake(view.frame.origin.x, offset, view.frame.size.width, sizeOfFlexibleViews);
        else
            view.frame = CGRectMake(offset, view.frame.origin.y, sizeOfFlexibleViews, view.frame.size.height);

        return sizeOfFlexibleViews;
    }
    else
    {
        if(self.alignment==WSLayoutViewAlignmentVertical)
        {
            view.frame = CGRectMake(view.frame.origin.x,
                                    offset,
                                    view.frame.size.width,
                                    view.frame.size.height);
            return view.frame.size.height;
        }
        else
        {
            view.frame = CGRectMake(offset,
                                    view.frame.origin.y,
                                    view.frame.size.width,
                                    view.frame.size.height);
            return view.frame.size.width;
        }
    }
    
    NSLog(@"WSLayoutView: Set FRAME on %@ to %@", view, NSStringFromCGRect(view.frame));
}

- (BOOL)isViewFlexibleInAlignmentDirection:(UIView*)view
{
    if(self.alignment==WSLayoutViewAlignmentVertical)
        return view.autoresizingMask&UIViewAutoresizingFlexibleHeight;
    else
        return view.autoresizingMask&UIViewAutoresizingFlexibleWidth;
}

- (void)updateSubviewPostionsWithSize:(CGSize)size
{
    // calculate sizes of views
    CGFloat maxSizeInNonAlignmentDirection = 0;
    CGFloat sizeOfFixedViews = 0;
    CGFloat sizeOfFlexibleViews = 0;
    NSInteger numberOfFlexibleViews = 0;
    for(UIView *view in self.subviews) {
        if(view.hidden || view.alpha == 0)
            continue;

        CGFloat viewSizeInAlignmentDirection = 0;
        CGSize viewSize;
        
        
        if(self.alignment==WSLayoutViewAlignmentVertical)
        {
            viewSize = [view sizeThatFits:CGSizeMake(size.width, self.frame.size.height)];
            viewSizeInAlignmentDirection=viewSize.height;
            maxSizeInNonAlignmentDirection = MAX(maxSizeInNonAlignmentDirection, viewSize.width);
            view.frame = CGRectMake(0,0, self.frame.size.width, viewSize.height);
        }
        else
        {
            viewSize = [view sizeThatFits:CGSizeMake(self.frame.size.width, size.height)];
            viewSizeInAlignmentDirection=viewSize.width;
            maxSizeInNonAlignmentDirection = MAX(maxSizeInNonAlignmentDirection, viewSize.height);
            view.frame = CGRectMake(0,0, viewSize.width, self.frame.size.height);
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

    // Calculate size of flexible views
    CGFloat heightOfEachFlexibleView = remainingSize / numberOfFlexibleViews;
  
    
    // Calculate offsets
    CGFloat offset = 0;
    for(UIView *view in self.subviews) {
        if(view.hidden || view.alpha == 0)
            continue;
      
        offset+=[self setFrameOnView:view withOffset:offset flexibleViewSize:heightOfEachFlexibleView];
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
            [self updateSubviewPostionsWithSize:self.frame.size];
        } completion:nil];
    }
    else 
    {
        [self updateSubviewPostionsWithSize:self.frame.size];
        _hasBeenInitialized = YES;
    }
    
}

- (CGSize)sizeThatFits:(CGSize)size {
  [self updateSubviewPostionsWithSize:size];
  return _sizeOfContents;
}

@end
