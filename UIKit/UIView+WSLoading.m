//
//  WSLoading.m
//  WSFoundation
//
//  Created by Ray Hilton on 8/12/11.
//  Copyright (c) 2011 Wirestorm Pty Ltd. All rights reserved.
//

#import "UIView+WSLoading.h"
#import <QuartzCore/QuartzCore.h>

@interface WSLoadingView : UIView
@property (nonatomic, retain) UIView *contentView;
@end

@implementation WSLoadingView
@synthesize contentView=contentView_;

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        self.alpha = 0;
        self.backgroundColor = [UIColor clearColor]; //[UIColor colorWithWhite:0 alpha:0.5];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.contentView.backgroundColor = [UIColor colorWithWhite:0. alpha:0.5];
        self.contentView.layer.shadowColor = [UIColor colorWithWhite:0. alpha:0.6].CGColor;
        self.contentView.layer.shadowOpacity = 1.;
        self.contentView.layer.shadowOffset = CGSizeMake(0,0);
        self.contentView.layer.shadowRadius = 8.;
        self.contentView.layer.masksToBounds = NO;
        self.contentView.layer.rasterizationScale = 2.;
        self.contentView.layer.shouldRasterize = YES;
        self.contentView.layer.cornerRadius = 15;
        [self addSubview:self.contentView];
                
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityView.hidesWhenStopped = YES;
        activityView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        activityView.center = CGPointMake(self.contentView.frame.size.width/2, 
                                          self.contentView.frame.size.height/2);
        [activityView startAnimating];
        [self.contentView addSubview:activityView];
        self.contentView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        self.contentView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    }
    return self;
}

- (void)show
{
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState 
                     animations:^{
                         self.contentView.transform = CGAffineTransformIdentity;
                         self.alpha = 1;
                     } completion:nil];
}

- (void)hide
{
    [UIView animateWithDuration:0.2
                          delay:0 
                        options:UIViewAnimationOptionBeginFromCurrentState 
                     animations:^{
                         self.contentView.transform = CGAffineTransformMakeScale(1.5, 1.5);
                         self.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}
@end

@implementation UIView (WSLoading)

- (WSLoadingView*)wsFindLoadingView
{
    for(UIView *subview in self.subviews) {
        if([subview isKindOfClass:[WSLoadingView class]])
            return (WSLoadingView*)subview;
    }
    
    return nil;
}

- (void)hideLoading
{  
    WSLoadingView *loading = [self wsFindLoadingView];
    if(!loading)
        return;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:loading selector:@selector(show) object:nil];
    [loading hide];
}

- (void)showLoading
{
    [self showLoadingWithOffset:CGPointZero overlayColour:[UIColor clearColor]];
}


- (void)showLoadingWithOffset:(CGPoint)offset overlayColour:(UIColor *)colour
{
    WSLoadingView *loading = [self wsFindLoadingView];
    if(loading)
        return;
    
    loading = [[WSLoadingView alloc] initWithFrame:self.bounds];
    loading.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    loading.backgroundColor = colour;
    loading.frame = CGRectOffset(loading.frame, offset.x, offset.y);
    [self addSubview:loading];
    
    
    [loading performSelector:@selector(show) withObject:nil afterDelay:0.3];
    
    return;
}
@end

