//
//  WSLoading.h
//  WSFoundation
//
//  Created by Ray Hilton on 8/12/11.
//  Copyright (c) 2011 Wirestorm Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WSLoading)
- (void)wsHideLoading;
- (void)wsShowLoading;
@end

@interface WSLoading : UIView
@end
