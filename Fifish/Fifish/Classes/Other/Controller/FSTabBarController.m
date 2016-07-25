//
//  FSTabBarController.m
//  Fifish
//
//  Created by THN-Dong on 16/7/25.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSTabBarController.h"
#import "FSHomeViewController.h"
#import "FSMediaViewController.h"
#import "FSEquipmentViewController.h"
#import "FSFoundViewController.h"
#import "FSMeViewController.h"
#import "FSTabBar.h"
#import "UIColor+FSExtension.h"
#import "FSNavigationViewController.h"
#import "FSLoginViewController.h"

@interface FSTabBarController ()<UITabBarControllerDelegate>

@end

@implementation FSTabBarController

+ (void)initialize
{
    // 通过appearance统一设置所有UITabBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#666666"];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#222222"];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    
    // 添加子控制器
    [self setupChildVc:[[FSHomeViewController alloc] init] title:@"首页" image:@"home" selectedImage:@"home_selected"];
    
    [self setupChildVc:[[FSMediaViewController alloc] init] title:@"媒体" image:@"media" selectedImage:@"media_selected"];
    
    [self setupChildVc:[[FSFoundViewController alloc] init] title:@"发现" image:@"found" selectedImage:@"found_selected"];
    
    [self setupChildVc:[[FSMeViewController alloc] init] title:@"我" image:@"me" selectedImage:@"me_selected"];
    
    // 更换tabBar
    [self setValue:[[FSTabBar alloc] init] forKeyPath:@"tabBar"];
}

/**
 * 初始化子控制器
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置文字和图片
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    
    // 包装一个导航控制器, 添加导航控制器为tabbarcontroller的子控制器
    FSNavigationViewController *nav = [[FSNavigationViewController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    //这里我判断的是当前点击的tabBarItem的标题
    if ([viewController.tabBarItem.title isEqualToString:@"我"]) {
        //如果没有登录
        if (0) {
            return YES;
        }else{
            //登录注册
            FSLoginViewController *vc = [[FSLoginViewController alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
            return NO;
        }
    }else {
        return YES;
    }
}

@end
