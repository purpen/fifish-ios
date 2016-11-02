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

@interface OptionViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *remindLabel;
@property (weak, nonatomic) IBOutlet UITextView *optionTFV;

@end


@implementation OptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"意见反馈";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setTitle:@"发送" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor colorWithHexString:@"#298cff"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = sendItem;
    
    self.optionTFV.delegate = self;
}

-(void)sendClick{
    if (self.optionTFV.text.length > 200) {
        [SVProgressHUD showInfoWithStatus:@"不能多于200个字"];
        return;
    }
    //封装参数
    NSDictionary *params = @{
                             @"content":self.optionTFV.text
                             };
    FBRequest *request = [FBAPI postWithUrlString:@"/feedback/submit" requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        [SVProgressHUD showSuccessWithStatus:@"反馈成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(FBRequest *request, NSError *error) {
        //发送请求失败
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
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
