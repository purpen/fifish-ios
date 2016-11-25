//
//  FSRecivedPriaseViewController.m
//  Fifish
//
//  Created by THN-Dong on 2016/11/4.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSRecivedPriaseViewController.h"
#import "MJRefresh.h"
#import "FSUserModel.h"
#import "FSFansModel.h"
#import "FSPrasiedTableViewCell.h"
#import "FSHomePageViewController.h"
#import "FSRecivedPrasiedModel.h"
#import "FSHomeDetailViewController.h"

@interface FSRecivedPriaseViewController () <UITableViewDelegate, UITableViewDataSource>

/**  */
@property (nonatomic, strong) UITableView *myTableView;
/**  */
@property (nonatomic, strong) NSMutableArray *modelAry;
/**  */
@property (nonatomic, assign) NSInteger current_page;
/**  */
@property (nonatomic, assign) NSInteger total_rows;

@end

@implementation FSRecivedPriaseViewController

-(NSMutableArray *)modelAry{
    if (!_modelAry) {
        _modelAry = [NSMutableArray array];
    }
    return _modelAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.myTableView];
    [self setupRefresh];
    self.navigationItem.title = NSLocalizedString(@"like", nil);
    FBRequest *request = [FBAPI postWithUrlString:@"/me/resetCount" requestDictionary:@{@"key" : @"like"} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

-(void)setupRefresh{
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    // 自动改变透明度
    self.myTableView.mj_header.automaticallyChangeAlpha = YES;
    [self.myTableView.mj_header beginRefreshing];
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.myTableView.mj_footer.hidden = YES;
}

-(void)loadNew{
    self.current_page = 1;
    FBRequest *request = [FBAPI getWithUrlString:@"/me/gotLikes" requestDictionary:@{@"page" : @(self.current_page), @"per_page" : @(20)} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        self.current_page = [result[@"meta"][@"pagination"][@"current_page"] integerValue];
        self.total_rows = [result[@"meta"][@"pagination"][@"total"] integerValue];
        NSArray *dataAry = result[@"data"];
        self.modelAry = [FSRecivedPrasiedModel mj_objectArrayWithKeyValuesArray:dataAry];
        [self.myTableView reloadData];
        [self checkFooterState];
        [self.myTableView.mj_header endRefreshing];
    } failure:^(FBRequest *request, NSError *error) {
        // 提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        // 让底部控件结束刷新
        [self.myTableView.mj_header endRefreshing];
    }];
}

-(void)loadMore{
    FBRequest *request = [FBAPI postWithUrlString:@"/me/gotLikes" requestDictionary:@{@"page" : @(++self.current_page), @"per_page" : @(20)} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        self.current_page = [result[@"meta"][@"pagination"][@"current_page"] integerValue];
        self.total_rows = [result[@"meta"][@"pagination"][@"total"] integerValue];
        NSArray *dataAry = result[@"data"];
        NSArray *ary = [FSRecivedPrasiedModel mj_objectArrayWithKeyValuesArray:dataAry];
        [self.modelAry addObjectsFromArray:ary];
        [self.myTableView reloadData];
        [self checkFooterState];
        [self.myTableView.mj_header endRefreshing];
    } failure:^(FBRequest *request, NSError *error) {
        // 提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        // 让底部控件结束刷新
        [self.myTableView.mj_header endRefreshing];
    }];
}

-(void)checkFooterState{
    self.myTableView.mj_footer.hidden = self.modelAry.count == 0;
    if (self.modelAry.count == self.total_rows) {
        self.myTableView.mj_footer.hidden = YES;
    }else{
        [self.myTableView.mj_footer endRefreshing];
    }
}

-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FSPrasiedTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"FSPrasiedTableViewCell"];
    }
    return _myTableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FSPrasiedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSPrasiedTableViewCell"];
    cell.model = self.modelAry[indexPath.row];
    cell.myVC = self;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FSHomeDetailViewController *vc = [[FSHomeDetailViewController alloc] init];
    FSRecivedPrasiedModel *model = self.modelAry[indexPath.row];
    vc.stuffId = model.stuffId;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
