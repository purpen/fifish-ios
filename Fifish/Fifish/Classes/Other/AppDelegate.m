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
#import "FSUserModel.h"
#import "JPUSHService.h"
#import "FSMeViewController.h"
#import "FSMessageViewController.h"
//#import "FSRecivedPriaseViewController.h"
//#import "FSCommentViewController.m"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate () <JPUSHRegisterDelegate>

@end

@implementation AppDelegate

- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}


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
    //-----------------极光推送
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    [JPUSHService setupWithOption:launchOptions appKey:@"d5fd66f4c503b47e633a8d66"
                          channel:@"App Store"
                 apsForProduction:0
            advertisingIdentifier:nil];
    
    if (launchOptions) {
        //点击了推送消息
        NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if(remoteNotification) {
            // 如果​remoteNotification不为空，代表有推送发过来
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            [[FSTabBarController sharedManager] setSelectedIndex:3];
        }
    }
    FBRequest *request = [FBAPI getWithUrlString:@"/me/alertCount" requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dataDict = result[@"data"];
        FSMeViewController *requiredViewController = [[FSTabBarController sharedManager].viewControllers objectAtIndex:3];
        UITabBarItem *item = requiredViewController.tabBarItem;
        NSInteger count = ([dataDict[@"alert_comment_count"] integerValue] + [dataDict[@"alert_like_count"] integerValue] + [dataDict[@"alert_fans_count"] integerValue]);
        if (count == 0) {
            item.badgeValue = nil;
        } else {
            [item setBadgeValue:[NSString stringWithFormat:@"%ld", (long)count]];
        }
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
    
    return YES;
}

-(void)goToMssageViewControllerWith:(NSDictionary*)userinfo{
    [[FSTabBarController sharedManager] setSelectedIndex:3];
    FSMessageViewController *vc = [[FSMessageViewController alloc] init];
    [self.window.rootViewController.childViewControllers[3] pushViewController:vc animated:YES];
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
    FSUserModel *userModel = [[FSUserModel findAll] lastObject];
    if (userModel.isLogin) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [defaults objectForKey:@"token"];
        FBRequest *request = [FBAPI postWithUrlString:@"/auth/upToken" requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            [defaults setObject:result[@"data"][@"token"] forKey:@"token"];
            [defaults synchronize];
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    }
    
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

#pragma mark - 注册APNs成功并上报DeviceToken
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [JPUSHService registerDeviceToken:deviceToken];
#warning 这里，发送网络请求，把该用户的ID和该token发送到自己的服务器，建立关系，当需要发送消息的时候，服务器就可以查表获得token，并且发送相应的消息到APNs，让APNs去推送。
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


#pragma mark - 收到远程通知
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
        FBRequest *request = [FBAPI getWithUrlString:@"/me/alertCount" requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            NSDictionary *dataDict = result[@"data"];
            FSMeViewController *requiredViewController = [[FSTabBarController sharedManager].viewControllers objectAtIndex:3];
            UITabBarItem *item = requiredViewController.tabBarItem;
            NSInteger count = ([dataDict[@"alert_comment_count"] integerValue] + [dataDict[@"alert_like_count"] integerValue] + [dataDict[@"alert_fans_count"] integerValue]);
            if (count == 0) {
                item.badgeValue = nil;
            } else {
                [item setBadgeValue:[NSString stringWithFormat:@"%ld", (long)count]];
            }
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
        NSLog(@"iOS10以下 前台收到远程通知:%@", [self logDic:userInfo]);
    }
    completionHandler(UIBackgroundFetchResultNewData);
    if (userInfo){
        [self goToMssageViewControllerWith:userInfo];
    }
}


#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        FBRequest *request = [FBAPI getWithUrlString:@"/me/alertCount" requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            NSDictionary *dataDict = result[@"data"];
            FSMeViewController *requiredViewController = [[FSTabBarController sharedManager].viewControllers objectAtIndex:3];
            UITabBarItem *item = requiredViewController.tabBarItem;
            NSInteger count = ([dataDict[@"alert_comment_count"] integerValue] + [dataDict[@"alert_like_count"] integerValue] + [dataDict[@"alert_fans_count"] integerValue]);
            if (count == 0) {
                item.badgeValue = nil;
            } else {
                [item setBadgeValue:[NSString stringWithFormat:@"%ld", (long)count]];
            }
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        [self goToMssageViewControllerWith:userInfo];
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif


@end
