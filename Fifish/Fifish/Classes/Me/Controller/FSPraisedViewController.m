//
//  FSPraisedViewController.m
//  Fifish
//
//  Created by THN-Dong on 2016/11/1.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSPraisedViewController.h"
#import "MJRefresh.h"
#import "FSZuoPin.h"
#import "SGTopTitleView.h"
#import "FSZuoPinGroupTableViewCell.h"

@interface FSPraisedViewController () <UITableViewDelegate, UITableViewDataSource, SGTopTitleViewDelegate>

/**  */
@property (nonatomic, strong) UITableView *myTableView;
/**
 默认：0；
 图片：1；
 视频：2；
 */
@property (nonatomic, assign) NSInteger kind;
/**  */
@property (nonatomic, strong) NSMutableArray *stuffAry;
/**  */
@property (nonatomic, assign) NSInteger current_page;
/**  */
@property (nonatomic, assign) NSInteger total_rows;
/**  */
@property (nonatomic, strong) SGTopTitleView *segmentedControl;
/**  */
@property (nonatomic, strong) UIView *lineView;

@end

@implementation FSPraisedViewController

-(NSMutableArray *)stuffAry{
    if (!_stuffAry) {
        _stuffAry = [NSMutableArray array];
    }
    return _stuffAry;
}

-(SGTopTitleView *)segmentedControl{
    if (!_segmentedControl) {
        _segmentedControl = [[SGTopTitleView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, 44)];
        _segmentedControl.staticTitleArr = @[NSLocalizedString(@"picture", nil), NSLocalizedString(@"video", nil)];
        _segmentedControl.backgroundColor = [UIColor whiteColor];
        _segmentedControl.delegate_SG = self;
    }
    return _segmentedControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.kind = 1;
    self.navigationItem.title = NSLocalizedString(@"Praised", nil);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.myTableView];
    [self setUpRefresh];
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.lineView];
}

#pragma mark - 设置刷新
-(void)setUpRefresh{
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    // 自动改变透明度
    self.myTableView.mj_header.automaticallyChangeAlpha = YES;
    [self.myTableView.mj_header beginRefreshing];
    
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 45, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _myTableView;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 65 + 44, SCREEN_WIDTH, 1)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    }
    return _lineView;
}

-(void)loadNew{
    [self.myTableView.mj_footer endRefreshing];
    self.current_page = 1;
    NSDictionary *params = @{
                             @"page" : @(self.current_page),
                             @"per_page" : @12,
                             @"kind" : @(self.kind)
                             };
    FBRequest *request = [FBAPI getWithUrlString:@"/me/likeStuffs" requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        self.current_page = [result[@"meta"][@"pagination"][@"current_page"] integerValue];
        self.total_rows = [result[@"meta"][@"pagination"][@"total"] integerValue];
        NSArray *dataAry = result[@"data"];
        [self.stuffAry removeAllObjects];
        for (NSDictionary *dict in dataAry) {
            NSDictionary *likeableDict = dict[@"likeable"];
            FSZuoPin *model = [FSZuoPin mj_objectWithKeyValues:likeableDict];
            [self.stuffAry addObject:model];
        }
        [self.myTableView reloadData];
        [self.myTableView.mj_header endRefreshing];
        [self checkFooterState];
    } failure:^(FBRequest *request, NSError *error) {
        // 提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        // 让底部控件结束刷新
        [self.myTableView.mj_header endRefreshing];
    }];
}

-(void)loadMore{
    [self.myTableView.mj_header endRefreshing];
    NSDictionary *params = @{
                             @"page" : @(++ self.current_page),
                             @"per_page" : @12,
                             @"kind" : @(self.kind)
                             };
    FBRequest *request = [FBAPI getWithUrlString:@"/me/likeStuffs" requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        self.current_page = [result[@"meta"][@"pagination"][@"current_page"] integerValue];
        self.total_rows = [result[@"meta"][@"pagination"][@"total"] integerValue];
        NSArray *dataAry = result[@"data"];
        for (NSDictionary *dict in dataAry) {
            NSDictionary *likeableDict = dict[@"likeable"];
            FSZuoPin *model = [FSZuoPin mj_objectWithKeyValues:likeableDict];
            [self.stuffAry addObject:model];
        }
        [self.myTableView reloadData];
        [self.myTableView.mj_header endRefreshing];
        [self checkFooterState];
    } failure:^(FBRequest *request, NSError *error) {
        // 提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        // 让底部控件结束刷新
        [self.myTableView.mj_footer endRefreshing];
    }];
    
}

-(void)checkFooterState{
    self.myTableView.mj_footer.hidden = self.stuffAry.count == 0;
    if (self.stuffAry.count == self.total_rows) {
        self.myTableView.mj_footer.hidden = YES;
    }else{
        [self.myTableView.mj_footer endRefreshing];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger n1 = self.stuffAry.count / 3;
    NSInteger n2 = self.stuffAry.count % 3;
    if (n2 > 0) {
        n1 ++;
    }
    return n1 * ((SCREEN_WIDTH - 5 * 2) / 3 + 10);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //组式排列
    static NSString *cellId = @"cellOne";
    FSZuoPinGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[FSZuoPinGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.groupAry = self.stuffAry;
    cell.navc = self.navigationController;
    return cell;
}

#pragma mark - - - SGTopScrollMenu代理方法
- (void)SGTopTitleView:(SGTopTitleView *)topTitleView didSelectTitleAtIndex:(NSInteger)index {
    if (index == 0) {
        self.kind = 1;
    } else if (index == 1) {
        self.kind = 2;
    }
    //进行网络请求
    [self.myTableView.mj_header beginRefreshing];
}

@end
