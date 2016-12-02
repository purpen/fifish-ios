//
//  FSBaseViewController.m
//  Fifish
//
//  Created by THN-Dong on 2016/10/8.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSBaseViewController.h"
#import "FSUserModel2.h"
#import "FSLoginViewController.h"
#import "UINavigationBar+FSExtension.h"

@interface FSBaseViewController ()

@end

@implementation FSBaseViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    UIColor *color = [UIColor colorWithHexString:@"#ffffff"];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar lt_setBackgroundColor:color];
    [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:1]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(BOOL)isLoginAndPresentLoginVc{
    FSUserModel2 *model = [[FSUserModel2 findAll] lastObject];
    if (model.isLogin) {
        //登录了，可以进行后续操作
        return YES;
    } else {
        FSLoginViewController *vc = [[FSLoginViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
        return NO;
    }
}

@end
