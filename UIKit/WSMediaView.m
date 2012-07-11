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
@end

@implementation WSMediaView
@synthesize delegate=_delegate;
@synthesize originalUrl=_originalUrl;
@synthesize webView=_webView;
@synthesize imageView=_imageView;
@synthesize contentType=_contentType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor darkGrayColor];
                
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.hidden = YES;
        [self addSubview:self.imageView];
        
    }
    return self;
}

- (void)loadWebView
{
    if(self.webView)
        return;
    
    self.webView = [[UIWebView alloc] initWithFrame:self.bounds];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.hidden = YES;
    self.webView.userInteractionEnabled = NO;
    self.webView.scrollView.scrollsToTop = NO;
    [self addSubview:self.webView];
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

- (void)setImage:(UIImage*)image
{
    self.imageView.image = image;
    self.imageView.hidden = NO;
    self.webView.hidden = YES;
}

- (void)drawInnerRadialGradient:(CGContextRef)context rect:(CGRect)rect
{
    CGContextSaveGState(context);
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    
    CGFloat comps[] = { 0.0,0.0,0.0,0.0,
        0.0,0.0,0.0,1.0,
        0.0,0.0,0.0,1.0};
    CGFloat locs[] = {0,0.8,1};
    CGGradientRef g = CGGradientCreateWithColorComponents(space, comps, locs, 3);        
    CGPoint c = CGPointMake(rect.size.width/2, rect.size.height/2);
    
    //        CGMutablePathRef path = CGPathCreateMutable();
    //        CGPathMoveToPoint(path, NULL, c.x, 0);
    ////        CGPathAddLineToPoint(path, NULL, c.x, c.y-100);
    //        CGPathAddArcToPoint(path, NULL, self.frame.size.width, c.y, c.x+100, c.y, 100);
    //        CGPathAddLineToPoint(path, NULL, c.x, c.y);
    //        
    //        CGContextAddPath(context, path);
    //        CGContextClip(context);
    
    CGContextClipToRect(context, rect);
    CGContextDrawRadialGradient(context, g, c, 1.0f, c, 320.0f, 0);
    CGGradientRelease(g);
    CGColorSpaceRelease(space);
    
    CGContextRestoreGState(context);   
}

- (void)drawGlossOverlay:(CGContextRef)context rect:(CGRect)rect
{
    CGContextSaveGState(context);
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGFloat comps[] = { 1.0,1.0,1.0,0.0,
        1.0,1.0,1.0,0.6,
        1.0,1.0,1.0,0.0,
        1.0,1.0,1.0,0.0};
    CGFloat locs[] = {0,0.5,0.5001,1};
    CGGradientRef glossGradient = CGGradientCreateWithColorComponents(space, comps, locs, 4);        
    CGContextDrawLinearGradient(context, glossGradient, CGPointMake(0, 0), CGPointMake(rect.size.width, rect.size.height/2), 0);
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(space);
    
    CGContextRestoreGState(context);   
}

- (UIImage *)image
{
    if(self.imageView.hidden && !self.imageView.image)
    {
        
        // FIXME: make it look more like its a screen shot of a webview and not something to be interacted with
        BOOL wasHidden = self.webView.hidden;
        self.webView.hidden = NO;
        
        CGRect rect = CGRectMake(0, 0, self.webView.frame.size.width, self.webView.frame.size.height);
        UIGraphicsBeginImageContextWithOptions(rect.size, self.opaque, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.webView.layer renderInContext:context];
        
        
        // Draw radial gradient
        [self drawInnerRadialGradient:context rect:rect];  
        
        // Draw liner gradient
        [self drawGlossOverlay:context rect:rect];
        
        // Create an image from this drawing context
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.webView.hidden = wasHidden;
        return image;
    }
    else
    {
        return self.imageView.image;
    }
}

- (void)setUrl:(NSURL*)url
{
    if([self.originalUrl isEqual:url])
    {
        [self.delegate mediaView:self didFinishLoadingUrl:url];
        return;
    }
    
    
    self.webView.hidden = YES;
    self.webView = nil;
    self.imageView.hidden = YES;
    self.imageView.image = nil;
    self.originalUrl = url;
    
    if(!self.originalUrl)
    {
        return;
    }
                
    [[WSNetworkService sharedService] perform:@"GET" 
                                          url:url 
                                       modify:nil
                                      success:^(NSHTTPURLResponse *response, id object) 
     {
         /// If this isnt what we asked for, ignore...
         if(![response.URL isEqual:url])
             return;
         
         NSString *mimeType = [[response allHeaderFields] valueForKey:@"Content-Type"];
         if([mimeType hasPrefix:@"image/"]) 
         {
             self.contentType = WSMediaViewContentTypeImage;
             UIImage *image = [UIImage imageWithData:object];
             // Show image
             [self setImage:image];
             [self.delegate mediaView:self didFinishLoadingUrl:url];
         }
         else if([mimeType hasPrefix:@"audio/"])
         {
             self.contentType = WSMediaViewContentTypeAudio;
             [self loadWebView];
             [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
         }
         else if([mimeType hasPrefix:@"video/"]) 
         {
             self.contentType = WSMediaViewContentTypeVideo;
             [self loadWebView];
             [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
         }
         else 
         {
             self.contentType = WSMediaViewContentTypeOther;
             [self loadWebView];
             [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
             // We could still load this, but how to present a web page?
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
    
    if(self.contentType==WSMediaViewContentTypeOther) 
    {
        // Screen shot it and dont use the webview
        [self setImage:self.image];
        [self.delegate mediaView:self didFinishLoadingUrl:self.originalUrl];
    }
    else
    {
        self.webView.hidden = NO;
        [self.delegate mediaView:self didFinishLoadingUrl:self.originalUrl];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Failed to load %@", error);
    [self.delegate mediaView:self didFailToLoad:self.url error:error];
}

//- (void)presentFullScreen
//{
//    WSFullScreenMediaView *fullScreenView = [[WSFullScreenMediaView alloc] initWithMediaView:self];
//    [fullScreenView presentFullScreen];
//}

@end