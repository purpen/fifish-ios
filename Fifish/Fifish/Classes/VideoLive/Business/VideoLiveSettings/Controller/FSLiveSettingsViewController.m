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
#import "FSGeneralSettingViewController.h"

#import "FSCameraManager.h"

#import "Masonry.h"

static NSString * const tableViewCellIden = @"systemCell";



@interface FSLiveSettingsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UIButton       * dissMissBtn;

@property (nonatomic ,strong)UITableView    * MenuTableview;//菜单

@property (nonatomic ,strong)NSArray        *MenuTitlesArr;//菜单标题

@property (nonatomic ,strong)UILabel        * NavTitleLab;//nav

@property (nonatomic ,strong)UIView         * containerView;//托盘

@property (nonatomic ,strong)UIView         * CilpLineView;//分割线


@property (nonatomic, strong)FSGeneralSettingViewController * generalSettingVc;//通用设置

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
    
    [self loadChildViewControllers];
    
    [self tableView:self.MenuTableview didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    // Do any additional setup after loading the view.
}
- (void)loadChildViewControllers{
    [self addChildViewController:self.generalSettingVc];
    
    [self.containerView addSubview:self.generalSettingVc.view];

}
- (void)addChildViewController:(UIViewController *)childController{
    [super addChildViewController:childController];
    childController.view.frame = CGRectMake(0, 0,self.containerView.bounds.size.width,self.containerView.bounds.size.height);
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
    
    [self.view addSubview:self.NavTitleLab];
    [self.NavTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.MenuTableview.mas_right);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(64);
    }];
    
    [self.view addSubview:self.CilpLineView];
    [self.CilpLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.MenuTableview.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(0.5);
    }];
    
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.NavTitleLab.mas_bottom);
        make.left.equalTo(self.CilpLineView.mas_right);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
}

#pragma mark VC
- (FSGeneralSettingViewController *)generalSettingVc{
    if (!_generalSettingVc) {
        _generalSettingVc = [[FSGeneralSettingViewController alloc] init];
    }
    return _generalSettingVc;
}



#pragma mark UI
//横屏
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

-(UILabel *)NavTitleLab{
    if (!_NavTitleLab) {
        _NavTitleLab = [[UILabel alloc] init];
        _NavTitleLab.textAlignment = NSTextAlignmentCenter;
        _NavTitleLab.textColor = [UIColor whiteColor];
    }
    return _NavTitleLab;
}
- (UIView *)CilpLineView{
    if (!_CilpLineView) {
        _CilpLineView = [[UIView alloc] init];
        _CilpLineView.backgroundColor = SETTING_GRAY_COLOR;
        
    }
    return _CilpLineView;
}
- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.NavTitleLab.text=self.MenuTitlesArr[indexPath.row];
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
