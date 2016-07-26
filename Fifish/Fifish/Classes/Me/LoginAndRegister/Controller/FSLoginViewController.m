//
//  FSLoginViewController.m
//  Fifish
//
//  Created by THN-Dong on 16/7/25.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSLoginViewController.h"
#import "FSTextField.h"
#import "FSRegisterViewController.h"
#import "FSForgetPwdViewController.h"

@interface FSLoginViewController ()

@property (weak, nonatomic) IBOutlet FSTextField *phoneTF;
@property (weak, nonatomic) IBOutlet FSTextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiXinBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiBoBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerNowBtn;

@end

@implementation FSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    FSForgetPwdViewController *vc = [[FSForgetPwdViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)loginBtn:(UIButton *)sender {
}
- (IBAction)weixinBtn:(UIButton *)sender {
}
- (IBAction)weiboBtn:(id)sender {
}
- (IBAction)qqBtn:(UIButton *)sender {
}
- (IBAction)registerNowBtn:(UIButton *)sender {
}

@end
