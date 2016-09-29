//
//  AppDelegate.h
//  Fifish
//
//  Created by THN-Dong on 16/7/25.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

//通知的代理
@protocol NotificationDelege <NSObject>

@optional
- (void)resetNotificationState;

@end

//连接WIFI的代理
@protocol reachableDelegate <NSObject>

@optional
-(void)isReachAble;

@end


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, weak) id<NotificationDelege> notiDelegate;
@property (nonatomic, weak) id<reachableDelegate> reachDelegate;

@end

