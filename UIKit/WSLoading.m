//
//  WSLoading.m
//  WSFoundation
//
//  Created by Ray Hilton on 8/12/11.
//  Copyright (c) 2011 Wirestorm Pty Ltd. All rights reserved.
//

#import "WSLoading.h"
#import <QuartzCore/QuartzCore.h>

@interface WSLoading ()
@property (nonatomic, retain) UIView *contentView;
@end

@implementation WSLoading
@synthesize contentView=contentView_;

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        self.contentView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 140, 80)] autorelease];
        self.contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        self.contentView.layer.cornerRadius = 4;
        [self addSubview:self.contentView];
        
        UILabel *loadingText = [[[UILabel alloc] 
                                 initWithFrame:CGRectMake(0, 
                                                          self.contentView.frame.size.height - 30, 
                                                          self.contentView.frame.size.width, 
                                                          20)] autorelease];
        loadingText.text = NSLocalizedString(@"Loading", nil);
        loadingText.backgroundColor = [UIColor clearColor];
        loadingText.textAlignment = UITextAlignmentCenter;
        loadingText.textColor = [UIColor colorWithWhite:1 alpha:0.9];
        loadingText.shadowColor = [UIColor colorWithWhite:0 alpha:0.8];
        loadingText.shadowOffset = CGSizeMake(-1, -1);
        [self.contentView addSubview:loadingText];
        
        UIActivityIndicatorView *activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
        activityView.hidesWhenStopped = YES;
        activityView.center = CGPointMake(self.contentView.frame.size.width/2, 
                                          10 + (activityView.frame.size.height/2));
        [activityView startAnimating];
        [self.contentView addSubview:activityView];
        
        
        
        self.contentView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        self.contentView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    }
    return self;
}

@end

@implementation UIView (WSLoading)

- (WSLoading*)wsFindLoadingView
{
    for(UIView *subview in self.subviews) {
        if([subview isKindOfClass:[WSLoading class]])
            return (WSLoading*)subview;
    }
    
    return nil;
}

- (void)wsHideLoading
{  
    WSLoading *loading = [self wsFindLoadingView];
    if(!loading)
        return;
    
    [UIView animateWithDuration:0.2
                          delay:0 
                        options:UIViewAnimationOptionBeginFromCurrentState 
                     animations:^{
                         loading.contentView.transform = CGAffineTransformMakeScale(1.5, 1.5);
                         loading.alpha = 0;
                     } completion:^(BOOL finished) {
                         [loading removeFromSuperview];
                     }];
}

- (void)wsShowLoading
{
    WSLoading *loading = [self wsFindLoadingView];
    if(loading)
        return;
    
    loading = [[[WSLoading alloc] initWithFrame:self.bounds] autorelease];
    [self addSubview:loading];
    
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState 
                     animations:^{
                         loading.contentView.transform = CGAffineTransformIdentity;
                         loading.alpha = 1;
                     } completion:^(BOOL finished) {
                         [self addSubview:loading];
                     }];
    
    return;
}

@end
