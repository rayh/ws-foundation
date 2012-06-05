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
@property (nonatomic, retain) UIColor *tintColour;
@property (nonatomic, assign) BOOL autoresizeWitdh;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIView *leftAccessoryView;
@property (nonatomic, retain) UIView *rightAccessoryView;
@property (nonatomic, retain) NSString *leftAccessoryLabel;
@property (nonatomic, retain) NSString *rightAccessoryLabel;

+ (WSActionButton*)buttonWithLabel:(NSString *)label style:(WSActionButtonStyle)style;
- (void)setTitle:(NSString *)title animated:(BOOL)animated;
- (void)setTintStyle:(WSActionButtonStyle)style;

@end
