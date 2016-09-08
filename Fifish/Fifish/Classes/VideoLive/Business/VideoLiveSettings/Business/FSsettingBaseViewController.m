//
//  FSsettingBaseViewController.m
//  Fifish
//
//  Created by macpro on 16/9/7.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSsettingBaseViewController.h"

@interface FSsettingBaseViewController ()

@end

@implementation FSsettingBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor],NSForegroundColorAttributeName,
                                                                     [UIFont systemFontOfSize:16],NSFontAttributeName,nil]];
}
- (void)setdissMissBtn
{
    UIButton * dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissBtn.frame = CGRectMake(0, 0, 15,15);
    [dismissBtn setImage:[UIImage imageNamed:@"VideoSetting_cancel"] forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(dissmissClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:dismissBtn];
//    self.navigationItem.rightBarButtonItems = @[rightItem];
    [self setRightItem:dismissBtn];
}

- (void)dissmissClick{
    [self.navigationController.parentViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
