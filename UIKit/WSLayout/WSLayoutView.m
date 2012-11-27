#import "WSLayoutView.h"
#import "UIView+WSLayout.h"

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
    if(view.hidden || view.alpha == 0)
        return NO;
    
    if(self.alignment==WSLayoutViewAlignmentVertical)
        return view.autoresizingMask&UIViewAutoresizingFlexibleHeight;
    else
        return view.autoresizingMask&UIViewAutoresizingFlexibleWidth;
}

- (CGSize)calculateViewSizeThatFits:(CGSize)size andPerformLayout:(BOOL)performLayout
{
    NSMutableDictionary *calculatedFrames = [NSMutableDictionary dictionary];
    
    // First pass: calculate sizes of FIXED views
    CGSize  sizeOfContents = CGSizeZero;
    NSInteger numberOfFlexibleViews = 0;
    for(int i = 0; i < self.subviews.count; i++) {
        UIView *view = [self.subviews objectAtIndex:i];
        
        
        // Ignore flexible views, other than to determine their number
        if([self isViewFlexibleInAlignmentDirection:view])
        {
            numberOfFlexibleViews++;
            continue;
        }
        
        
        // Calculate the view's optimal size and store for later use
        CGSize viewSize = CGSizeZero;
        
        // If not hidden, calculate view size
        if(!view.hidden && view.alpha>0)
            viewSize = [view sizeThatFits:size];
        
        // calculate our optimal size for FIXED views
        if(self.alignment==WSLayoutViewAlignmentVertical)
        {
            sizeOfContents.width    = MAX(sizeOfContents.width, viewSize.width);
            sizeOfContents.height   +=viewSize.height;
            
            viewSize.width          = size.width;
        }
        else
        {
            sizeOfContents.height   = MAX(viewSize.height, sizeOfContents.height);
            sizeOfContents.width    +=viewSize.width;
            
            viewSize.height         = size.height;
        }
        
        [calculatedFrames setObject:[NSValue valueWithCGSize:viewSize] forKey:@(i)];
    }
    
    // Calculate size of each flexible view
    CGSize sizeOfEachFlexibleView = CGSizeZero;
    if(self.alignment==WSLayoutViewAlignmentVertical)
    {
        sizeOfEachFlexibleView = CGSizeMake(self.frame.size.width, MAX(0, self.frame.size.height - sizeOfContents.height)/ numberOfFlexibleViews);
    }
    else
    {
        sizeOfEachFlexibleView = CGSizeMake(MAX(0, self.frame.size.width - sizeOfContents.width)/ numberOfFlexibleViews, self.frame.size.height);
    }
    
    NSMutableArray *debugStrings = [NSMutableArray array];
    
    // Second pass: Calculate non-alignment sizes of FLEXIBLE views
    // Optionally layout the view (modify the subview frames)
    CGFloat currentLayoutOffset = 0;
    for(int i = 0; i < self.subviews.count; i++) {
        UIView *view = [self.subviews objectAtIndex:i];
        CGSize viewSize = [[calculatedFrames objectForKey:@(i)] CGSizeValue];
        CGRect newFrameForView = CGRectMake(0,0,viewSize.width,viewSize.height);
        
        // Flexible view's havent yet been consultate about their optimal size
        // Now we know their preferred size, ask them now, before layout
        if([self isViewFlexibleInAlignmentDirection:view])
        {
            // Calculate size of flexible views
            viewSize = [view sizeThatFits:sizeOfEachFlexibleView];
            newFrameForView.size = sizeOfEachFlexibleView;
            
            // Update our optimal size for FLEXIBLE views
            if(self.alignment==WSLayoutViewAlignmentVertical)
            {
                sizeOfContents.width = MAX(sizeOfContents.width, viewSize.width);
                sizeOfContents.height+=newFrameForView.size.height;
            }
            else
            {
                sizeOfContents.height = MAX(sizeOfContents.height, viewSize.height);
                sizeOfContents.width+=newFrameForView.size.width;
            }
        }
        
        // Optionally set frame on subview's, i.e. update their layout
        if(performLayout)
        {
            // Calculate view's origin
            if(self.alignment==WSLayoutViewAlignmentVertical)
            {
                newFrameForView.origin.y = currentLayoutOffset;
                currentLayoutOffset+= newFrameForView.size.height;
            }
            else
            {
                newFrameForView.origin.x = currentLayoutOffset;
                currentLayoutOffset+= newFrameForView.size.width;
            }
            
            view.frame = newFrameForView;
        }
        
        [debugStrings addObject:[NSString stringWithFormat:@"%@%@", NSStringFromClass([view class]), NSStringFromCGRect(newFrameForView)]];
    }
    
    if(self.traceLayout && debugStrings.count)
        NSLog(@"\n[WSLayoutView:%@:%@]\n  %@\n", self.alignment==WSLayoutViewAlignmentHorizontal ? @"H" : @"V", NSStringFromCGSize(sizeOfContents), [debugStrings componentsJoinedByString:@"\n  "]);
    
    // Update optimum size of view
    return sizeOfContents;
}

- (void)notifyViewDidChangeSize
{
    [super notifyViewDidChangeSize];
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
    _sizeOfContents = [self calculateViewSizeThatFits:self.frame.size andPerformLayout:NO];
    return _sizeOfContents;
}

@end