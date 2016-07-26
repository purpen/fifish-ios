//
//  FSForgetPwdViewController.m
//  Fifish
//
//  Created by THN-Dong on 16/7/26.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSForgetPwdViewController.h"

@interface FSForgetPwdViewController ()

@end

@implementation FSForgetPwdViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

@end
