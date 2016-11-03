//
//  AppDelegate.m
//  Fifish
//
//  Created by THN-Dong on 16/7/25.
//  Copyright © 2016年 Dong. All rights reserved.
//

//app
//1.视频返回键不明显（户外完全看不清）
//2.录制 提醒框停留过久
//3.长时间使用  媒体菜单下 没有视频和图片显示（实际有录拍到）
//4.画面仍有卡顿出现
//5.需要加入方位箭头/2d显示
//6.rov低电量显示提醒
//7.led灯级别显示
//8.全部参数显示黑色时在户外看不清楚

#import "AppDelegate.h"
#import "FSTabBarController.h"
#import "IQKeyboardManager.h"
#import "GuidePageViewController.h"
#import "AppDelegate+FSGuide.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "FBAPI.h"
#import "FBRequest.h"
#import "SVProgressHUD.h"
#import "AppDelegate+FSUMRegiester.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置推送---------------------------------------------------
    //创建UIUserNotificationSettings，并设置消息的显示类类型
    UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
    [application registerUserNotificationSettings:notiSettings];
    //------------------------------------------------------
    [self setKeyBoard];
    [self windowShow];
    
    [[UITabBar appearance] setTranslucent:YES];
    [[UITabBar appearance] setBackgroundColor:[UIColor clearColor]];
    [[UITabBar appearance] setShadowImage:[self createImageWithColor:[UIColor colorWithHexString:@"#f8f8f8" alpha:1]]];
    [[UITabBar appearance] setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#f8f8f8" alpha:1]]];
    //----------------注册高德地图
    [AMapServices sharedServices].apiKey =@"7dd6c9292619fb6fbdf34a1f5993a5aa";
    //------------------注册友盟等社交平台
    [self regiesterUM];
    //------------------设置hud
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    return YES;
}

#pragma mark - 设置 U-Share SDK回调
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

#pragma mark - 强制竖屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

-(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(void)setKeyBoard{
    //  键盘事件
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //回到前台时刷新通知状态
    if (_notiDelegate && [_notiDelegate respondsToSelector:@selector(resetNotificationState)]) {
        [_notiDelegate resetNotificationState];
    }
    
    if (_reachDelegate && [_reachDelegate respondsToSelector:@selector(isReachAble)]) {
        [_reachDelegate isReachAble];
    }
    //更新Token
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    if (token.length != 0) {
        FBRequest *request = [FBAPI postWithUrlString:@"/auth/upToken" requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            [defaults setObject:result[@"data"][@"token"] forKey:@"token"];
            [defaults synchronize];
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
