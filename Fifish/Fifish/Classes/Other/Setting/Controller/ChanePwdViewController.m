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

@end

static NSString *const ChangePwdURL = @"/my/modify_password";

@implementation ChanePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"修改密码";
    
    //
    self.pwdView.layer.masksToBounds = YES;
    self.pwdView.layer.cornerRadius = 2;
    self.oldPwdView.layer.masksToBounds = YES;
    self.oldPwdView.layer.cornerRadius = 2;
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.cornerRadius = 2;
}


- (IBAction)clickSubmitBtn:(UIButton *)sender {
//    NSDictionary * params = @{@"password": self.oldPwdTF.text, @"new_password": self.pwdTF.text};
//    FBRequest * request = [FBAPI postWithUrlString:ChangePwdURL requestDictionary:params delegate:self];
//    request.flag = ChangePwdURL;
//    [request startRequest];
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
}

#pragma mark - FBRequest Delegate
//- (void)requestSucess:(FBRequest *)request result:(id)result
//{
//    
//    if ([request.flag isEqualToString:ChangePwdURL]) {
//        NSString * message = [result objectForKey:@"message"];
//        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
//            
//            [SVProgressHUD showSuccessWithStatus:message];
//            [self.navigationController popViewControllerAnimated:YES];
//        } else {
//            [SVProgressHUD showInfoWithStatus:message];
//        }
//    }
//    request = nil;
//}
//
//- (void)requestFailed:(FBRequest *)request error:(NSError *)error
//{
//    [SVProgressHUD dismiss];
//}
//
//- (void)userCanceledFailed:(FBRequest *)request error:(NSError *)error
//{
//    [SVProgressHUD dismiss];
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
