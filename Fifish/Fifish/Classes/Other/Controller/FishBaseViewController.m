//
//  FishBaseViewController.m
//  Fifish
//
//  Created by macpro on 16/8/15.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FishBaseViewController.h"

@implementation FishBaseViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    nav颜色
    [self setNavBackColor:[UIColor whiteColor]];
    
//    标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];
    self.navigationController.navigationBar.translucent = YES;
}
- (void)setNavBackColor:(UIColor *)backColor{
    self.navigationController.navigationBar.barTintColor = backColor;
//    self.navigationController.hidesBarsOnTap = YES;
}
- (void)setRightItem:(UIView *)view
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItems = @[rightItem];
}

-(void)setLeftItem:(UIView *)view{
    UIBarButtonItem *LeftItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.leftBarButtonItems = @[LeftItem];
}

-(void)setNavWithView:(UIView *)view{
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(40, 0, 90, 40)];
    titleView.backgroundColor = [UIColor yellowColor];
    [self.navigationController.navigationBar addSubview:titleView];
}
@end
