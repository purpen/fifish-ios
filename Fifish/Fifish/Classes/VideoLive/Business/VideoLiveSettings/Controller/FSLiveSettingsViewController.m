//
//  FSLiveSettingsViewController.m
//  Fifish
//
//  Created by macpro on 16/9/5.
//  Copyright © 2016年 Dong. All rights reserved.
//


//cell
#import "FSliveSettingsTableViewCell.h"

#import "FSLiveSettingsViewController.h"
#import "FSCameraManager.h"

#import "Masonry.h"

static NSString * const tableViewCellIden = @"systemCell";



@interface FSLiveSettingsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UIButton       * dissMissBtn;

@property (nonatomic ,strong)UITableView    * MenuTableview;//菜单

@property (nonatomic ,strong)NSArray        *MenuTitlesArr;//菜单标题
@end

@implementation FSLiveSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    FSCameraManager * manager = [[FSCameraManager alloc] init];
//    [manager getCameraInfoWithSuccessBlock:^(NSDictionary *responseObject) {
//        NSLog(@"%@",responseObject);
//    } WithFailureBlock:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
    [self setUpUI];
    // Do any additional setup after loading the view.
}
- (void)setUpUI{
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.dissMissBtn];
    [self.dissMissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(self.view.mas_top).offset(10);
    }];
    
    [self.view addSubview:self.MenuTableview];
    [self.MenuTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(self.view.frame.size.width*0.3);
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

- (NSArray *)MenuTitlesArr{
    if (!_MenuTitlesArr) {
        _MenuTitlesArr = @[NSLocalizedString(@"通用设置", nil),NSLocalizedString(@"图像设置", nil),NSLocalizedString(@"编码设置", nil)];
    }
    return _MenuTitlesArr;
}
- (UITableView *)MenuTableview{
    if (!_MenuTableview) {
        _MenuTableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _MenuTableview.backgroundColor = [UIColor blackColor];
        _MenuTableview.delegate =self;
        _MenuTableview.dataSource =self;
        _MenuTableview.tableFooterView = [[UIView alloc] init];
        _MenuTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_MenuTableview registerClass:[FSliveSettingsTableViewCell class] forCellReuseIdentifier:tableViewCellIden];
    }
    return _MenuTableview;
}

#pragma mark MenuTableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.MenuTitlesArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FSliveSettingsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIden];
    cell.textLabel.text = self.MenuTitlesArr[indexPath.row];
    [cell willshow];
    return cell;
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
