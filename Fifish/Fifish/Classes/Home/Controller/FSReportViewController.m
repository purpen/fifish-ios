//
//  FSReportViewController.m
//  Fifish
//
//  Created by THN-Dong on 2016/11/11.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSReportViewController.h"
#import "FSZuoPin.h"
#import "FSUserModel2.h"

@interface FSReportViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondViewBottomSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteBtnHeight;
/**  */
@property (nonatomic, assign) CGFloat viewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;

@end

@implementation FSReportViewController

-(void)setModel:(FSZuoPin *)model{
    _model = model;
    FSUserModel2 *usermodel = [[FSUserModel2 findAll] lastObject];
    self.deleteBtnHeight.constant = [usermodel.userId isEqualToString:model.user_id] ? 44 : 0;
    self.viewHeight = [usermodel.userId isEqualToString:model.user_id] ? 176 : 132;
    self.viewHeightConstraint.constant = self.viewHeight;
    NSLog(@"高度 %f %f", self.deleteBtnHeight.constant, self.viewHeightConstraint.constant);
    [self.view layoutIfNeeded];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewHeight = 176;
}

- (IBAction)reportClick:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{
        self.firstViewBottomSapce.constant = -self.viewHeight;
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

- (IBAction)deleteAction:(id)sender {
    NSLog(@"作品ID %@",self.model.idFeild);
    FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/stuffs/%@/destroy",self.model.idFeild] requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if ([self.fSReportDelegate respondsToSelector:@selector(deleteCellWithCellId:)]) {
            [self.fSReportDelegate deleteCellWithCellId:self.model.idFeild];
        }
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Network error", nil)];
    }];
}

- (IBAction)spamClick:(id)sender {
}

- (IBAction)indecentClick:(id)sender {
}

- (IBAction)secondCancel:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{
        self.secondViewBottomSpace.constant = -self.viewHeight;
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
