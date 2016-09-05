//
//  OptionViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "OptionViewController.h"
#import "SVProgressHUD.h"
#import "FBRequest.h"
#import "FBAPI.h"

@interface OptionViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *remindLabel;
@property (weak, nonatomic) IBOutlet UITextView *optionTFV;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end


@implementation OptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"意见反馈";
    self.phoneTF.delegate = self;
    self.optionTFV.delegate = self;
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.cornerRadius = 3;
}



- (IBAction)clickSubmitBtn:(UIButton *)sender {
    if (self.optionTFV.text.length > 200) {
        [SVProgressHUD showInfoWithStatus:@"不能多于200个字"];
        return;
    }
    //封装参数
    NSDictionary *params = @{
                             @"content":self.optionTFV.text,
                             @"contact":self.phoneTF.text
                             };
//    FBRequest *request = [FBAPI postWithUrlString:@"/feedback/submit" requestDictionary:params delegate:self];
//    [request startRequestSuccess:^(FBRequest *request, id result) {
//        [SVProgressHUD showSuccessWithStatus:@"反馈成功"];
//        [self.navigationController popViewControllerAnimated:YES];
//    } failure:^(FBRequest *request, NSError *error) {
//        //发送请求失败
//        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//    }];

}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.remindLabel.hidden = YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    if (textView.text.length == 0) {
        self.remindLabel.hidden = NO;
    }else{
        self.remindLabel.hidden = YES;
    }
}


@end
