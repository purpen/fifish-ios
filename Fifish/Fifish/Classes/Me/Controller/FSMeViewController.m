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
        FSUserModel *userModel = [[FSUserModel findAll] lastObject];
        userModel = [FSUserModel mj_objectWithKeyValues:dict];
        userModel.isLogin = YES;
        [userModel saveOrUpdate];
        
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:userModel.large] placeholderImage:[UIImage imageNamed:@"login_head_default"]];
        self.nameLabel.text = userModel.username;
        self.addressLabel.text = userModel.zone;
        self.summaryLabel.text = userModel.summary;
        self.zuoPinNumLabel.text = userModel.stuff_count;
        self.fansNumLabel.text = userModel.fans_count;
        self.focusNumLabel.text = userModel.follow_count;
        
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
