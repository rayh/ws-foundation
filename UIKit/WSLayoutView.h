//
//  WSLayoutView.h
//
//  Created by Ray Hilton on 17/05/12.
//  Copyright (c) 2012 Wirestorm Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WSLayoutViewAlignmentLeft,
    WSLayoutViewAlignmentRight,
    WSLayoutViewAlignmentTop,
    WSLayoutViewAlignmentBottom
} WSLayoutViewAlignment;

@interface WSLayoutView : UIView
@property (nonatomic) WSLayoutViewAlignment alignment;
@property (nonatomic) CGFloat animationDuration;
@property (nonatomic) CGFloat padding;

+ (WSLayoutView*)layoutInFrame:(CGRect)rect
                         views:(NSArray*)views
                     alignment:(WSLayoutViewAlignment)alignment
                       padding:(CGFloat)padding;

+ (WSLayoutView*)layoutInFrame:(CGRect)rect
                         views:(NSArray*)views
                     alignment:(WSLayoutViewAlignment)alignment
                       padding:(CGFloat)padding
                      duration:(CGFloat)animationDuration;

@end
