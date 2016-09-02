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

@interface FSLoginViewController ()<FBRequestDelegate>

@property (weak, nonatomic) IBOutlet FSTextField *phoneTF;
@property (weak, nonatomic) IBOutlet FSTextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiXinBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiBoBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
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
        NSLog(@"错误 %@",error.localizedDescription);
        [SVProgressHUD dismiss];
    }];
}


////开始倒计时准备重新发送
//-(void)startTime{
//    __block int timeout = 30;//倒计时时间
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);//每秒执行
//    dispatch_source_set_event_handler(_timer, ^{
//        //倒计时结束，关闭
//        if (timeout <= 0) {
//            dispatch_source_cancel(_timer);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //时间到了后重新发送view消失
//                self.getCodeBtn_register.hidden = NO;
//                self.timeView.hidden = YES;
//            });
//        }//按钮显示剩余时间
//        else{
//            int seconds = timeout % 60;
//            NSString *strTime = [NSString stringWithFormat:@"%.2d",seconds];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [UIView beginAnimations:nil context:nil];
//                [UIView setAnimationDuration:1];
//                self.timeLabel.text = strTime;
//                [UIView commitAnimations];
//            });
//            timeout --;
//        }
//    });
//    dispatch_resume(_timer);
//}


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
        NSLog(@"用户登录  %@",result);
        
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        FSImproveViewController *vc = [[FSImproveViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"错误 %@",error.localizedDescription);
        [SVProgressHUD dismiss];
    }];

}
- (IBAction)weixinBtn:(UIButton *)sender {
}
- (IBAction)weiboBtn:(id)sender {
}
- (IBAction)qqBtn:(UIButton *)sender {
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
