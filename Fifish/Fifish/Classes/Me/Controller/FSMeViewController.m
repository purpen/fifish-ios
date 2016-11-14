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
#import "FSUserModel.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "FSPraisedViewController.h"
#import "FSMessageViewController.h"
#import "FSTabBarController.h"
#import "OptionViewController.h"

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
@property (weak, nonatomic) IBOutlet UIImageView *addressIcon;

@end

@implementation FSMeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    FBRequest *request = [FBAPI getWithUrlString:@"/me/alertCount" requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dataDict = result[@"data"];
        FSMeViewController *requiredViewController = [[FSTabBarController sharedManager].viewControllers objectAtIndex:3];
        UITabBarItem *item = requiredViewController.tabBarItem;
        NSInteger count = ([dataDict[@"alert_comment_count"] integerValue] + [dataDict[@"alert_like_count"] integerValue] + [dataDict[@"alert_fans_count"] integerValue]);
        if (count == 0) {
            item.badgeValue = nil;
        } else {
            [item setBadgeValue:[NSString stringWithFormat:@"%ld", (long)count]];
        }
    } failure:^(FBRequest *request, NSError *error) {
        
    }];

    
    FBRequest *request2 = [FBAPI getWithUrlString:@"/me/profile" requestDictionary:nil delegate:self];
    [request2 startRequestSuccess:^(FBRequest *request, id result) {

        NSDictionary *dict = result[@"data"];
        FSUserModel *userModel = [[FSUserModel findAll] lastObject];
        userModel = [FSUserModel mj_objectWithKeyValues:dict];
        userModel.isLogin = YES;
        [userModel saveOrUpdate];
        
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:userModel.large] placeholderImage:[UIImage imageNamed:@"login_head_default"]];
        NSLog(@"头像  %@",userModel.large);
        self.nameLabel.text = userModel.username;
        self.addressLabel.text = userModel.zone;
        if (self.addressLabel.text.length == 0) {
            self.addressIcon.hidden = YES;
        }
        self.summaryLabel.text = userModel.summary;
        self.zuoPinNumLabel.text = userModel.stuff_count;
        self.fansNumLabel.text = userModel.fans_count;
        self.focusNumLabel.text = userModel.follow_count;
        
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

- (IBAction)praisedClick:(id)sender {
    FSPraisedViewController *vc = [[FSPraisedViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)messageClick:(id)sender {
    FSMessageViewController *vc = [[FSMessageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setupNav];
    
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 45;
    self.headImageView.layer.borderWidth = 2;
    self.headImageView.layer.borderColor = [UIColor colorWithHexString:@"#F1F1F1"].CGColor;
    
    [self.homePageBtn addTarget:self action:@selector(clickHomePageBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickHomePageBtn:(UIButton*)sender{
    FSHomePageViewController *vc = [[FSHomePageViewController alloc] init];
    FSUserModel *userModel = [[FSUserModel findAll] lastObject];
    vc.userId = userModel.userId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)feedBackClick:(id)sender {
    OptionViewController *vc = [[OptionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//-(void)setupNav{
//    UIBarButtonItem *setItem = [UIBarButtonItem itemWithImage:@"me_set" highImage:nil title:nil target:self action:@selector(setClick)];
//    self.navigationItem.rightBarButtonItem = setItem;
//}

- (IBAction)settingClick:(id)sender {
    FSSettingViewController *vc = [[FSSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
