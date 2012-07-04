//
//  WSMediaView.h
//
//  Created by Ray Hilton on 8/06/12.
//  Copyright (c) 2012 Wirestorm Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class WSMediaView;

typedef enum {
    WSMediaViewContentTypeVideo,
    WSMediaViewContentTypeAudio,
    WSMediaViewContentTypeImage,
    WSMediaViewContentTypeOther,
} WSMediaViewContentType;

@protocol WSMediaViewDelegate <NSObject>
- (void)mediaView:(WSMediaView*)mediaView didFinishLoadingUrl:(NSURL*)url;
- (void)mediaView:(WSMediaView*)mediaView didFailToLoad:(NSURL*)url error:(NSError*)error;
@end

@interface WSMediaView : UIView
@property (nonatomic) WSMediaViewContentType contentType;;
@property (nonatomic, weak) id <WSMediaViewDelegate> delegate;
@property (nonatomic) NSURL *url;
@property (nonatomic) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;

//- (void)presentFullScreen;
@end