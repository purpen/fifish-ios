//
//  FSLiveSettingsViewController.m
//  Fifish
//
//  Created by macpro on 16/9/5.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSLiveSettingsViewController.h"
#import "Masonry.h"

@interface FSLiveSettingsViewController ()

@property (nonatomic ,strong)UIButton * dissMissBtn;



@end

@implementation FSLiveSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    // Do any additional setup after loading the view.
}
- (void)setUpUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.dissMissBtn];
    [self.dissMissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(self.view.mas_top).offset(10);
    }];
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight;
}
- (UIButton *)dissMissBtn{
    if (!_dissMissBtn) {
        _dissMissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dissMissBtn setImage:[UIImage imageNamed:@"VideoSetting_cancel"] forState:UIControlStateNormal];
        [_dissMissBtn addTarget:self action:@selector(dissmissClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dissMissBtn;
}
- (void)dissmissClick{
    [self dismissViewControllerAnimated:YES completion:nil];
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
