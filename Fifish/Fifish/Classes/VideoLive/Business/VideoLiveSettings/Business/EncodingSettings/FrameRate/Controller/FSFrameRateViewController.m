//
//  FSFrameRateViewController.m
//  Fifish
//
//  Created by macpro on 16/9/7.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSGeneralSettingsCell.h"
#import "FSFrameRateViewController.h"




@interface FSFrameRateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * menuTableView;
@property (nonatomic,strong)NSArray     * menuTitleArrs;
@property (nonatomic,strong)NSArray     * sectionTitleArr;


@property (nonatomic,strong)       NSIndexPath  * currentsizeIdex;//当前选中单位
@property (nonatomic,strong)       NSIndexPath  * currentFrameRateIdex;//当前选中温度
@end

@implementation FSFrameRateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTable];
    // Do any additional setup after loading the view.
}

- (void)setUpTable{
 
    [self.view addSubview:self.menuTableView];
    [self.menuTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}
- (NSArray *)menuTitleArrs{
//    NSLocalizedString(@"尺寸/帧率", nil)
    if (!_menuTitleArrs) {
        _menuTitleArrs = @[@[@"1280*720(720p)",@"1920*1080(1080p)",@"4096*2160(4k)"],@[@"25fps",@"30fps"]];
        
    }
    return _menuTitleArrs;
}

- (NSArray *)sectionTitleArr
{
    if (!_sectionTitleArr) {
        _sectionTitleArr = @[NSLocalizedString(@"尺寸", nil),NSLocalizedString(@"帧率", nil)];
    }
    return _sectionTitleArr;
}

//TODO:这个table要封装起来，每个设置页面都有
- (UITableView *)menuTableView{
    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _menuTableView.backgroundColor = SETTING_Black_COLOR;
        _menuTableView.delegate = self;
        _menuTableView.dataSource =self;
        _menuTableView.tableFooterView = [[UIView alloc] init];
        [_menuTableView registerClass:[FSGeneralSettingsCell class] forCellReuseIdentifier:GeneralSettingsCellIden];
    }
    return _menuTableView;
    
}

#pragma mark tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.menuTitleArrs.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.menuTitleArrs[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FSGeneralSettingsCell * cell = [tableView dequeueReusableCellWithIdentifier:GeneralSettingsCellIden];
    cell.textLabel.text = self.menuTitleArrs[indexPath.section][indexPath.row];
    
    if (indexPath == self.currentsizeIdex||indexPath==self.currentFrameRateIdex){
        cell.accessoryType =  UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * titleLab= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    titleLab.textColor = SETTING_Blue_COLOR;
    titleLab.text = self.sectionTitleArr[section];
    return titleLab;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        self.currentsizeIdex = indexPath;
    }
    if (indexPath.section ==1) {
        self.currentFrameRateIdex = indexPath;
    }
    [tableView reloadData];
}
@end
