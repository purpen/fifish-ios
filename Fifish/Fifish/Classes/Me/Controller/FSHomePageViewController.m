//
//  FSHomePageViewController.m
//  Fifish
//
//  Created by THN-Dong on 16/7/27.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSHomePageViewController.h"
#import "FSConst.h"
#import "FSMeHeadTableViewCell.h"
#import "UIView+FSExtension.h"
#import "FSZuoPinTableViewController.h"
#import "FSGuanZhuTableViewController.h"
#import "FSFenSiTableViewController.h"
#import "Masonry.h"
#import "FSEditInformationViewController.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "FSZuoPin.h"
#import "AFNetworking.h"
#import "FBRequest.h"
#import "FBAPI.h"

typedef enum {
    FSTypeZuoPin = 1,
    FSTypeGuanZhu = 11,
    FSTypeFenSi = 21
} FSType;

@interface FSHomePageViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
/**  */
@property (nonatomic, strong) FSZuoPinTableViewController *zuoPin;
/**  */
@property (nonatomic, strong) FSGuanZhuTableViewController *guanZhu;
/**  */
@property (nonatomic, strong) FSFenSiTableViewController *fenSi;
/**  */
@property (nonatomic, strong) UITableView *contentTableView;
/**  */
@property (nonatomic, strong) UIScrollView *contentScrollview;
/** 当前选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
/** 上一次的请求参数 */
@property (nonatomic, strong) NSDictionary *params;

/** 作品数据 */
@property (nonatomic, strong) NSMutableArray *zuoPins;
/** 关注人数据 */
@property (nonatomic, strong) NSMutableArray *guanZhuPersons;
/** 粉丝人数据 */
@property (nonatomic, strong) NSMutableArray *fenSiPersons;
/** 当前页码 */
@property (nonatomic, assign) NSInteger page;
/** 类型 */
@property (nonatomic, assign) FSType type;

@end


@implementation FSHomePageViewController

-(NSMutableArray *)zuoPins{
    if (!_zuoPins) {
        _zuoPins = [NSMutableArray array];
    }
    return _zuoPins;
}

-(NSMutableArray *)guanZhuPersons{
    if (!_guanZhuPersons) {
        _guanZhuPersons = [NSMutableArray array];
    }
    return _guanZhuPersons;
}

-(NSMutableArray *)fenSiPersons{
    if (!_fenSiPersons) {
        _fenSiPersons = [NSMutableArray array];
    }
    return _fenSiPersons;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 设置导航栏
    [self setupNav];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.type = FSTypeZuoPin;
    
    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.contentTableView];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    
    
    [self setChanelView];
    // 添加刷新控件
    [self setupRefresh];
}

