//
//  FSChangeSexViewController.m
//  Fifish
//
//  Created by THN-Dong on 2016/11/1.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSChangeSexViewController.h"
#import "FSUserModel2.h"

@interface FSChangeSexViewController ()

@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *womenBtn;

@end

@implementation FSChangeSexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"Modify the gender", nil);
    FSUserModel2 *userModel = [[FSUserModel2 findAll] lastObject];
    switch (userModel.gender) {
        case 0:
        {
        //默认
        }
            break;
        case 1:
        {
            //男
            self.manBtn.selected = YES;
        }
            break;
        case 2:
        {
            //女
            self.womenBtn.selected = YES;
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)manClickClick:(id)sender {
    if (self.manBtn.selected) {
    } else {
        //选中
        FBRequest *request = [FBAPI postWithUrlString:@"/me/settings" requestDictionary:@{
                                                                                          @"sex" : @(1)
                                                                                          } delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            FSUserModel2 *userModel = [[FSUserModel2 findAll] lastObject];
            userModel.gender = 1;
            self.manBtn.selected = YES;
            self.womenBtn.selected = NO;
            userModel.isLogin = YES;
            [userModel saveOrUpdate];
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    }
}

- (IBAction)womenClickClick:(id)sender {
    if (self.womenBtn.selected) {
    } else {
        //选中
        FBRequest *request = [FBAPI postWithUrlString:@"/me/settings" requestDictionary:@{
                                                                                          @"sex" : @(2)
                                                                                          } delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            FSUserModel2 *userModel = [[FSUserModel2 findAll] lastObject];
            userModel.gender = 2;
            self.womenBtn.selected = YES;
            self.manBtn.selected = NO;
            [userModel saveOrUpdate];
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    }
}


@end
