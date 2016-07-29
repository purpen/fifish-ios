//
//  FSConst.h
//  Fifish
//
//  Created by THN-Dong on 16/7/25.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+FSExtension.h"
//  屏幕宽
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
//  屏幕高
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width

#define DEFAULT_COLOR    [UIColor colorWithHexString:@"#4388D7"]

/** tabBar被选中的通知名字 */
UIKIT_EXTERN NSString * const FSTabBarDidSelectNotification;
