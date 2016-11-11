//
//  FSReportViewController.m
//  Fifish
//
//  Created by THN-Dong on 2016/11/11.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSReportViewController.h"

@interface FSReportViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondViewBottomSpace;

@end

@implementation FSReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)reportClick:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{
        self.firstViewBottomSapce.constant = -132;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            self.secondViewBottomSpace.constant = 0;
            [self.view layoutIfNeeded];
        } completion:nil];
    }];
}

- (IBAction)shareClick:(id)sender {
}

- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)spamClick:(id)sender {
}

- (IBAction)indecentClick:(id)sender {
}

- (IBAction)secondCancel:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{
        self.secondViewBottomSpace.constant = -132;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            self.firstViewBottomSapce.constant = 0;
            [self.view layoutIfNeeded];
        } completion:nil];
    }];
}

- (IBAction)oterSpaceClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
