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
#import "MJRefresh.h"
#import "MJExtension.h"
#import "FSHomeDetailViewController.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "SVProgressHUD.h"
#import "FSZuoPin.h"
#import "FSSearchViewController.h"

@interface FSHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

/**  */
@property(nonatomic,assign) NSInteger current_page;
/**  */
@property(nonatomic,assign) NSInteger total_rows;
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
    [self.contenTableView.mj_footer endRefreshing];
    self.current_page = 1;
    NSDictionary *params = @{
                             @"page" : @(self.current_page),
                             @"per_page" : @10
                             };
    FBRequest *request = [FBAPI getWithUrlString:@"/stuffs" requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        self.current_page = [result[@"meta"][@"pagination"][@"current_page"] integerValue];
        self.total_rows = [result[@"meta"][@"pagination"][@"total"] integerValue];
        NSArray *rows = result[@"data"];
         self.modelAry = [FSZuoPin mj_objectArrayWithKeyValuesArray:rows];
         [self.contenTableView reloadData];
         [self.contenTableView.mj_header endRefreshing];
         [self checkFooterState];
    } failure:^(FBRequest *request, NSError *error) {
        // 提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        
        // 让底部控件结束刷新
        [self.contenTableView.mj_header endRefreshing];
    }];
}

-(void)checkFooterState{
    self.contenTableView.mj_footer.hidden = self.modelAry.count == 0;
    if (self.modelAry.count == self.total_rows) {
        self.contenTableView.mj_footer.hidden = YES;
    }else{
        [self.contenTableView.mj_footer endRefreshing];
    }
}

-(void)loadMore{
    [self.contenTableView.mj_header endRefreshing];
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
        [self.modelAry addObjectsFromArray:ary];
        [self.contenTableView reloadData];
        [self.contenTableView.mj_footer endRefreshing];
        [self checkFooterState];
    } failure:^(FBRequest *request, NSError *error) {
        // 提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        
        // 让底部控件结束刷新
        [self.contenTableView.mj_footer endRefreshing];
    }];

}

-(UITableView *)contenTableView{
    if (!_contenTableView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _contenTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50)];
        _contenTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _contenTableView.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
        _contenTableView.delegate = self;
        _contenTableView.dataSource = self;
        _contenTableView.contentInset = UIEdgeInsetsMake(-10, 0, 0, 0);
    }
    return _contenTableView;
}

-(void)setupNav{
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithImage:@"home_search" highImage:nil title:nil target:self action:@selector(searchClick)];
    self.navigationItem.leftBarButtonItem = searchItem;
}

-(void)searchClick{
    FSSearchViewController *vc = [[FSSearchViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.modelAry.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FSHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    cell.model = self.modelAry[indexPath.section];
    cell.likeBtn.tag = indexPath.section;
    [cell.likeBtn addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - 点击喜欢按钮
-(void)likeClick:(UIButton*)sender{
    NSString *idStr = ((FSZuoPin*)self.modelAry[sender.tag]).idFeild;
    if (sender.selected) {
        FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/stuffs/:%@/cancelLike",idStr] requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            sender.selected = NO;
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"操作失败"];
        }];
    } else {
        FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/stuffs/:%@/dolike",idStr] requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            sender.selected = YES;
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"操作失败"];
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FSZuoPin *model = self.modelAry[indexPath.section];
    // 文字的最大尺寸
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width , MAXFLOAT);
    // 计算文字的高度
    CGFloat textH = [model.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
    CGFloat gaoDu = 210 + 59 + 44 + textH + 20 + 44;
    return gaoDu;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FSHomeDetailViewController *vc = [[FSHomeDetailViewController alloc] init];
    vc.model = self.modelAry[indexPath.section];
    vc.title = @"评论";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
