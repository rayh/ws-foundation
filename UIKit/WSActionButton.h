//
//  WSActionButton.h
//
//  Created by Ray Hilton on 31/05/12.
//  Copyright (c) 2012 Wirestorm Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WSActionButtonStyleDefault = 0,
    WSActionButtonStylePrimary = 1,
    WSActionButtonStyleInfo    = 2,
    WSActionButtonStyleSuccess = 3,
    WSActionButtonStyleDanger  = 4,
    WSActionButtonStyleWarning = 5
} WSActionButtonStyle;

@interface WSActionButton : UIControl
@property (nonatomic, assign) WSActionButtonStyle tintStyle;
@property (nonatomic, assign) BOOL autoresizeWitdh;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) UIView *leftAccessoryView;
@property (nonatomic, assign) UIView *rightAccessoryView;
@property (nonatomic, assign) NSString *leftAccessoryLabel;
@property (nonatomic, assign) NSString *rightAccessoryLabel;

+ (WSActionButton*)buttonWithLabel:(NSString *)label style:(WSActionButtonStyle)style;
- (void)setTitle:(NSString *)title animated:(BOOL)animated;
- (void)setTintStyle:(WSActionButtonStyle)style;

@end
