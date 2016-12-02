//
//  FSNewFansViewController.m
//  Fifish
//
//  Created by THN-Dong on 2016/11/4.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSNewFansViewController.h"
#import "MJRefresh.h"
#import "FSUserModel2.h"
#import "FSFansModel.h"
#import "FSListUserTableViewCell.h"
#import "FSHomePageViewController.h"

@interface FSNewFansViewController () <UITableViewDelegate, UITableViewDataSource>

/**  */
@property (nonatomic, strong) UITableView *myTableView;
/**  */
@property (nonatomic, strong) NSMutableArray *fansAry;
/**  */
@property (nonatomic, assign) NSInteger current_page;
/**  */
@property (nonatomic, assign) NSInteger total_rows;

@end

@implementation FSNewFansViewController

-(NSMutableArray *)fansAry{
    if (!_fansAry) {
        _fansAry = [NSMutableArray array];
    }
    return _fansAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.myTableView];
    [self setupRefresh];
    self.navigationItem.title = NSLocalizedString(@"The new fan", nil);
    FBRequest *request = [FBAPI postWithUrlString:@"/me/resetCount" requestDictionary:@{@"key" : @"fans"} delegate:self];
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
    FSUserModel2 *userModel = [[FSUserModel2 findAll] lastObject];
    self.current_page = 1;
    FBRequest *request = [FBAPI getWithUrlString:[NSString stringWithFormat:@"/user/%@/fans",userModel.userId] requestDictionary:@{@"page" : @(self.current_page), @"per_page" : @(20)} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        self.current_page = [result[@"meta"][@"pagination"][@"current_page"] integerValue];
        self.total_rows = [result[@"meta"][@"pagination"][@"total"] integerValue];
        NSArray *dataAry = result[@"data"];
        self.fansAry = [FSFansModel mj_objectArrayWithKeyValuesArray:dataAry];
        [self.myTableView reloadData];
        [self checkFooterState];
        [self.myTableView.mj_header endRefreshing];
    } failure:^(FBRequest *request, NSError *error) {
        // 提醒
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Network error", nil)];
        // 让底部控件结束刷新
        [self.myTableView.mj_header endRefreshing];
    }];
}

-(void)loadMore{
    FSUserModel2 *userModel = [[FSUserModel2 findAll] lastObject];
    FBRequest *request = [FBAPI getWithUrlString:[NSString stringWithFormat:@"/user/%@/fans",userModel.userId] requestDictionary:@{@"page" : @(++self.current_page), @"per_page" : @(20)} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        self.current_page = [result[@"meta"][@"pagination"][@"current_page"] integerValue];
        self.total_rows = [result[@"meta"][@"pagination"][@"total"] integerValue];
        NSArray *dataAry = result[@"data"];
        NSArray *ary = [FSFansModel mj_objectArrayWithKeyValuesArray:dataAry];
        [self.fansAry addObjectsFromArray:ary];
        [self.myTableView reloadData];
        [self checkFooterState];
        [self.myTableView.mj_header endRefreshing];
    } failure:^(FBRequest *request, NSError *error) {
        // 提醒
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Network error", nil)];
        // 让底部控件结束刷新
        [self.myTableView.mj_header endRefreshing];
    }];
}

-(void)checkFooterState{
    self.myTableView.mj_footer.hidden = self.fansAry.count == 0;
    if (self.fansAry.count == self.total_rows) {
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
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FSListUserTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"FSListUserTableViewCell"];
    }
    return _myTableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fansAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FSListUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSListUserTableViewCell"];
    cell.model = self.fansAry[indexPath.row];
    cell.fucosBtn.tag = indexPath.row;
    [cell.fucosBtn addTarget:self action:@selector(fucosClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - 关注
-(void)fucosClick:(UIButton*)sender{
    if (sender.selected) {
        //取消关注
        FSFansModel *model = self.fansAry[sender.tag];
        FBRequest *request = [FBAPI deleteWithUrlString:[NSString stringWithFormat:@"/user/%@/cancelFollow",model.userId] requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            sender.selected = NO;
            sender.layer.borderColor = [UIColor colorWithHexString:@"#7F8FA2"].CGColor;
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    } else {
        //关注
        FSFansModel *model = self.fansAry[sender.tag];
        FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/user/%@/follow",model.userId] requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            sender.selected = YES;
            sender.layer.borderColor = [UIColor colorWithHexString:@"#2288FF"].CGColor;
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FSHomePageViewController *vc = [[FSHomePageViewController alloc] init];
    FSFansModel *model = self.fansAry[indexPath.row];
    vc.userId = model.userId;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
