//
//  FSSummaryViewController.m
//  Fifish
//
//  Created by THN-Dong on 2016/10/26.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSSummaryViewController.h"
#import "FSUserModel.h"

@interface FSSummaryViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *summaryTF;

@end

@implementation FSSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.summaryTF.delegate = self;
    FSUserModel *model = [[FSUserModel findAll] lastObject];
    self.summaryTF.text = model.summary;
    self.navigationItem.title = NSLocalizedString(@"Individuality signature", nil);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setTitle:NSLocalizedString(@"done", nil) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor colorWithHexString:@"#298cff"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = doneItem;
}

-(void)doneClick{
//    if (self.summaryTF.text.length == 0) {
//        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"The summary is null", nil)];
//        return;
//    }
//    FBRequest *request = [FBAPI postWithUrlString:@"/user/settings" requestDictionary:@{
//                                                                                        @"useranme" : self.nameTF.text
//                                                                                        } delegate:self];
//    [request startRequestSuccess:^(FBRequest *request, id result) {
//        FSUserModel *model = [[FSUserModel findAll] lastObject];
//        model.username = self.nameTF.text;
//        [model saveOrUpdate];
//        [self.navigationController popViewControllerAnimated:YES];
//    } failure:^(FBRequest *request, NSError *error) {
//        
//    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [self.view endEditing:YES];
}

@end
