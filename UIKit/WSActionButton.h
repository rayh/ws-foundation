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
@property (nonatomic, strong) UIColor *tintColour;
@property (nonatomic, assign) BOOL autoresizeWidth;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *leftAccessoryView;
@property (nonatomic, strong) UIView *rightAccessoryView;
@property (nonatomic, strong) NSString *leftAccessoryLabel;
@property (nonatomic, strong) NSString *rightAccessoryLabel;
@property (nonatomic) NSString *title;

+ (WSActionButton*)buttonWithLabel:(NSString *)label style:(WSActionButtonStyle)style;
- (void)setTitle:(NSString *)title animated:(BOOL)animated;
- (void)setTintStyle:(WSActionButtonStyle)style;

@end
