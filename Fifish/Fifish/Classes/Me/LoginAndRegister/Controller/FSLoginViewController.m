//
//  FSLoginViewController.m
//  Fifish
//
//  Created by THN-Dong on 16/7/25.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSLoginViewController.h"
#import "FSTextField.h"
#import "FSForgetViewController.h"
#import "UIView+FSExtension.h"
#import "NSString+Helper.h"
#import "SVProgressHUD.h"
#import "FSImproveViewController.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "FSUserModel.h"
#import <UMSocialCore/UMSocialCore.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>

@interface FSLoginViewController ()<FBRequestDelegate>

@property (weak, nonatomic) IBOutlet FSTextField *phoneTF;
@property (weak, nonatomic) IBOutlet FSTextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *facebookBtn;
@property (weak, nonatomic) IBOutlet UIButton *instagramBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiXinBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerNowBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeft;
@property (weak, nonatomic) IBOutlet FSTextField *pwd_register;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn_register;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet FSTextField *phone_register;
@property (weak, nonatomic) IBOutlet FSTextField *codeTF;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@end

@implementation FSLoginViewController


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.registerBtn addTarget:self action:@selector(clickRegisterBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.timeView.layer.masksToBounds = YES;
    self.timeView.layer.cornerRadius = 20;
    [self judge];
}

#pragma mark -判断手机是否安装了相应的客户端
-(void)judge{
    //隐藏未安装的第三方登录平台
    if ([WXApi isWXAppInstalled] == FALSE) {
        self.weiXinBtn.hidden = true;
    }
}


-(void)clickRegisterBtn:(UIButton*)sender{
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    if (![_phone_register.text isValidateEmail]) {
        [SVProgressHUD showInfoWithStatus:@"邮箱格式不正确"];
        return;
    }
    if (_pwd_register.text.length < 6) {
        [SVProgressHUD showInfoWithStatus:@"密码不得少于6位"];
        return;
    }
    //进行网络请求
    FBRequest *request = [FBAPI postWithUrlString:@"/auth/register" requestDictionary:@{
                                                                                        @"account" : self.phone_register.text,
                                                                                        @"password" : self.pwd_register.text
                                                                                        } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        [SVProgressHUD showSuccessWithStatus:@"注册成功"];
        [self registerNowBtn:self.registerBtn];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)cancelBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)forgetBtn:(UIButton *)sender {
    FSForgetViewController *vc = [[FSForgetViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)loginBtn:(UIButton *)sender {
    //进行网络请求
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    if (![_phoneTF.text isValidateEmail]) {
        [SVProgressHUD showInfoWithStatus:@"邮箱格式不正确"];
        return;
    }
    if (_pwdTF.text.length < 6) {
        [SVProgressHUD showInfoWithStatus:@"密码不得少于6位"];
        return;
    }
    //进行网络请求
    FBRequest *request = [FBAPI postWithUrlString:@"/auth/login" requestDictionary:@{
                                                                                        @"account" : self.phoneTF.text,
                                                                                        @"password" : self.pwdTF.text
                                                                                        } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSInteger first_login = [result[@"data"][@"first_login"] integerValue];
        NSString *token = result[@"data"][@"token"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
       [defaults setObject:token forKey:@"token"];
       [defaults synchronize];
        FSUserModel *model = [[FSUserModel alloc] init];
        model.isLogin = YES;
        [model saveOrUpdate];
        [SVProgressHUD showSuccessWithStatus:@"登录成功" maskType:SVProgressHUDMaskTypeNone];
        if (first_login == 0) {
            FSImproveViewController *vc = [[FSImproveViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
    }];

}

- (IBAction)facebookClick:(id)sender {
    [[UMSocialManager defaultManager] authWithPlatform:UMSocialPlatformType_Facebook currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialAuthResponse *resp = result;
            
            // 授权信息
            NSLog(@"Facebook uid: %@", resp.uid);
            NSLog(@"Facebook accessToken: %@", resp.accessToken);
            NSLog(@"Facebook expiration: %@", resp.expiration);
            
            // 第三方平台SDK源数据
            NSLog(@"Facebook originalResponse: %@", resp.originalResponse);
            [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Facebook currentViewController:nil completion:^(id result, NSError *error) {
                if (error) {
                    
                } else {
                    UMSocialUserInfoResponse *resp = result;
                    
                    // 授权信息
                    NSLog(@"Facebook uid: %@", resp.uid);
                    NSLog(@"Facebook accessToken: %@", resp.accessToken);
                    NSLog(@"Facebook expiration: %@", resp.expiration);
                    
                    // 用户信息
                    NSLog(@"Facebook name: %@", resp.name);
                    
                    // 第三方平台SDK源数据
                    NSLog(@"Facebook originalResponse: %@", resp.originalResponse);
                }
            }];
        }
    }];
}

- (IBAction)instagramClick:(id)sender {
    [[UMSocialManager defaultManager] authWithPlatform:UMSocialPlatformType_Instagram currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialAuthResponse *resp = result;
            
            // 授权信息
            NSLog(@"Facebook uid: %@", resp.uid);
            NSLog(@"Facebook accessToken: %@", resp.accessToken);
            NSLog(@"Facebook expiration: %@", resp.expiration);
            
            // 第三方平台SDK源数据
            NSLog(@"Facebook originalResponse: %@", resp.originalResponse);
            [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Instagram currentViewController:nil completion:^(id result, NSError *error) {
                if (error) {
                    
                } else {
                    UMSocialUserInfoResponse *resp = result;
                    
                    // 授权信息
                    NSLog(@"Facebook uid: %@", resp.uid);
                    NSLog(@"Facebook accessToken: %@", resp.accessToken);
                    NSLog(@"Facebook expiration: %@", resp.expiration);
                    
                    // 用户信息
                    NSLog(@"Facebook name: %@", resp.name);
                    
                    // 第三方平台SDK源数据
                    NSLog(@"Facebook originalResponse: %@", resp.originalResponse);
                }
            }];
        }
    }];
}

- (IBAction)weixinClick:(id)sender {
    [[UMSocialManager defaultManager]  authWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
        UMSocialAuthResponse *authresponse = result;
        NSString *message = [NSString stringWithFormat:@"result: %d\n uid: %@\n accessToken: %@\n",(int)error.code,authresponse.uid,authresponse.accessToken];
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
            UMSocialUserInfoResponse *userinfo =result;
            NSString *message2 = [NSString stringWithFormat:@"name: %@\n icon: %@\n gender: %@\n",userinfo.name,userinfo.iconurl,userinfo.gender];
        }];
    }];
}

- (IBAction)registerNowBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.tipLabel.text = @"已有帐号?";
    }else{
        self.tipLabel.text = @"还没有帐号?";
    }
    // 退出键盘
    [self.view endEditing:YES];
    
    if (self.loginViewLeft.constant == 0) { // 显示注册界面
        self.loginViewLeft.constant = - self.view.width;
        
    } else { // 显示登录界面
        self.loginViewLeft.constant = 0;
        
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
