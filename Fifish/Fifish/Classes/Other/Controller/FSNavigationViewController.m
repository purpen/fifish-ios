//
//  FSNavigationViewController.m
//  Fifish
//
//  Created by THN-Dong on 16/7/25.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSNavigationViewController.h"
#import "UIView+FSExtension.h"
#import <objc/runtime.h>

@interface FSNavigationViewController ()<UIGestureRecognizerDelegate>

@end

@implementation FSNavigationViewController

/**
 * 当第一次使用这个类的时候会调用一次
 */
+ (void)initialize
{
    // 当导航栏用在XMGNavigationController中, appearance设置才会生效
    //    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
//    UINavigationBar *bar = [UINavigationBar appearance];
//    [bar setBackgroundImage:[UIImage imageNamed:@"navi_bg"] forBarMetrics:UIBarMetricsDefault];
//    [bar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]}];
    
//    // 设置item
//    UIBarButtonItem *item = [UIBarButtonItem appearance];
//    // UIControlStateNormal
//    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
//    itemAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
//    itemAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
//    [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
//    // UIControlStateDisabled
//    NSMutableDictionary *itemDisabledAttrs = [NSMutableDictionary dictionary];
//    itemDisabledAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
//    [item setTitleTextAttributes:itemDisabledAttrs forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    
    // 如果滑动移除控制器的功能失效，清空代理(让导航控制器重新设置这个功能)
//    self.interactivePopGestureRecognizer.delegate = nil;
    
    
    // 防止手势冲突
    self.interactivePopGestureRecognizer.enabled = NO;
//    NSArray *targets = [self.interactivePopGestureRecognizer valueForKeyPath:@"_targets"];
//    
//    id objc = [targets firstObject];
    
//    id target = [objc valueForKeyPath:@"_target"];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    
    pan.delegate = self;
    
    [self.view addGestureRecognizer:pan];
}

#pragma mark - 手势代理方法
// 是否开始触发手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 判断下当前控制器是否是跟控制器
    
    return (self.topViewController != [self.viewControllers firstObject]);
}

/**
 * 可以在这个方法中拦截所有push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) { // 如果push进来的不是第一个控制器
        self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setTitle:@"返回" forState:UIControlStateNormal];
        [self.backBtn setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
//        button.size = CGSizeMake(70, 30);
        // 让按钮内部的所有内容左对齐
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.backBtn sizeToFit];
        // 让按钮的内容往左边偏移10
//        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [self.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        // 修改导航栏左边的item
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
        
        // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    // 这句super的push要放在后面, 让viewController可以覆盖上面设置的leftBarButtonItem
    [super pushViewController:viewController animated:animated];
    
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

@end
