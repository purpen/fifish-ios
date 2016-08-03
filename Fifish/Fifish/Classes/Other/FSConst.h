//
//  FSConst.h
//  Fifish
//
//  Created by THN-Dong on 16/7/25.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+FSExtension.h"

// API ROOT URL
#define kDomainBaseUrl @"http://m.taihuoniao.com/app/api"           //生产环境
//#define kDomainBaseUrl @"http://api.taihuoniao.com"             //  上线正式环境
//#define kDomainBaseUrl @"http://t.taihuoniao.com/app/api"     //  开发环境

//  屏幕宽
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
//  屏幕高
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width

#define DEFAULT_COLOR    [UIColor colorWithHexString:@"#4388D7"]

/** tabBar被选中的通知名字 */
UIKIT_EXTERN NSString * const FSTabBarDidSelectNotification;

#define kLocalKeyUUID         @"FB__UUID__"

#define KAppType              @"2"

#define kChannel              @"appstore"

#define kClientID             @"1415289600"
#define kClientSecret         @"545d9f8aac6b7a4d04abffe5"
