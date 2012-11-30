//
//  UILabel+WSFoundation.m
//
//  Created by Ray Hilton on 5/06/12.
//  Copyright (c) 2012 Wirestorm Pty Ltd. All rights reserved.
//

#import "UILabel+WSFoundation.h"

@implementation UILabel (WSFoundation)
+ (UILabel*)labelWithFont:(UIFont*)font colour:(UIColor*)colour text:(NSString*)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = colour;    
    label.text = text;
    return label;
}

- (void)setTextAndAdjustWidth:(NSString *)text
{
    CGSize size = [text sizeWithFont:self.font
                   constrainedToSize:CGSizeMake(INT32_MAX, self.frame.size.height)];
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            size.width,
                            self.frame.size.height);
    [self setText:text];
}

- (void)setTextAndAdjustHeight:(NSString *)text
{
    self.text = text;
    CGSize size = [text sizeWithFont:self.font
                   constrainedToSize:CGSizeMake(self.frame.size.width, INT32_MAX)];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.height);
}
@end
