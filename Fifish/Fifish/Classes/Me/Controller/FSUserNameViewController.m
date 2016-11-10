//
//  FSUserNameViewController.m
//  Fifish
//
//  Created by THN-Dong on 2016/10/26.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSUserNameViewController.h"
#import "FSUserModel.h"

@interface FSUserNameViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@end

@implementation FSUserNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameTF.delegate = self;
    FSUserModel *model = [[FSUserModel findAll] lastObject];
    self.nameTF.text = model.username;
    self.navigationItem.title = NSLocalizedString(@"Modify the nickname", nil);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setTitle:NSLocalizedString(@"save", nil) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor colorWithHexString:@"#298cff"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = saveItem;
}

-(void)saveClick{
    if (self.nameTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"The user is null", nil)];
        return;
    }
    FBRequest *request = [FBAPI postWithUrlString:@"/me/settings" requestDictionary:@{
                                                                                        @"username" : self.nameTF.text
                                                                                        } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        FSUserModel *model = [[FSUserModel findAll] lastObject];
        model.username = self.nameTF.text;
        [model saveOrUpdate];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [self.view endEditing:YES];
}

@end
