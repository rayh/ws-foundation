#import "WSLayoutView.h"
#import "UIView+WSLayout.h"

@interface WSLayoutSpacerView : UIView
@property (nonatomic, assign) CGSize preferredSize;
@end

@implementation WSLayoutSpacerView
- (CGSize)sizeThatFits:(CGSize)size
{
    return self.preferredSize;
}
@end

@interface WSLayoutView () {
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
    // First pass: calculate sizes of FIXED views
    CGSize* calculatedFrames = malloc(self.subviews.count * sizeof *calculatedFrames);
    CGSize  sizeOfContents = CGSizeZero;
    NSInteger numberOfFlexibleViews = 0;
    CGFloat sizeOfFlexibleViews = 0;
    for(int i = 0; i < self.subviews.count; i++) {
        UIView *view = [self.subviews objectAtIndex:i];
        calculatedFrames[i] = CGSizeZero;
        BOOL isFlexible = [self isViewFlexibleInAlignmentDirection:view];
        
        // Ignore flexible views, other than to determine their number
        if(isFlexible)
            numberOfFlexibleViews++;
        
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
            
            if(isFlexible)
                sizeOfFlexibleViews +=viewSize.height;
        }
        else
        {
            sizeOfContents.height   = MAX(viewSize.height, sizeOfContents.height);
            sizeOfContents.width    +=viewSize.width;
            
            viewSize.height         = size.height;
            
            if(isFlexible)
                sizeOfFlexibleViews +=viewSize.width;
        }
        
        calculatedFrames[i] = viewSize;
    }
    
    // Calculate size of each flexible view
    CGSize sizeOfEachFlexibleView = CGSizeZero;
    if(self.alignment==WSLayoutViewAlignmentVertical)
    {
        sizeOfEachFlexibleView = CGSizeMake(MAX(self.frame.size.width, sizeOfContents.width),
                                            MAX(0, self.frame.size.height - sizeOfContents.height+sizeOfFlexibleViews)/ numberOfFlexibleViews);
    }
    else
    {
        sizeOfEachFlexibleView = CGSizeMake(MAX(0, self.frame.size.width - sizeOfContents.width+sizeOfFlexibleViews)/ numberOfFlexibleViews,
                                            MAX(self.frame.size.height, sizeOfContents.height));
    }
    
    if(performLayout)
    {
        NSMutableArray *debugStrings = nil;
        
        if(self.traceLayout)
            debugStrings = [NSMutableArray array];
        
        // Second pass, perform layout of subviews
        CGFloat currentLayoutOffset = 0;
        for(int i = 0; i < self.subviews.count; i++) {
            UIView *view = [self.subviews objectAtIndex:i];
            CGSize viewSize = calculatedFrames[i];
            CGRect newFrameForView = CGRectMake(0,0,viewSize.width,viewSize.height);
            
            // Flexible view's havent yet been consultate about their optimal size
            // Now we know their preferred size, ask them now, before layout
            if([self isViewFlexibleInAlignmentDirection:view])
                newFrameForView.size = sizeOfEachFlexibleView;
            
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
            [view layoutSubviews];
            
            if(self.traceLayout)
                [debugStrings addObject:[NSString stringWithFormat:@"%@%@", NSStringFromClass([view class]), NSStringFromCGRect(newFrameForView)]];
        }
        
        if(debugStrings)
            NSLog(@"\n[WSLayoutView:%@:%@]\n  %@\n", self.alignment==WSLayoutViewAlignmentHorizontal ? @"H" : @"V", NSStringFromCGSize(sizeOfContents), [debugStrings componentsJoinedByString:@"\n  "]);
    }
    
    free(calculatedFrames);
    
    // Update optimum size of view
    return sizeOfContents;
}

- (void)didAddSubview:(UIView *)subview
{
    [subview notifyViewDidChangeSize];
    [super didAddSubview:subview];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self notifyViewDidChangeSize];
}

- (void)notifyViewDidChangeSize
{
    [super notifyViewDidChangeSize];
}

// Hack to force update for view size when the frame goes from 0 to something non zero in the non-alignment direction
// This forces an update of the view when a multiline label or any other view that can size itself in both directions.
- (void)setFrame:(CGRect)frame
{
    if(frame.size.width>0 && self.frame.size.width==0 && self.alignment==WSLayoutViewAlignmentVertical)
    {
        _hasBeenInitialized = NO;
        [self notifyViewDidChangeSize];
    }
    else if(frame.size.height>0 && self.frame.size.height==0 && self.alignment==WSLayoutViewAlignmentHorizontal)
    {
        _hasBeenInitialized = NO;
        [self notifyViewDidChangeSize];
    }
    
    [super setFrame:frame];
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
    return [self calculateViewSizeThatFits:self.frame.size andPerformLayout:NO];
}

- (void)addFlexibleSpace
{
    
    WSLayoutSpacerView *spacer = [[WSLayoutSpacerView alloc] init];
    spacer.preferredSize = CGSizeZero;
    spacer.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self addSubview:spacer];
}

- (void)addFixedSpace:(CGFloat)size
{
    WSLayoutSpacerView *spacer = [[WSLayoutSpacerView alloc] init];
    spacer.preferredSize = CGSizeMake(self.alignment==WSLayoutViewAlignmentHorizontal ? size : 0,
                                      self.alignment==WSLayoutViewAlignmentVertical ? size : 0);
    
    [self addSubview:spacer];
}
@end