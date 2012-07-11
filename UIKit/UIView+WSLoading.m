//
//  WSLoading.m
//  WSFoundation
//
//  Created by Ray Hilton on 8/12/11.
//  Copyright (c) 2011 Wirestorm Pty Ltd. All rights reserved.
//

#import "UIView+WSLoading.h"
#import <QuartzCore/QuartzCore.h>

@interface WSLoadingViewData : NSObject
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIColor *colour;
@property (nonatomic, assign) CGPoint offset;
@end

@implementation WSLoadingViewData
@synthesize text,colour, offset;
@end

@interface WSLoadingView : UIView
@property (nonatomic,strong) UIView *transformView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UILabel *loadingLabel;
@end

@implementation WSLoadingView
@synthesize transformView=_transformView;
@synthesize contentView=_contentView;
@synthesize loadingLabel=_loadingLabel;


- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        self.alpha = 0;
        self.backgroundColor = [UIColor clearColor]; //[UIColor colorWithWhite:0 alpha:0.5];
        
        self.transformView =  [[UIView alloc] initWithFrame:self.bounds];
        self.transformView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.transformView];

        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.contentView.backgroundColor = [UIColor colorWithWhite:0. alpha:0.3];
        self.contentView.layer.shadowColor = [UIColor colorWithWhite:0. alpha:0.5].CGColor;
        self.contentView.layer.shadowOpacity = 1.;
        self.contentView.layer.shadowOffset = CGSizeMake(0,0);
        self.contentView.layer.shadowRadius = 8.;
        self.contentView.layer.masksToBounds = NO;
        self.contentView.layer.rasterizationScale = 2.;
        self.contentView.layer.shouldRasterize = YES;
        self.contentView.layer.cornerRadius = 15;
        [self.transformView addSubview:self.contentView];
                
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityView.hidesWhenStopped = YES;
        activityView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        activityView.center = CGPointMake(15,15);
        [activityView startAnimating];
        [self.contentView addSubview:activityView];
        
        
        self.loadingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.loadingLabel.backgroundColor = [UIColor clearColor];
        self.loadingLabel.textColor = [UIColor whiteColor];
        self.loadingLabel.font = [UIFont boldSystemFontOfSize:11];
        self.loadingLabel.alpha = 0;
        [self.contentView addSubview:self.loadingLabel];
        
        self.contentView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        
        self.transformView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    }
    return self;
}

- (void)setText:(NSString*)text
{
    if([self.loadingLabel.text isEqualToString:text])
        return;
    
    self.loadingLabel.text = text;
    CGSize size = [self.loadingLabel.text sizeWithFont:self.loadingLabel.font constrainedToSize:CGSizeMake(INT32_MAX, 16)];

    [UIView animateWithDuration:0.3 animations:^{
        if(size.width>0)
        {
            self.loadingLabel.alpha = 1;
            CGFloat newWidth = 30 + 10 + size.width + 10;
            self.loadingLabel.frame = CGRectMake(35,0,size.width, self.contentView.frame.size.height);
            self.contentView.frame = CGRectMake((self.frame.size.width-newWidth)/2,
                                                self.contentView.frame.origin.y,
                                                newWidth, 
                                                self.contentView.frame.size.height);
        } 
        else 
        {
            self.loadingLabel.alpha = 0;
            self.loadingLabel.frame = CGRectMake(30,0,0, self.contentView.frame.size.height);
            self.contentView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);   
        }
    }];
}


- (void)show
{
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState 
                     animations:^{
                         self.transformView.transform = CGAffineTransformIdentity;
                         self.alpha = 1;
                     } completion:nil];
}

- (void)hide
{
    __weak id weakSelf = self;
    [UIView animateWithDuration:0.2
                          delay:0 
                        options:UIViewAnimationOptionBeginFromCurrentState 
                     animations:^{
                         self.transformView.transform = CGAffineTransformMakeScale(1.5, 1.5);
                         self.alpha = 0;
                     } completion:^(BOOL finished) {
                         __strong id strongSelf = weakSelf;
                         if(strongSelf)
                             [strongSelf removeFromSuperview];
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
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showLoadingActualWithData:) object:nil];
    WSLoadingView *loading = [self wsFindLoadingView];
    if(!loading)
        return;

    [loading hide];
}

- (void)showLoadingActualWithData:(WSLoadingViewData*)data
{
    WSLoadingView *loading = [self wsFindLoadingView];
    if(!loading)
    {
        loading = [[WSLoadingView alloc] initWithFrame:self.bounds];
        loading.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        loading.backgroundColor = data.colour;
        loading.frame = CGRectOffset(self.bounds, data.offset.x, data.offset.y);
        [self addSubview:loading];
    }
    
    [loading setText:data.text];
    [loading show];
}

- (void)showLoading
{
    [self showLoadingWithOffset:CGPointZero overlayColour:[UIColor clearColor] text:nil];
}

- (void)showLoadingWithText:(NSString*)text
{
    [self showLoadingWithOffset:CGPointZero overlayColour:[UIColor clearColor] text:text];
}

- (void)showLoadingWithOffset:( CGPoint)offset overlayColour:(UIColor *)colour text:(NSString *)text
{  
    WSLoadingViewData *data = [[WSLoadingViewData alloc] init];
    data.colour = colour;
    data.offset = offset;
    data.text = text;
    
    [self performSelector:@selector(showLoadingActualWithData:) withObject:data afterDelay:0.3];
    
    return;
}
@end

