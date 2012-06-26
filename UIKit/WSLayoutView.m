//
//  WSLayoutView.m
//
//  Created by Ray Hilton on 17/05/12.
//  Copyright (c) 2012 Wirestorm Pty Ltd. All rights reserved.
//

#import "WSLayoutView.h"

@interface WSLayoutView () {
    CGSize _sizeOfContents;
}
@end

@implementation WSLayoutView
@synthesize alignment=_alignment;
@synthesize padding=_padding;
@synthesize animationDuration=_animationDuration;

+ (WSLayoutView*)layoutInFrame:(CGRect)rect 
                         views:(NSArray*)views
                     alignment:(WSLayoutViewAlignment)alignment
                       padding:(CGFloat)padding
{
    WSLayoutView *layoutView = [[WSLayoutView alloc] initWithFrame:rect];
    layoutView.animationDuration = 0;
    layoutView.padding = padding;
    layoutView.alignment = alignment;
    for(UIView *view in views) {
        [layoutView addSubview:view];
    }
    
    [layoutView updateSubviewPostions];
    return layoutView;
}

+ (WSLayoutView*)layoutInFrame:(CGRect)rect 
                       views:(NSArray*)views
                   alignment:(WSLayoutViewAlignment)alignment 
                     padding:(CGFloat)padding
                    duration:(CGFloat)animationDuration
{
    WSLayoutView *layoutView = [self layoutInFrame:rect views:views alignment:alignment padding:padding];
    layoutView.animationDuration = animationDuration;
    return layoutView;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.padding = 0.;
        self.animationDuration = 0.;
        self.alignment = WSLayoutViewAlignmentRight;
    }
    return self;
}

- (CGSize)sizeOfContents
{
    [self updateSubviewPostions];
    return _sizeOfContents;
}

//- (void)animateSubviewPositions
//{
//    [UIView animateWithDuration:self.animationDuration animations:^{
//        [self updateSubviewPostions];
//    }];
//}

- (void)updateSubviewPostions
{
    switch(self.alignment) 
    {
        case WSLayoutViewAlignmentRight:
        {
            // Start from the right
            CGFloat xOffset = self.frame.size.width;
            CGFloat width = 0;
            for(int i = self.subviews.count-1; i >=0; i--) {
                UIView *view = [self.subviews objectAtIndex:i];
                if(view.hidden || view.alpha == 0)
                    continue;
                
                CGFloat newXPos = xOffset - view.frame.size.width;
                view.frame = CGRectMake(newXPos, 
                                        view.frame.origin.y,
                                        view.frame.size.width, 
                                        view.frame.size.height);
                xOffset = view.frame.origin.x - self.padding;
                width+=view.frame.size.width+self.padding;
            }
            _sizeOfContents = CGSizeMake(width-self.padding, self.frame.size.height);
            break;
        }
            
        case WSLayoutViewAlignmentLeft:
        {
            CGFloat width = 0;
            for(UIView *view in self.subviews) {
                if(view.hidden || view.alpha == 0)
                    continue;
                
                view.frame = CGRectMake(width, 
                                        view.frame.origin.y,
                                        view.frame.size.width, 
                                        view.frame.size.height);
                
                width+=view.frame.size.width+self.padding;
            }
            _sizeOfContents = CGSizeMake(width-self.padding, self.frame.size.height);
            break;
        }
            
        case WSLayoutViewAlignmentTop:
        {
            CGFloat height = 0;
            for(UIView *view in self.subviews) {
                if(view.hidden || view.alpha == 0)
                    continue;
                
                view.frame = CGRectMake(view.frame.origin.x, 
                                        height,
                                        view.frame.size.width, 
                                        view.frame.size.height);
                height+=view.frame.size.height+self.padding;
            }
            _sizeOfContents = CGSizeMake(self.frame.size.width, height-self.padding);
            break;
        }
            
        case WSLayoutViewAlignmentBottom:
        {
            CGFloat yOffset = self.frame.size.height;
            CGFloat height = 0;
            for(int i = self.subviews.count-1; i >=0; i--) {
                UIView *view = [self.subviews objectAtIndex:i];
                if(view.hidden || view.alpha == 0)
                    continue;
                
                CGFloat newYPos = yOffset - view.frame.size.height;
                view.frame = CGRectMake(view.frame.origin.x, 
                                        newYPos,
                                        view.frame.size.width, 
                                        view.frame.size.height);
                yOffset = view.frame.origin.y - self.padding;
                height+=view.frame.size.height + self.padding;
            }
            _sizeOfContents = CGSizeMake(self.frame.size.width, height-self.padding);
            break;
        }
    }
}

- (void)layoutSubviews
{
    if(self.animationDuration>0)
    {
        [UIView animateWithDuration:self.animationDuration 
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState 
                         animations:^{
            [self updateSubviewPostions];
        } completion:nil];
    }
    else 
    {
        [self updateSubviewPostions];
    }
    
}
@end
