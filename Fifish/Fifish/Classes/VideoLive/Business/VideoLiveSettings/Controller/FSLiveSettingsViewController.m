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
#import "FSImageSettingViewController.h"
#import "FSEncodingSettingViewController.h"

#import "FSCameraManager.h"

#import "Masonry.h"

static NSString * const tableViewCellIden = @"systemCell";



@interface FSLiveSettingsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView    * MenuTableview;//菜单

@property (nonatomic ,strong)NSArray        *MenuTitlesArr;//菜单标题

@property (nonatomic ,strong)UIView         * CilpLineView;//分割线

@property (nonatomic, assign)UINavigationController* currentViewController;//当前显示的VC

@end

@implementation FSLiveSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
    
    [self loadChildViewControllers];
    
    [self tableView:self.MenuTableview didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    // Do any additional setup after loading the view.
}
- (void)loadChildViewControllers{
    
    FSGeneralSettingViewController * FSGeneralSettingVc = [[FSGeneralSettingViewController alloc] init];
    [FSGeneralSettingVc setdissMissBtn];
    
    FSImageSettingViewController * FSImageSettingVc =[[FSImageSettingViewController alloc] init];
    [FSImageSettingVc setdissMissBtn];
    
    FSEncodingSettingViewController * FSEncodingSettingVC =[[FSEncodingSettingViewController alloc] init];
    
    [self addChildViewController:[[UINavigationController alloc] initWithRootViewController:FSGeneralSettingVc]];
    [self addChildViewController:[[UINavigationController alloc] initWithRootViewController:FSImageSettingVc]];
    [self addChildViewController:[[UINavigationController alloc] initWithRootViewController:FSEncodingSettingVC]];
    
    self.currentViewController = self.childViewControllers[0];
    
    [self.view addSubview:self.currentViewController.view];
    [self.currentViewController didMoveToParentViewController:self];

}
- (void)addChildViewController:(UIViewController *)childController{
    [super addChildViewController:childController];
    //跟aotulayout不兼容，不知道怎么解决
    childController.view.frame = CGRectMake(CGRectGetWidth(self.view.frame)*0.3+0.5, 0,CGRectGetWidth(self.view.frame)-(CGRectGetWidth(self.view.frame)*0.3)-0.5,CGRectGetHeight(self.view.frame));
}
- (void)setUpUI{
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.MenuTableview];
    [self.MenuTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(self.view.frame.size.width*0.3);
    }];
    
    [self.view addSubview:self.CilpLineView];
    [self.CilpLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.MenuTableview.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(0.5);
    }];
}
#pragma mark UI
//横屏
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
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

- (UIView *)CilpLineView{
    if (!_CilpLineView) {
        _CilpLineView = [[UIView alloc] init];
        _CilpLineView.backgroundColor = SETTING_Gray_COLOR;
        
    }
    
    return _CilpLineView;
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
    //切换child view controller
    UINavigationController * newvc = self.childViewControllers[indexPath.row];
    newvc.viewControllers[0].title = self.MenuTitlesArr[indexPath.row];
    
    if (newvc == self.currentViewController) {
        return;
    }
    [self transitionFromViewController:self.currentViewController toViewController:newvc duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
    }  completion:^(BOOL finished) {
            [newvc didMoveToParentViewController:self];
            [self.currentViewController willMoveToParentViewController:nil];
            self.currentViewController = newvc;
    }];
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
