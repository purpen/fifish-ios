//
//  FSConst.h
//  Fifish
//
//  Created by THN-Dong on 16/7/25.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+FSExtension.h"
#import "LiveVideoSettingMacro.h"

//rov地址
UIKIT_EXTERN NSString * const ROVAddress;


typedef enum {
    FSZuoPinTypePicture = 1,
    FSZuoPinTypeVideo = 11
} FSZuoPinType;

// API ROOT URL
//#define kDomainBaseUrl @"http://fish.taihuoniao.com/api"           //生产环境
#define kDomainBaseUrl @"http://api.qysea.com"             //  上线正式环境
//#define kDomainBaseUrl @"http://t.taihuoniao.com/app/api"     //  开发环境

//  屏幕宽
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
//  屏幕高
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define KEY_WINDOW      [UIApplication sharedApplication].keyWindow//当前工程window

#define Nav_Height  64.0
#define Tab_Height  49.0

//图片编辑
#define ImageEditBottomBarHei  44.0

#pragma mark 颜色
#define DEFAULT_COLOR    [UIColor colorWithHexString:@"#2F8FFF"]
#define FishBlackColor   [UIColor colorWithHexString:@"#121F27"]

#define RANDOM_COLOR(a) [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:a]

/** tabBar被选中的通知名字 */
UIKIT_EXTERN NSString * const FSTabBarDidSelectNotification;

#define kLocalKeyUUID         @"FB__UUID__"

#define KAppType              @"2"

#define kChannel              @"appstore"

#define kClientID             @"1415289600"
#define kClientSecret         @"545d9f8aac6b7a4d04abffe5"


#define NSLog(s, ... ) NSLog(@"#%s##%d# %@",strrchr(__FILE__,'/'),__LINE__ , [NSString stringWithFormat:(s), ##__VA_ARGS__]);



