//
//  FSGeneralSettingViewController.m
//  Fifish
//
//  Created by macpro on 16/9/7.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSGeneralSettingViewController.h"
#import "FSGeneralSettingsCell.h"




@interface FSGeneralSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView * menuTableView;//菜单

@property (nonatomic, strong)NSArray     * menuTitleArrs;//标题

@property (nonatomic, strong)NSArray     * subMenuTitleArrs;//子标题

@property (nonatomic,strong)       NSIndexPath  * currentUnitIdex;//当前选中单位
@property (nonatomic,strong)       NSIndexPath  * currentTempIdex;//当前选中温度

@end

@implementation FSGeneralSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMenu];
    // Do any additional setup after loading the view.
}
- (NSArray *)subMenuTitleArrs{
    if (!_subMenuTitleArrs) {
        _subMenuTitleArrs = @[@[NSLocalizedString(@"英尺", nil),NSLocalizedString(@"米", nil)],@[NSLocalizedString(@"摄氏度", nil),NSLocalizedString(@"华氏度", nil)]];
    }
    return _subMenuTitleArrs;

}
-(NSArray *)menuTitleArrs{
    if (!_menuTitleArrs) {
        _menuTitleArrs = @[NSLocalizedString(@"度量单位", nil),NSLocalizedString(@"温度", nil)];
    }
    return _menuTitleArrs;
}
- (UITableView *)menuTableView{
    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _menuTableView.delegate = self;
        _menuTableView.dataSource =self;
        _menuTableView.backgroundColor = [UIColor blackColor];
        _menuTableView.tableFooterView = [[UIView alloc] init];
        [_menuTableView registerClass:[FSGeneralSettingsCell class] forCellReuseIdentifier:GeneralSettingsCellIden];
    }
    return _menuTableView;
}
- (void)loadMenu{
    [self.view addSubview:self.menuTableView];
    [self.menuTableView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}



#pragma tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.menuTitleArrs.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.subMenuTitleArrs[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSGeneralSettingsCell * cell = [tableView dequeueReusableCellWithIdentifier:GeneralSettingsCellIden];
    cell.textLabel.text = self.subMenuTitleArrs[indexPath.section][indexPath.row];
    
    if (indexPath == self.currentUnitIdex||indexPath==self.currentTempIdex){
        cell.accessoryType =  UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * titleLab= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    titleLab.textColor = SETTING_Gray_COLOR;
    titleLab.text = self.menuTitleArrs[section];
    return titleLab;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        self.currentUnitIdex = indexPath;
    }
    if (indexPath.section ==1) {
        self.currentTempIdex = indexPath;
    }
    [tableView reloadData];
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
