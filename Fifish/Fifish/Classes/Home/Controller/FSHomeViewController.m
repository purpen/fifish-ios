//
//  FSHomeViewController.m
//  Fifish
//
//  Created by THN-Dong on 16/7/25.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSHomeViewController.h"
#import "UIBarButtonItem+FSExtension.h"
#import "FSConst.h"
#import "FSHomeViewCell.h"
#import "FSHomeModel.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "FSHomeDetailViewController.h"

@interface FSHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
/**  */
@property (nonatomic, strong) UITableView *contenTableView;
/**  */
@property (nonatomic, strong) NSMutableArray *modelAry;
@end

static NSString * const CellId = @"home";

@implementation FSHomeViewController

-(NSMutableArray *)modelAry{
    if (!_modelAry) {
        _modelAry = [NSMutableArray array];
        FSHomeModel *model = [[FSHomeModel alloc] init];
        [_modelAry addObject:model];
    }
    return _modelAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self.view addSubview:self.contenTableView];
    [self.contenTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FSHomeViewCell class]) bundle:nil] forCellReuseIdentifier:CellId];
    // 添加刷新控件
    [self setupRefresh];
}

-(void)setupRefresh{
    self.contenTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    // 自动改变透明度
    self.contenTableView.mj_header.automaticallyChangeAlpha = YES;
    [self.contenTableView.mj_header beginRefreshing];
    self.contenTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

-(void)loadNew{
    // 结束上啦
    [self.contenTableView.mj_footer endRefreshing];
}

-(void)loadMore{
    // 结束下拉
    [self.contenTableView.mj_header endRefreshing];
}

-(UITableView *)contenTableView{
    if (!_contenTableView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _contenTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _contenTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _contenTableView.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
        _contenTableView.delegate = self;
        _contenTableView.dataSource = self;
    }
    return _contenTableView;
}

-(void)setupNav{
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithImage:@"me_search" highImage:nil title:nil target:self action:@selector(searchClick)];
    self.navigationItem.leftBarButtonItem = searchItem;
}

-(void)searchClick{
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.contenTableView.mj_footer.hidden = (self.modelAry.count == 0);
    return self.modelAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FSHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    cell.model = self.modelAry[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FSHomeModel *model = self.modelAry[indexPath.row];
    return model.cellHeghit;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FSHomeDetailViewController *vc = [[FSHomeDetailViewController alloc] init];
    vc.model = self.modelAry[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
