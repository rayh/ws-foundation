#import <UIKit/UIKit.h>

typedef enum {
    WSActionButtonStyleDefault = 0,
    WSActionButtonStylePrimary = 1,
    WSActionButtonStyleInfo    = 2,
    WSActionButtonStyleSuccess = 3,
    WSActionButtonStyleDanger  = 4,
    WSActionButtonStyleWarning = 5,
    WSActionButtonStyleCustom
} WSActionButtonStyle;

typedef enum {
    WSActionButtonTextLight,
    WSActionButtonTextDark,
} WSActionButtonText;

@interface WSActionButton : UIControl
@property (nonatomic, assign) UIEdgeInsets contentInsets;
@property (nonatomic, readwrite) UIColor *tintColour;
@property (nonatomic, readwrite) UIColor *selectedColour;
@property (nonatomic, assign) BOOL autoresizeWidth;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *leftAccessoryView;
@property (nonatomic, strong) UIView *rightAccessoryView;
@property (nonatomic, strong) NSString *leftAccessoryLabel;
@property (nonatomic, strong) NSString *rightAccessoryLabel;
@property (nonatomic) NSString *title;

+ (WSActionButton*)buttonWithLabel:(NSString *)label style:(WSActionButtonStyle)style;
+ (WSActionButton*)buttonWithLabel:(NSString *)label colour:(UIColor*)colour textStyle:(WSActionButtonText)textStyle;
- (void)setTitle:(NSString *)title animated:(BOOL)animated;

@end