-(void)setupRefresh{
    self.contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    // 自动改变透明度
    self.contentTableView.mj_header.automaticallyChangeAlpha = YES;
    [self.contentTableView.mj_header beginRefreshing];
    self.contentTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

-(void)loadNew{
    // 结束上啦
    [self.contentTableView.mj_footer endRefreshing];
    switch (self.type) {
        case FSTypeZuoPin:
        {
            // 参数
            /*NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"a"] = @"list";
            params[@"c"] = @"data";
            self.params = params;
            // 发送请求
            FBRequest *request = [FBAPI postWithUrlString:nil requestDictionary:params delegate:self];
            [request startRequestSuccess:^(FBRequest *request, id result) {
                if (self.params != params) return;
                
                // 字典 -> 模型
                self.zuoPins = [FSZuoPin mj_objectArrayWithKeyValuesArray:result[@"list"]];
                self.zuoPin.zuoPins = self.zuoPins;
                
                // 结束刷新
                [self.contentTableView.mj_header endRefreshing];
                
                // 清空页码
                self.page = 0;
            } failure:^(FBRequest *request, NSError *error) {
                if (self.params != params) return;
                
                // 结束刷新
                [self.contentTableView.mj_header endRefreshing];
            }];*/
        }
            break;
            
        case FSTypeGuanZhu:
        {
            // 参数
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"a"] = @"list";
            params[@"c"] = @"data";
            self.params = params;
            // 发送请求
//            FBRequest *request = [FBAPI postWithUrlString:nil requestDictionary:params delegate:self];
//            [request startRequestSuccess:^(FBRequest *request, id result) {
//                if (self.params != params) return;
//                
//                // 字典 -> 模型
//                self.guanZhuPersons = [FSPerson mj_objectArrayWithKeyValuesArray:result[@"list"]];
//                
//                // 刷新表格
//                [self.guanZhu.tableView reloadData];
//                
//                // 结束刷新
//                [self.contentTableView.mj_header endRefreshing];
//                
//                // 清空页码
//                self.page = 0;
//            } failure:^(FBRequest *request, NSError *error) {
//                if (self.params != params) return;
//                
//                // 结束刷新
//                [self.contentTableView.mj_header endRefreshing];
//            }];
        }
            break;
            
        case FSTypeFenSi:
        {
            // 参数
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"a"] = @"list";
            params[@"c"] = @"data";
            self.params = params;
            // 发送请求
//            FBRequest *request = [FBAPI postWithUrlString:nil requestDictionary:params delegate:self];
//            [request startRequestSuccess:^(FBRequest *request, id result) {
//                if (self.params != params) return;
//                
//                // 字典 -> 模型
//                self.fenSiPersons = [FSPerson mj_objectArrayWithKeyValuesArray:result[@"list"]];
//                
//                // 刷新表格
//                [self.fenSi.tableView reloadData];
//                
//                // 结束刷新
//                [self.contentTableView.mj_header endRefreshing];
//                
//                // 清空页码
//                self.page = 0;
//            } failure:^(FBRequest *request, NSError *error) {
//                if (self.params != params) return;
//                
//                // 结束刷新
//                [self.contentTableView.mj_header endRefreshing];
//            }];
        }
            break;
            
        default:
            break;
    }
}

-(void)loadMore{
    // 结束上啦
    [self.contentTableView.mj_header endRefreshing];
    switch (self.type) {
        case FSTypeZuoPin:
        {
            // 参数
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"a"] = @"list";
            params[@"c"] = @"data";
            params[@"type"] = @(self.type);
            NSInteger page = self.page + 1;
            params[@"page"] = @(page);
            self.params = params;
            // 发送请求
//            FBRequest *request = [FBAPI postWithUrlString:nil requestDictionary:params delegate:self];
//            [request startRequestSuccess:^(FBRequest *request, id result) {
//                if (self.params != params) return;
//                
//                // 字典 -> 模型
//                NSArray *newzuoPins = [FSZuoPin mj_objectArrayWithKeyValuesArray:result[@"list"]];
//                [self.zuoPins addObjectsFromArray:newzuoPins];
//                
//                // 刷新表格
//                [self.zuoPin.tableView reloadData];
//                
//                // 结束刷新
//                [self.contentTableView.mj_footer endRefreshing];
//                
//                // 清空页码
//                self.page = page;
//            } failure:^(FBRequest *request, NSError *error) {
//                if (self.params != params) return;
//                
//                // 结束刷新
//                [self.contentTableView.mj_footer endRefreshing];
//            }];
        }
            break;
            
        case FSTypeGuanZhu:
        {
            // 参数
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"a"] = @"list";
            params[@"c"] = @"data";
            params[@"type"] = @(self.type);
            NSInteger page = self.page + 1;
            params[@"page"] = @(page);
            self.params = params;
            // 发送请求
//            FBRequest *request = [FBAPI postWithUrlString:nil requestDictionary:params delegate:self];
//            [request startRequestSuccess:^(FBRequest *request, id result) {
//                if (self.params != params) return;
//                
//                // 字典 -> 模型
//                NSArray *newGuanZhus = [FSZuoPin mj_objectArrayWithKeyValuesArray:result[@"list"]];
//                [self.guanZhuPersons addObjectsFromArray:newGuanZhus];
//                
//                // 刷新表格
//                [self.guanZhu.tableView reloadData];
//                
//                // 结束刷新
//                [self.contentTableView.mj_footer endRefreshing];
//                
//                // 清空页码
//                self.page = page;
//            } failure:^(FBRequest *request, NSError *error) {
//                if (self.params != params) return;
//                
//                // 结束刷新
//                [self.contentTableView.mj_footer endRefreshing];
//            }];
        }
            break;
            
        case FSTypeFenSi:
        {
            // 参数
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"a"] = @"list";
            params[@"c"] = @"data";
            params[@"type"] = @(self.type);
            NSInteger page = self.page + 1;
            params[@"page"] = @(page);
            self.params = params;
            // 发送请求
