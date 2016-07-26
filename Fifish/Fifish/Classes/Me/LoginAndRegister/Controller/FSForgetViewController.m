//
//  FSForgetViewController.m
//  Fifish
//
//  Created by THN-Dong on 16/7/26.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSForgetViewController.h"

@interface FSForgetViewController ()

@end

@implementation FSForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

@end
