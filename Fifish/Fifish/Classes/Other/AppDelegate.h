//
//  AppDelegate.h
//  Fifish
//
//  Created by THN-Dong on 16/7/25.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NotificationDelege <NSObject>

@optional
- (void)resetNotificationState;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, weak) id<NotificationDelege> notiDelegate;

@end