//            FBRequest *request = [FBAPI postWithUrlString:nil requestDictionary:params delegate:self];
//            [request startRequestSuccess:^(FBRequest *request, id result) {
//                if (self.params != params) return;
//                
//                // 字典 -> 模型
//                NSArray *newFenSis = [FSZuoPin mj_objectArrayWithKeyValuesArray:result[@"list"]];
//                [self.fenSiPersons addObjectsFromArray:newFenSis];
//                
//                // 刷新表格
//                [self.fenSi.tableView reloadData];
//                
//                // 结束刷新
//                [self.contentTableView.mj_footer endRefreshing];
//                
//                // 清空页码
//                self.page = page;
//            } failure:^(FBRequest *request, NSError *error) {
//                if (self.params != params) return;
//                
//                // 结束刷新
//                [self.contentTableView.mj_footer endRefreshing];
//            }];
        }
            break;
            
        default:
            break;
    }
}

-(FSZuoPinTableViewController *)zuoPin{
    if (!_zuoPin) {
        _zuoPin = [[FSZuoPinTableViewController alloc] init];
        _zuoPin.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 500);
    }
    return _zuoPin;
}

-(FSGuanZhuTableViewController *)guanZhu{
    if (!_guanZhu) {
        _guanZhu = [[FSGuanZhuTableViewController alloc] init];
        _guanZhu.view.backgroundColor = [UIColor yellowColor];
        _guanZhu.view.frame = CGRectMake(1*SCREEN_WIDTH, 0, SCREEN_WIDTH, 500);
    }
    return _guanZhu;
}

-(FSFenSiTableViewController *)fenSi{
    if (!_fenSi) {
        _fenSi = [[FSFenSiTableViewController alloc] init];
        _fenSi.view.backgroundColor = [UIColor greenColor];
        _fenSi.view.frame = CGRectMake(2*SCREEN_WIDTH, 0, SCREEN_WIDTH, 500);
    }
    return _fenSi;
}

-(void)setChanelView{
    [self.contentScrollview addSubview:self.zuoPin.view];
    
    [self.contentScrollview addSubview:self.guanZhu.view];

    [self.contentScrollview addSubview:self.fenSi.view];
}

-(void)setupNav{
    self.navigationController.navigationBarHidden = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, 26, 0, 0);
    [button setImage:[UIImage imageNamed:@"me_back"] forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setImage:[UIImage imageNamed:@"me_edit"] forState:UIControlStateNormal];
    [editBtn sizeToFit];
    [editBtn addTarget:self action:@selector(editBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editBtn];
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.top.mas_equalTo(button.mas_top).offset(0);
    }];
}

-(void)editBtn{
    FSEditInformationViewController *vc = [[FSEditInformationViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}



-(UITableView *)contentTableView{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] init];
        _contentTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _contentTableView;
}

