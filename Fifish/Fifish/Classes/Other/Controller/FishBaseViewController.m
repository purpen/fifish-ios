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
    [self setNavBackColor:[UIColor whiteColor]];
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

-(void)setNavWithView:(UIView *)view{
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(40, 0, 90, 40)];
    titleView.backgroundColor = [UIColor yellowColor];
    [self.navigationController.navigationBar addSubview:titleView];
}
@end
