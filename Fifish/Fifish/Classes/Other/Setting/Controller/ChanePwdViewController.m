//
//  ChanePwdViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/5/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ChanePwdViewController.h"
#import "SVProgressHUD.h"

@interface ChanePwdViewController ()
@property (weak, nonatomic) IBOutlet UIView *oldPwdView;
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIView *confirmView;
@property (weak, nonatomic) IBOutlet UITextField *confirmTF;

@end


@implementation ChanePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改密码";
    
    //
    self.pwdView.layer.masksToBounds = YES;
    self.pwdView.layer.cornerRadius = 2;
    self.pwdView.layer.borderColor = [UIColor colorWithHexString:@"#ededed"].CGColor;
    self.pwdView.layer.borderWidth = 1;
    self.oldPwdView.layer.masksToBounds = YES;
    self.oldPwdView.layer.cornerRadius = 2;
    self.oldPwdView.layer.borderColor = [UIColor colorWithHexString:@"#ededed"].CGColor;
    self.oldPwdView.layer.borderWidth = 1;
    self.confirmView.layer.masksToBounds = YES;
    self.confirmView.layer.cornerRadius = 2;
    self.confirmView.layer.borderColor = [UIColor colorWithHexString:@"#ededed"].CGColor;
    self.confirmView.layer.borderWidth = 1;
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.cornerRadius = 2;
}


- (IBAction)clickSubmitBtn:(UIButton *)sender {

}



@end