-(UIScrollView *)contentScrollview{
    if (!_contentScrollview) {
        _contentScrollview = [[UIScrollView alloc] init];
        _contentScrollview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 500);
        _contentScrollview.delegate = self;
        _contentScrollview.pagingEnabled = YES;
        _contentScrollview.bounces = NO;
        _contentScrollview.contentSize = CGSizeMake(_contentScrollview.width * 3, 0);
    }
    return _contentScrollview;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        FSMeHeadTableViewCell *cell = [[FSMeHeadTableViewCell alloc] init];
        cell.backgroundColor = [UIColor redColor];
        switch (self.type) {
            case FSTypeZuoPin:
                cell.zuoPinShu.textColor = DEFAULT_COLOR;
                cell.zuoPinLabel.textColor = DEFAULT_COLOR;
                break;
                
            case FSTypeGuanZhu:
                cell.guanZhuLabel.textColor = DEFAULT_COLOR;
                cell.guanZhuShuLabel.textColor = DEFAULT_COLOR;
                break;
                
            case FSTypeFenSi:
                cell.fenSiLabel.textColor = DEFAULT_COLOR;
                cell.fenSiShuLabel.textColor = DEFAULT_COLOR;
                break;
                
            default:
                break;
        }
        [cell.zuoPinBtn addTarget:self action:@selector(zuoPinBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.guanZhuBtn addTarget:self action:@selector(guanZhuBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.fenSiBtn addTarget:self action:@selector(fenSiBtn:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell.contentView addSubview:self.contentScrollview];
        return cell;
    }
}

-(void)zuoPinBtn:(UIButton*)sender{
    self.type = FSTypeZuoPin;
    self.selectedButton.enabled = YES;
    sender.enabled = NO;
    self.selectedButton = sender;
    FSMeHeadTableViewCell *cell = [_contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.guanZhuLabel.textColor = [UIColor whiteColor];
    cell.guanZhuShuLabel.textColor = [UIColor whiteColor];
    cell.zuoPinShu.textColor = DEFAULT_COLOR;
    cell.zuoPinLabel.textColor = DEFAULT_COLOR;
    cell.fenSiLabel.textColor = [UIColor whiteColor];
    cell.fenSiShuLabel.textColor = [UIColor whiteColor];
    // 滚动
    CGPoint offset = _contentScrollview.contentOffset;
    offset.x = 0 * self.contentScrollview.width;
    [self.contentScrollview setContentOffset:offset animated:YES];
}

-(void)guanZhuBtn:(UIButton*)sender{
    self.type = FSTypeGuanZhu;
    self.selectedButton.enabled = YES;
    sender.enabled = NO;
    self.selectedButton = sender;
    FSMeHeadTableViewCell *cell = [_contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.guanZhuLabel.textColor = DEFAULT_COLOR;
    cell.guanZhuShuLabel.textColor = DEFAULT_COLOR;
    cell.zuoPinShu.textColor = [UIColor whiteColor];
    cell.zuoPinLabel.textColor = [UIColor whiteColor];
    cell.fenSiLabel.textColor = [UIColor whiteColor];
    cell.fenSiShuLabel.textColor = [UIColor whiteColor];
    // 滚动
    CGPoint offset = _contentScrollview.contentOffset;
    offset.x = 1 * self.contentScrollview.width;
    [self.contentScrollview setContentOffset:offset animated:YES];
}

-(void)fenSiBtn:(UIButton*)sender{
    self.type = FSTypeFenSi;
    self.selectedButton.enabled = YES;
    sender.enabled = NO;
    self.selectedButton = sender;
    FSMeHeadTableViewCell *cell = [_contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.guanZhuLabel.textColor = [UIColor whiteColor];
    cell.guanZhuShuLabel.textColor = [UIColor whiteColor];
    cell.zuoPinShu.textColor = [UIColor whiteColor];
    cell.zuoPinLabel.textColor = [UIColor whiteColor];
    cell.fenSiLabel.textColor = DEFAULT_COLOR;
    cell.fenSiShuLabel.textColor = DEFAULT_COLOR;
    // 滚动
    CGPoint offset = _contentScrollview.contentOffset;
    offset.x = 2 * self.contentScrollview.width;
    [self.contentScrollview setContentOffset:offset animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 250;
    }else{
        return 500;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.contentScrollview]) {
        // 点击按钮
        NSInteger index = scrollView.contentOffset.x / scrollView.width;
        FSMeHeadTableViewCell *cell = [_contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (index == 0) {
            [self zuoPinBtn:cell.zuoPinBtn];
        }else if (index == 1){
            [self guanZhuBtn:cell.guanZhuBtn];
        }else if (index == 2){
            [self fenSiBtn:cell.fenSiBtn];
        }
    }
}

@end
