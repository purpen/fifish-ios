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
#import "FSBigImageViewController.h"
#import "FSHomeDetailViewController.h"
#import "FSPlayViewController.h"
#import "SDCycleScrollView.h"

@interface FSFoundViewController () <UITableViewDelegate,UITableViewDataSource, SDCycleScrollViewDelegate>

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
/**  */
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
/**  */
@property (nonatomic, strong) NSMutableArray *imageUrlAry;

@end

@implementation FSFoundViewController

-(NSMutableArray *)imageUrlAry{
    if (!_imageUrlAry) {
        _imageUrlAry = [NSMutableArray array];
    }
    return _imageUrlAry;
}

-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 211) delegate:self placeholderImage:[UIImage imageNamed:@"shuffling_default"]];
        _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"found_current"];
        _cycleScrollView.pageDotImage = [UIImage imageNamed:@"found_default"];
    }
    return _cycleScrollView;
}

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
    [self imageUrlsRequest];
    self.current_page = 1;
    [self tagRequest];
    [self userRequest];
    [self stuffRequest];
}

-(void)imageUrlsRequest{
    FBRequest *request = [FBAPI getWithUrlString:@"/gateway/columns" requestDictionary:@{
                                                                                         @"name" : @"app_discover_slide"
                                                                                         } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        [self.imageUrlAry removeAllObjects];
        NSArray *dataAry = result[@"data"];
        for (NSDictionary *dict in dataAry) {
            NSDictionary *coverDict = dict[@"cover"];
            NSDictionary *fileDict = coverDict[@"file"];
            NSString *large = fileDict[@"large"];
            [self.imageUrlAry addObject:large];
        }
        self.cycleScrollView.imageURLStringsGroup = self.imageUrlAry;
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
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
        NSLog(@"标签  %@",result);
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
        _contentTableView.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
        _contentTableView.showsVerticalScrollIndicator = NO;
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        [_contentTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FSFoundStuffTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"FSFoundStuffTableViewCell"];
        _contentTableView.tableHeaderView = self.cycleScrollView;
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
        return 100;
    }
    FSZuoPin *model = self.stuffAry[indexPath.row];
    // 文字的最大尺寸
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width , MAXFLOAT);
    // 计算文字的高度
    CGFloat textH = [model.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
    CGFloat gaoDu = 210 + 59 + 44 + textH + 20 + 44;
    return gaoDu + 20;
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
        cell.navc = self.navigationController;
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
        cell.fucosBtn.tag = indexPath.row;
        [cell.fucosBtn addTarget:self action:@selector(fucosClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.navi = self.navigationController;
        cell.likeBtn.tag = indexPath.row;
        cell.commendBtn.tag = indexPath.row;
        [cell.likeBtn addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.commendBtn addTarget:self action:@selector(commendClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.pictuerView.tapBTn.tag = indexPath.row;
        [cell.pictuerView.tapBTn addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.videoView.tapBtn.tag = indexPath.row;
        [cell.videoView.tapBtn addTarget:self action:@selector(videoClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return nil;
}

#pragma mark - 视频播放
-(void)videoClick:(UIButton*)sender{
    //开始播放视频
    FSZuoPin *model = self.stuffAry[sender.tag];
    FSPlayViewController *mvPlayer = [[FSPlayViewController alloc] init];
    mvPlayer.videoUrl = [NSURL URLWithString:model.srcfile];
    [self presentViewController:mvPlayer animated:YES completion:nil];
}

#pragma mark - 关注
-(void)fucosClick:(UIButton*)sender{
    if (sender.selected) {
        //取消关注
        FSZuoPin *model = self.stuffAry[sender.tag];
        FBRequest *request = [FBAPI deleteWithUrlString:[NSString stringWithFormat:@"/user/%@/cancelFollow",model.user_id] requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            for (int i = 0; i < self.stuffAry.count; i ++) {
                FSZuoPin *cellModel = self.stuffAry[i];
                if ([cellModel.user_id isEqualToString:model.user_id]) {
                    cellModel.is_follow = 0;
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:2];
                    [self.contentTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    } else {
        //关注
        FSZuoPin *model = self.stuffAry[sender.tag];
        FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/user/%@/follow",model.user_id] requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            for (int i = 0; i < self.stuffAry.count; i ++) {
                FSZuoPin *cellModel = self.stuffAry[i];
                if ([cellModel.user_id isEqualToString:model.user_id]) {
                    cellModel.is_follow = 1;
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:2];
                    [self.contentTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    }
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
        UIAlertAction *reportCancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    vc.model = self.stuffAry[sender.tag];
    vc.title = @"评论";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 点击喜欢按钮
-(void)likeClick:(UIButton*)sender{
    NSString *idStr = ((FSZuoPin*)self.stuffAry[sender.tag]).idFeild;
    if (sender.selected) {
        FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/stuffs/%@/cancelike",idStr] requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            sender.selected = NO;
            ((FSZuoPin*)self.stuffAry[sender.tag]).is_love = 0;
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"操作失败"];
        }];
    } else {
        FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/stuffs/%@/dolike",idStr] requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            sender.selected = YES;
            ((FSZuoPin*)self.stuffAry[sender.tag]).is_love = 1;
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"操作失败"];
        }];
    }
}

#pragma mark - 点击图片
-(void)imageClick:(UIButton*)sender{
    FSBigImageViewController *vc = [[FSBigImageViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    FSZuoPin *model = self.stuffAry[sender.tag];
    vc.imageUrl = model.file_large;
    [self presentViewController:vc animated:YES completion:nil];
}

@end
