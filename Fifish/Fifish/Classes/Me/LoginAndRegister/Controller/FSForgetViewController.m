//
//  FSForgetViewController.m
//  Fifish
//
//  Created by THN-Dong on 16/9/2.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSForgetViewController.h"
#import "UIBarButtonItem+FSExtension.h"
#import "SVProgressHUD.h"
#import "NSString+Helper.h"

@interface FSForgetViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTF;

@end

@implementation FSForgetViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"忘记密码";
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneClick)];
    self.navigationItem.rightBarButtonItem = doneItem;
}

-(void)doneClick{
    if (_emailTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"邮箱为空"];
        return;
    }else if (![_emailTF.text isValidateEmail]){
        [SVProgressHUD showErrorWithStatus:@"邮箱格式不正确"];
    }
    
    
}

@end
