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
#import "FBRequest.h"
#import "FBAPI.h"
#import "FSFindFriendViewController.h"
#import "FSUserModel.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"

@interface FSMeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *homePageBtn;
/**  */
@property (nonatomic, strong) FSUserModel *userModel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *zuoPinNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *focusNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansNumLabel;

@end

@implementation FSMeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    FBRequest *request2 = [FBAPI getWithUrlString:@"/user/profile" requestDictionary:nil delegate:self];
    [request2 startRequestSuccess:^(FBRequest *request, id result) {
        
        NSLog(@"个人信息 %@",result);
        NSDictionary *dict = result[@"data"];
        self.userModel = [[FSUserModel alloc] initWithDictionary:dict];
        [self.userModel update];
        
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.avatar.small] placeholderImage:[UIImage imageNamed:@"login_head_default"]];
        self.nameLabel.text = self.userModel.username;
        self.addressLabel.text = self.userModel.zone;
        self.summaryLabel.text = self.userModel.summary;
        self.zuoPinNumLabel.text = self.userModel.stuff_count;
        self.fansNumLabel.text = self.userModel.fans_count;
        self.focusNumLabel.text = self.userModel.follow_count;
        
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
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
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithImage:@"me_addFriend" highImage:nil title:nil target:self action:@selector(searchClick)];
    UIBarButtonItem *setItem = [UIBarButtonItem itemWithImage:@"me_set" highImage:nil title:nil target:self action:@selector(setClick)];
    self.navigationItem.rightBarButtonItem = setItem;
    self.navigationItem.leftBarButtonItem = searchItem;
}

-(void)searchClick{
    FSFindFriendViewController *vc = [[FSFindFriendViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setClick{
    FSSettingViewController *vc = [[FSSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
