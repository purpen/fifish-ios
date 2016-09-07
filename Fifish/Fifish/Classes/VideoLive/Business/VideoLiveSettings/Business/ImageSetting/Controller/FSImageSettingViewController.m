//
//  FSImageSettingViewController.m
//  Fifish
//
//  Created by macpro on 16/9/7.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSImageSettingViewController.h"
#import "FSImageSettingTableViewCell.h"
@interface FSImageSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * menuTableview;

@property (nonatomic,strong)NSArray     * menuTitleArrs;//菜单
@end

@implementation FSImageSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpMenulist];
    // Do any additional setup after loading the view.
}

- (void)setUpMenulist{
    [self.view addSubview:self.menuTableview];
    [self.menuTableview mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
- (NSArray *)menuTitleArrs{
    if (!_menuTitleArrs) {
        _menuTitleArrs = @[NSLocalizedString(@"背光补偿", nil),NSLocalizedString(@"低照度", nil),NSLocalizedString(@"模式", nil)];
    }
    return _menuTitleArrs;
}
- (UITableView *)menuTableview{
    if (!_menuTableview) {
        _menuTableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _menuTableview.delegate = self;
        _menuTableview.dataSource = self;
        _menuTableview.tableFooterView = [[UIView alloc] init];
        _menuTableview.backgroundColor = [UIColor blackColor];
        [_menuTableview registerClass:[FSImageSettingTableViewCell class] forCellReuseIdentifier:ImageSettingTableViewCellIden];
    }
    return _menuTableview;
}
#pragma mark tableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.menuTitleArrs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FSImageSettingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ImageSettingTableViewCellIden];
    cell.textLabel.text = self.menuTitleArrs[indexPath.row];
    
    return cell;
}



@end
