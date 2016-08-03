//
//  FSMeViewController.m
//  Fifish
//
//  Created by THN-Dong on 16/7/25.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSMeViewController.h"
#import "UIBarButtonItem+FSExtension.h"
#import "UIColor+FSExtension.h"
#import "FSSettingViewController.h"
#import "FSHomePageViewController.h"

@interface FSMeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *homePageBtn;

@end

@implementation FSMeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 40;
    self.headImageView.layer.borderWidth = 2;
    self.headImageView.layer.borderColor = [UIColor colorWithHexString:@"#F1F1F1"].CGColor;
    
    [self.homePageBtn addTarget:self action:@selector(clickHomePageBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickHomePageBtn:(UIButton*)sender{
    FSHomePageViewController *vc = [[FSHomePageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setupNav{
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithImage:@"me_search" highImage:nil target:self action:@selector(searchClick)];
    UIBarButtonItem *setItem = [UIBarButtonItem itemWithImage:@"me_set" highImage:nil target:self action:@selector(setClick)];
    self.navigationItem.rightBarButtonItem = setItem;
    self.navigationItem.leftBarButtonItem = searchItem;
}

-(void)searchClick{
    
}

-(void)setClick{
    FSSettingViewController *vc = [[FSSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
