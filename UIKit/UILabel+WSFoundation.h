//
//  UILabel+WSFoundation.h
//
//  Created by Ray Hilton on 5/06/12.
//  Copyright (c) 2012 Wirestorm Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (WSFoundation)
- (void)setTextAndAdjustWidth:(NSString *)text;
+ (UILabel*)labelWithFrame:(CGRect)frame font:(UIFont*)font colour:(UIColor*)colour text:(NSString*)text;
@end
