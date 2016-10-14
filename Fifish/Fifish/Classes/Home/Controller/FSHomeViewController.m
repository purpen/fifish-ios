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
#import "FSBigImageViewController.h"
#import "FSReleasePictureViewController.h"
#import "FSNavigationViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface FSHomeViewController ()<UITableViewDelegate,UITableViewDataSource,FSHomeDetailViewControllerDelegate>

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
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
        _contenTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50) style:UITableViewStylePlain]; 
        _contenTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _contenTableView.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
        _contenTableView.delegate = self;
        _contenTableView.dataSource = self;
        _contenTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _contenTableView;
}

-(void)setupNav{
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithImage:@"home_search" highImage:nil title:nil target:self action:@selector(searchClick)];
    UIBarButtonItem *tempItem = [UIBarButtonItem itemWithImage:@"home_search" highImage:nil title:nil target:self action:@selector(tempClick)];
    self.navigationItem.leftBarButtonItem = searchItem;
    self.navigationItem.rightBarButtonItem = tempItem;
}

-(void)tempClick{
    FSReleasePictureViewController *vc = [[FSReleasePictureViewController alloc] init];
    vc.type = @(1);
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)searchClick{
    FSSearchViewController *vc = [[FSSearchViewController alloc] init];
    FSNavigationViewController *navi = [[FSNavigationViewController alloc] initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:nil];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.modelAry.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FSHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    cell.navi = self.navigationController;
    cell.model = self.modelAry[indexPath.section];
    cell.likeBtn.tag = indexPath.section;
    cell.commendBtn.tag = indexPath.section;
    [cell.likeBtn addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.commendBtn addTarget:self action:@selector(commendClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.pictuerView.tapBTn.tag = indexPath.section;
    [cell.pictuerView.tapBTn addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.videoView.tapBtn.tag = indexPath.section;
    [cell.videoView.tapBtn addTarget:self action:@selector(videoClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - 视频播放
-(void)videoClick:(UIButton*)sender{
    //开始播放视频
    FSZuoPin *model = self.modelAry[sender.tag];
    MPMoviePlayerViewController *mvPlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:model.srcfile]];
    NSLog(@"播放地址 %@", model.srcfile);
    [self.navigationController presentViewController:mvPlayer animated:YES completion:nil];
}

#pragma mark - 点击图片
-(void)imageClick:(UIButton*)sender{
    FSBigImageViewController *vc = [[FSBigImageViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    FSZuoPin *model = self.modelAry[sender.tag];
    vc.imageUrl = model.file_large;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 更多按钮
-(void)moreClick:(UIButton*)sender{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *reportAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"report", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       //点击举报
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
        UIAlertController *reportAlertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *garbageAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"garbage content", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //垃圾内容的网络请求
            
        }];
        UIAlertAction *indecentAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"inelegant content", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //内容不雅举报
            
        }];
        UIAlertAction *reportCancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [reportAlertC addAction:garbageAction];
        [reportAlertC addAction:indecentAction];
        [reportAlertC addAction:reportCancelAction];
        [self presentViewController:reportAlertC animated:YES completion:nil];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertC addAction:reportAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - 评论按钮
-(void)commendClick: (UIButton *) sender{
    FSHomeDetailViewController *vc = [[FSHomeDetailViewController alloc] init];
    vc.model = self.modelAry[sender.tag];
    vc.title = @"评论";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 点击喜欢按钮
-(void)likeClick:(UIButton*)sender{
    NSString *idStr = ((FSZuoPin*)self.modelAry[sender.tag]).idFeild;
    if (sender.selected) {
        FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/stuffs/%@/cancelike",idStr] requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            sender.selected = NO;
            ((FSZuoPin*)self.modelAry[sender.tag]).is_love = 0;
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"操作失败"];
        }];
    } else {
        FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/stuffs/%@/dolike",idStr] requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            sender.selected = YES;
            ((FSZuoPin*)self.modelAry[sender.tag]).is_love = 1;
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"操作失败"];
        }];
    }
}

#pragma mark - FSHomeDetailViewControllerDelegate
-(void)lickClick:(BOOL)btnState :(NSString *)idFiled{
    int n;
    for (int i = 0; i < self.modelAry.count; i ++) {
        NSString *idStr = ((FSZuoPin*)self.modelAry[i]).idFeild;
        if ([idStr isEqualToString:idFiled]) {
            n = i;
            break;
        }
    }
    FSHomeViewCell *cell = [self.contenTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:n]];
    cell.commendBtn.selected = btnState;
    cell.model.idFeild = idFiled;
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
