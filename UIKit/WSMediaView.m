//
//  WSMediaView.m
//
//  Created by Ray Hilton on 8/06/12.
//  Copyright (c) 2012 Wirestorm Pty Ltd. All rights reserved.
//

#import "WSMediaView.h"
#import <QuartzCore/QuartzCore.h>

@interface WSFullScreenMediaViewController : UIViewController
@property (nonatomic, strong) WSMediaView *mediaView;
@property (nonatomic) BOOL wasStatusBarHidden;
@property (nonatomic) CGRect originalFrame;
@property (nonatomic, strong) UIView *originalParent;
@property (nonatomic, strong) UIView *backgroundView;
@end

@implementation WSFullScreenMediaViewController
@synthesize wasStatusBarHidden=_wasStatusBarHidden;
@synthesize mediaView=_mediaView;
@synthesize originalParent=_originalParent;
@synthesize originalFrame=_originalFrame;
@synthesize backgroundView=_backgroundView;

- (id)initWithMediaView:(WSMediaView*)mediaView
{
    self = [super init];
    if (self) {
        self.mediaView = mediaView;
        self.originalParent = mediaView.superview;
        self.originalFrame = mediaView.frame;
    }
    return self;
}

- (void)presentFullScreen
{
    UIView *rootView = [[[[[UIApplication sharedApplication] delegate] window] subviews] objectAtIndex:0];
    
    
    self.view.frame = rootView.bounds;
//    self.transform = window.transform;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideFullScreen)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;        
    [self.view addGestureRecognizer:tapGesture];
    
    self.backgroundView = [[UIView alloc] initWithFrame:rootView.bounds];
    self.backgroundView.backgroundColor = [UIColor blackColor];
    self.backgroundView.alpha = 0;
    [self.view addSubview:self.backgroundView];
    
    self.originalParent = self.mediaView.superview;
    self.originalFrame = self.mediaView.frame;
    self.mediaView.frame = [rootView convertRect:[self.mediaView convertRect:self.mediaView.frame toView:nil] fromView:nil];
    [self.view addSubview:self.mediaView];
    
    [rootView addSubview:self.view];
    
    self.wasStatusBarHidden = [[UIApplication sharedApplication] isStatusBarHidden];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.backgroundView.alpha = 1;
                         self.mediaView.frame = rootView.bounds;
                     }];
}

- (void)hideFullScreen
{
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
                         [self.view removeFromSuperview];
                     }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"Rotate image view to %d", toInterfaceOrientation);
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

- (NSURL *)url
{
    return self.originalUrl;
}

- (void)setUrl:(NSURL*)url
{
    if([self.originalUrl isEqual:url])
        return;
    
    self.webView.hidden = YES;
    self.imageView.hidden = YES;
    
    self.originalUrl = url;
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] 
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if(error)
                               {
                                   NSLog(@"Failed to download %@ because %@", url, error);
                                   [self.delegate mediaView:self didFailToLoad:url error:error];
                                   return;
                               }
                               
                               
                               NSHTTPURLResponse *httpresponse = (NSHTTPURLResponse*)response;
                               UIImage *image = [UIImage imageWithData:data];
                                if(image)
                                {
                                    // Show image
                                    self.imageView.image = image;
                                    self.imageView.hidden = NO;
                                    [self.delegate mediaView:self didFinishLoadingUrl:url];
                                }
                                else
                                {
                                    NSString *mimeType = [[httpresponse allHeaderFields] valueForKey:@"Content-Type"];
                                    [self.webView loadData:data MIMEType:mimeType textEncodingName:@"UTF-8" baseURL:nil];
                                }
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

- (void)presentFullScreen
{
//    WSFullScreenMediaViewController *fullScreenView = [[WSFullScreenMediaViewController alloc] initWithMediaView:self];
//    [fullScreenView presentFullScreen];
}

@end