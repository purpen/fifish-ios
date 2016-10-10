//
//  FishBlackNavViewController.m
//  Fifish
//
//  Created by macpro on 16/10/9.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FishBlackNavViewController.h"
#import "FSNavigationViewController.h"
@interface FishBlackNavViewController ()

@end

@implementation FishBlackNavViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavBackColor:FishBlackColor];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    
    FSNavigationViewController * nav = (FSNavigationViewController *)self.navigationController;
    [nav.backBtn setImage:[UIImage imageNamed:@"Nav_back_white"] forState:UIControlStateNormal];
    
}
@end
