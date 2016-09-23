//
//  FSFoundViewController.m
//  Fifish
//
//  Created by THN-Dong on 16/7/25.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSFoundViewController.h"
#import "MJRefresh.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "FSTageModel.h"
#import "MJExtension.h"
#import "SVProgressHUD.h"
#import "FSFoundHeaderView.h"
#import "UIView+FSExtension.h"
#import "FSTagTableViewCell.h"
#import "FSUserModel.h"
#import "FSUserTableViewCell.h"
#import "FSZuoPin.h"
#import "FSFoundStuffTableViewCell.h"

@interface FSFoundViewController () <UITableViewDelegate,UITableViewDataSource>

/**  */
@property (nonatomic, strong) UITableView *contentTableView;
/**  */
@property(nonatomic,assign) NSInteger current_page;
/**  */
@property(nonatomic,assign) NSInteger total_rows;
/**  */
@property (nonatomic, strong) NSArray *tagsAry;
/**  */
@property (nonatomic, strong) NSMutableArray *stuffAry;
/**  */
@property (nonatomic, strong) FSFoundHeaderView *headerView;
/**  */
@property (nonatomic, strong) NSArray *userAry;

@end

@implementation FSFoundViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.contentTableView];
    // 添加刷新控件
    [self setupRefresh];
}

-(NSMutableArray *)stuffAry{
    if (!_stuffAry) {
        _stuffAry = [NSMutableArray array];
    }
    return _stuffAry;
}

-(void)setupRefresh{
    self.contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    // 自动改变透明度
    self.contentTableView.mj_header.automaticallyChangeAlpha = YES;
    [self.contentTableView.mj_header beginRefreshing];
    self.contentTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

-(void)loadNew{
    [self.contentTableView.mj_footer endRefreshing];
    self.current_page = 1;
    [self tagRequest];
    [self userRequest];
    [self stuffRequest];
}

-(void)loadMore{
    [self.contentTableView.mj_header endRefreshing];
    NSDictionary *params = @{
                             @"page" : @(++ self.current_page),
                             @"per_page" : @10
                             };
    FBRequest *request = [FBAPI getWithUrlString:@"/stuffs" requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        self.current_page = [result[@"meta"][@"pagination"][@"current_page"] integerValue];
        self.total_rows = [result[@"meta"][@"pagination"][@"total"] integerValue];
        NSArray *rows = result[@"data"];
        NSArray *ary = [FSZuoPin mj_objectArrayWithKeyValuesArray:rows];
        [self.stuffAry addObjectsFromArray:ary];
        [self.contentTableView reloadData];
        [self.contentTableView.mj_footer endRefreshing];
        [self checkFooterState];
    } failure:^(FBRequest *request, NSError *error) {
        // 提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        
        // 让底部控件结束刷新
        [self.contentTableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark - 获取推荐的作品
-(void)stuffRequest{
    NSDictionary *params = @{
                             @"page" : @(self.current_page),
                             @"per_page" : @10
                             };
    FBRequest *request = [FBAPI getWithUrlString:@"/stuffs" requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"推荐的作品 %@",result);
        self.current_page = [result[@"meta"][@"pagination"][@"current_page"] integerValue];
        self.total_rows = [result[@"meta"][@"pagination"][@"total"] integerValue];
        NSArray *rows = result[@"data"];
        self.stuffAry = [FSZuoPin mj_objectArrayWithKeyValuesArray:rows];
        [self.contentTableView reloadData];
        [self.contentTableView.mj_header endRefreshing];
        [self checkFooterState];
    } failure:^(FBRequest *request, NSError *error) {
        // 提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        
        // 让底部控件结束刷新
        [self.contentTableView.mj_header endRefreshing];
    }];
}

-(void)checkFooterState{
    self.contentTableView.mj_footer.hidden = self.stuffAry.count == 0;
    if (self.stuffAry.count == self.total_rows) {
        self.contentTableView.mj_footer.hidden = YES;
    }else{
        [self.contentTableView.mj_footer endRefreshing];
    }
}

#pragma mark - 获取热门用户
-(void)userRequest{
    FBRequest *request = [FBAPI getWithUrlString:@"/user/hot_users" requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *rows = result[@"data"];
        self.userAry = [FSUserModel mj_objectArrayWithKeyValuesArray:rows];
        [self.contentTableView reloadData];
    } failure:^(FBRequest *request, NSError *error) {
        // 提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        
        // 让底部控件结束刷新
        [self.contentTableView.mj_header endRefreshing];
    }];
}

#pragma mark - 获取推荐标签
-(void)tagRequest{
    FBRequest *request = [FBAPI getWithUrlString:@"/tags/sticks" requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *rows = result[@"data"];
        self.tagsAry = [FSTageModel mj_objectArrayWithKeyValuesArray:rows];
        [self.contentTableView reloadData];
    } failure:^(FBRequest *request, NSError *error) {
        // 提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        
        // 让底部控件结束刷新
        [self.contentTableView.mj_header endRefreshing];
    }];
}

-(UITableView *)contentTableView{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50)];
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        [_contentTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FSFoundStuffTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"FSFoundStuffTableViewCell"];
    }
    return _contentTableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return self.stuffAry.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1 || section == 2) {
        return 30.0f;
    } else {
        return 0.01f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 90;
    } else if (indexPath.section == 1) {
        return 90;
    }
    FSZuoPin *model = self.stuffAry[indexPath.row];
    // 文字的最大尺寸
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width , MAXFLOAT);
    // 计算文字的高度
    CGFloat textH = [model.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
    CGFloat gaoDu = 210 + 59 + 44 + textH + 20 + 44;
    return gaoDu;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.headerView = [FSFoundHeaderView viewFromXib];
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    if (section == 0) {
        self.headerView.titleLabel.text = @"热门标签";
    } else if (section == 1) {
        self.headerView.titleLabel.text = @"热门用户";
    } else if (section == 2) {
        self.headerView.titleLabel.text = @"热门推荐";
    }
    return self.headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellId = @"cellId";
        FSTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[FSTagTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.modelAry = self.tagsAry;
        return cell;
    } else if (indexPath.section == 1) {
        static NSString *cellId = @"FSUserTableViewCell";
        FSUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        cell.navi = self.navigationController;
        if (cell == nil) {
            cell = [[FSUserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.modelAry = self.userAry;
        return cell;
    } else if (indexPath.section == 2) {
        FSFoundStuffTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSFoundStuffTableViewCell"];
        cell.model = self.stuffAry[indexPath.row];
        return cell;
    }
    return nil;
}

@end
