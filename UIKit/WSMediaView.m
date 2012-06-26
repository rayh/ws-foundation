//
//  WSMediaView.m
//
//  Created by Ray Hilton on 8/06/12.
//  Copyright (c) 2012 Wirestorm Pty Ltd. All rights reserved.
//

#import "WSMediaView.h"
#import <QuartzCore/QuartzCore.h>
#import "WSNetworkService.h"

@interface WSFullScreenMediaView : UIView
@property (nonatomic, strong) WSMediaView *mediaView;
@property (nonatomic) BOOL wasStatusBarHidden;
@property (nonatomic) CGRect originalFrame;
@property (nonatomic, strong) UIView *originalParent;
@property (nonatomic, strong) UIView *backgroundView;
@end

@implementation WSFullScreenMediaView
@synthesize wasStatusBarHidden=_wasStatusBarHidden;
@synthesize mediaView=_mediaView;
@synthesize originalParent=_originalParent;
@synthesize originalFrame=_originalFrame;
@synthesize backgroundView=_backgroundView;

- (id)initWithMediaView:(WSMediaView*)mediaView
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.mediaView = mediaView;
        self.originalParent = mediaView.superview;
        self.originalFrame = mediaView.frame;
    }
    return self;
}

#define DegreesToRadians(degrees) (degrees * M_PI / 180)

- (void)statusBarDidChangeFrame:(NSNotification *)notification {
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    switch (orientation) 
    {
        case UIInterfaceOrientationLandscapeLeft:
            self.transform =  CGAffineTransformMakeRotation(-DegreesToRadians(90));
            self.frame = CGRectMake(0,0, window.bounds.size.height, window.bounds.size.width);
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            self.frame = CGRectMake(0,0, window.bounds.size.height, window.bounds.size.width);
            self.transform = CGAffineTransformMakeRotation(DegreesToRadians(90));
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            self.frame = CGRectMake(0,0, window.bounds.size.width, window.bounds.size.height);
            self.transform = CGAffineTransformMakeRotation(DegreesToRadians(180));
            break;
            
        case UIInterfaceOrientationPortrait:
        default:
            self.frame = CGRectMake(0,0, window.bounds.size.width, window.bounds.size.height);
            self.transform =  CGAffineTransformMakeRotation(DegreesToRadians(0));
            break;
    }

}


- (void)presentFullScreen
{
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(statusBarDidChangeFrame:) 
                                                 name:UIApplicationDidChangeStatusBarFrameNotification 
                                               object:nil];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    self.frame = window.bounds;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideFullScreen)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;        
    [self addGestureRecognizer:tapGesture];
    
    self.backgroundView = [[UIView alloc] initWithFrame:window.bounds];
    self.backgroundView.backgroundColor = [UIColor blackColor];
    self.backgroundView.alpha = 0;
    [self addSubview:self.backgroundView];
    
    self.originalParent = self.mediaView.superview;
    self.originalFrame = self.mediaView.frame;
    self.mediaView.frame = [window convertRect:[self convertRect:self.mediaView.frame toView:nil] fromView:nil];
    [self addSubview:self.mediaView];
    
    [window addSubview:self];
    
    self.wasStatusBarHidden = [[UIApplication sharedApplication] isStatusBarHidden];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
//    [self statusBarDidChangeFrame:nil];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.backgroundView.alpha = 1;
                         self.mediaView.frame = window.bounds;
                     }];
}

- (void)hideFullScreen
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[UIApplication sharedApplication] setStatusBarHidden:self.wasStatusBarHidden withAnimation:UIStatusBarAnimationSlide];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGRect revertToFrame = [window convertRect:[self.originalParent convertRect:self.mediaView.frame toView:nil] fromView:nil];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.backgroundView.alpha = 0;
                         self.mediaView.frame = revertToFrame;
                     } completion:^(BOOL finished) {
                         [self.originalParent addSubview:self.mediaView];
                         self.mediaView.frame = self.originalFrame;
                         [self removeFromSuperview];
                     }];
}

@end

@interface WSMediaView () <UIWebViewDelegate>
@property (nonatomic, strong) NSURL *originalUrl;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation WSMediaView
@synthesize delegate=_delegate;
@synthesize originalUrl=_originalUrl;
@synthesize webView=_webView;
@synthesize imageView=_imageView;
@synthesize scrollView=_scrollView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor darkGrayColor];
        
        self.webView = [[UIWebView alloc] initWithFrame:self.bounds];
        self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.webView.delegate = self;
        self.webView.scalesPageToFit = YES;
        self.webView.hidden = YES;
        self.webView.userInteractionEnabled = NO;
        [self addSubview:self.webView];
        
//        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
//        self.scrollView.backgroundColor = [UIColor clearColor];
////        self.scrollView.delegate = self;
//        self.scrollView.maximumZoomScale = 4.;
//        self.scrollView.minimumZoomScale = 320./self.originalImageView.image.size.width; 
//        [self.view addSubview:self.scrollView];        
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.hidden = YES;
        [self addSubview:self.imageView];
        
    }
    return self;
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    self.webView.userInteractionEnabled = userInteractionEnabled;
}

- (BOOL)isUserInteractionEnabled
{
    return self.webView.userInteractionEnabled;
}

- (NSURL *)url
{
    return self.originalUrl;
}

- (void)setUrl:(NSURL*)url
{
    if([self.originalUrl isEqual:url])
    {
        [self.delegate mediaView:self didFinishLoadingUrl:url];
        return;
    }
    
    self.webView.hidden = YES;
    self.imageView.hidden = YES;
    
    self.originalUrl = url;
                
    [[WSNetworkService sharedService] fetchUrl:url 
                                        method:@"GET"
                                        modify:nil
                                       success:^(NSHTTPURLResponse *response, id object) 
    {
        UIImage *image = [UIImage imageWithData:object];
        if(image)
        {
            // Show image
            self.imageView.image = image;
            self.imageView.hidden = NO;
            [self.delegate mediaView:self didFinishLoadingUrl:url];
        }
        else
        {
            NSString *mimeType = [[response allHeaderFields] valueForKey:@"Content-Type"];
            [self.webView loadData:object MIMEType:mimeType textEncodingName:@"UTF-8" baseURL:nil];
        }
    } failure:^(NSError *error) {
        NSLog(@"Failed to download %@ because %@", url, error);
        [self.delegate mediaView:self didFailToLoad:url error:error];
    }];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *docTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"Loaded media with title: %@",docTitle);
    
    self.webView.hidden = NO;
    [self.delegate mediaView:self didFinishLoadingUrl:self.originalUrl];
}

//- (void)presentFullScreen
//{
//    WSFullScreenMediaView *fullScreenView = [[WSFullScreenMediaView alloc] initWithMediaView:self];
//    [fullScreenView presentFullScreen];
//}

@end