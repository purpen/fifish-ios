//
//  FSBaseViewController.m
//  Fifish
//
//  Created by THN-Dong on 2016/10/8.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSBaseViewController.h"
#import "FSUserModel.h"
#import "FSLoginViewController.h"

@interface FSBaseViewController ()

@end

@implementation FSBaseViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(BOOL)isLoginAndPresentLoginVc{
    FSUserModel *model = [[FSUserModel findAll] lastObject];
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
