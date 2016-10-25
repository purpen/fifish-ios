//
//  FSSearchViewController.m
//  Fifish
//
//  Created by THN-Dong on 16/9/23.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSSearchViewController.h"
#import "SGTopTitleView.h"
#import "UIColor+FSExtension.h"
#import "UIView+FSExtension.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "SVProgressHUD.h"
#import "FSListUserTableViewCell.h"
#import "FSFoundStuffTableViewCell.h"
#import "MJRefresh.h"
#import "FSZuoPin.h"
#import "MJExtension.h"
#import "FSHomeDetailViewController.h"
#import "FSBigImageViewController.h"
#import "FSMoreView.h"
#import "FSReportView.h"
#import "FSUserModel.h"
#import "FSHomePageViewController.h"
#import "FSPlayViewController.h"

@interface FSSearchViewController () <UISearchBarDelegate, SGTopTitleViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *cancelBTn;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
/**  */
@property (nonatomic, strong) SGTopTitleView *segmentedControl;
/**
    1、作品
    2、用户
 */
@property (nonatomic, strong) NSNumber *type;
/**  */
@property (nonatomic, strong) NSMutableArray *userAry;
/**  */
@property (nonatomic, strong) UITableView *myTableView;
/**  */
@property (nonatomic, assign) NSInteger current_page;
/**  */
@property (nonatomic, assign) NSInteger total;
/**
 1、图片
 2、视频
 */
@property(nonatomic,strong) NSNumber *tid;
/**  */
@property (nonatomic, strong) UIView *lineView;
/**  */
@property (nonatomic, strong) FSMoreView *moreView;
/**  */
@property (nonatomic, strong) FSReportView *reportView;
/**  */
@property (nonatomic, strong) NSMutableArray *stuffAry;

@end

@implementation FSSearchViewController

-(NSMutableArray *)stuffAry{
    if (!_stuffAry) {
        _stuffAry = [NSMutableArray array];
    }
    return _stuffAry;
}

-(FSMoreView *)moreView{
    if (!_moreView) {
        _moreView = [FSMoreView viewFromXib];
        _moreView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 88);
    }
    return _moreView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(NSMutableArray *)userAry{
    if (!_userAry) {
        _userAry = [NSMutableArray array];
    }
    return _userAry;
}

-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.segmentedControl.y + self.segmentedControl.height, SCREEN_WIDTH, SCREEN_HEIGHT - self.segmentedControl.y - self.segmentedControl.height)];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.showsVerticalScrollIndicator = NO;
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FSFoundStuffTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"FSFoundStuffTableViewCell"];
        [_myTableView registerNib:[UINib nibWithNibName:@"FSListUserTableViewCell" bundle:nil] forCellReuseIdentifier:@"FSListUserTableViewCell"];
    }
    return _myTableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.type isEqualToNumber:@(2)]) {
        //用户
        return self.userAry.count;
    } else if ([self.type isEqualToNumber:@(1)]) {
        if (self.stuffAry.count == 0) {
            self.myTableView.mj_footer.hidden = YES;
        }
        return self.stuffAry.count;
    }
    return 0;
}

-(void)userFcousClick:(UIButton*)sender{
    if (sender.selected) {
        FBRequest *request = [FBAPI deleteWithUrlString:[NSString stringWithFormat:@"/user/%@/cancelFollow",((FSUserModel*)self.userAry[sender.tag]).userId] requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            sender.selected = NO;
            sender.backgroundColor = [UIColor whiteColor];
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    } else {
        FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/user/%@/follow",((FSUserModel*)self.userAry[sender.tag]).userId] requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            sender.selected = YES;
            sender.backgroundColor = [UIColor colorWithHexString:@"0995f8"];
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.type isEqualToNumber:@(2)]) {
        //用户
        FSListUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSListUserTableViewCell"];
        //传入模型
        FSUserModel *model = self.userAry[indexPath.row];
        cell.userModel = model;
        cell.fucosBtn.tag = indexPath.row;
        [cell.fucosBtn addTarget:self action:@selector(userFcousClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else if ([self.type isEqualToNumber:@(1)]) {
        FSFoundStuffTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSFoundStuffTableViewCell"];
        //传入模型
        FSZuoPin *model = self.stuffAry[indexPath.row];
        cell.model = model;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.type isEqualToNumber:@(2)]) {
        FSHomePageViewController *vc = [[FSHomePageViewController alloc] init];
        FSUserModel *model = self.userAry[indexPath.row];
        vc.userId = model.userId;
        [self.navigationController pushViewController:vc animated:YES];
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

#pragma mark - 更多按钮
-(void)moreClick:(UIButton*)sender{
    [UIView animateWithDuration:0.25 animations:^{
        self.moreView.y = SCREEN_HEIGHT - 88;
    }];
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
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                    [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
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
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                    [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.type isEqualToNumber:@(2)]) {
        return 60;
    } else if ([self.type isEqualToNumber:@(1)]) {
        FSZuoPin *model = self.stuffAry[indexPath.row];
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width , MAXFLOAT);
        CGFloat textH = [model.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
        CGFloat gaoDu = 210 + 59 + 44 + textH + 20 + 44;
        return gaoDu + 10;
    }
    return 0;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.type = @(1);
    self.tid = @(2);
    [self.view addSubview:self.myTableView];
    [self setupRefresh];
    
    [self.view addSubview:self.moreView];
}



-(void)setupRefresh{
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    // 自动改变透明度
    self.myTableView.mj_header.automaticallyChangeAlpha = YES;
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

-(void)loadNew{
    [self.myTableView.mj_footer endRefreshing];
    self.current_page = 1;
    FBRequest *request = [FBAPI getWithUrlString:@"/search/list" requestDictionary:@{
                                                                                     @"page" : @(self.current_page),
                                                                                     @"per_page" : @(10),
                                                                                     @"str" : self.searchBar.text,
                                                                                     @"type" : self.type,
                                                                                     @"tid" : self.tid,
                                                                                     @"evt" : @(1),
                                                                                     @"sort" : @(1)
                                                                                     } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        [self.myTableView.mj_header endRefreshing];
        self.current_page = [result[@"meta"][@"pagination"][@"current_page"] integerValue];
        self.total = [result[@"meta"][@"pagination"][@"total"] integerValue];
        if (self.total == 0) {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Can't find the content", nil)];
        }
        NSArray *dataAry = result[@"data"];
        
        if ([self.type isEqualToNumber:@(2)]) {
            //用户
            [self.userAry removeAllObjects];
            NSArray *dataAry = result[@"data"];
            for (NSDictionary *dict in dataAry) {
                NSDictionary *userDict = dict[@"user"];
                FSUserModel *model = [FSUserModel mj_objectWithKeyValues:userDict];
                [self.userAry addObject:model];
            }
            [self.myTableView reloadData];
            [self checkFooterState];
        } else if ([self.type isEqualToNumber:@(1)]) {
            [self.stuffAry removeAllObjects];
            for (int i = 0; i < dataAry.count; i ++) {
                NSDictionary *dict = dataAry[i];
                NSDictionary *stuff = dict[@"stuff"];
                FSZuoPin *model = [FSZuoPin mj_objectWithKeyValues:stuff];
                [self.stuffAry addObject:model];
            }
        }
        [self.myTableView reloadData];
        [self checkFooterState];
    } failure:^(FBRequest *request, NSError *error) {
        [self.myTableView.mj_header endRefreshing];
    }];
}

-(void)loadMore{
    [self.myTableView.mj_header endRefreshing];
    FBRequest *request = [FBAPI getWithUrlString:@"/search/list" requestDictionary:@{
                                                                                     @"page" : @(++self.current_page),
                                                                                     @"per_page" : @(10),
                                                                                     @"str" : self.searchBar.text,
                                                                                     @"type" : self.type,
                                                                                     @"tid" : self.tid,
                                                                                     @"evt" : @(1),
                                                                                     @"sort" : @(1)
                                                                                     } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        [self.myTableView.mj_footer endRefreshing];
        self.current_page = [result[@"meta"][@"pagination"][@"current_page"] integerValue];
        self.total = [result[@"meta"][@"pagination"][@"total"] integerValue];
        if (self.total == 0) {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Can't find the content", nil)];
        }
        NSArray *dataAry = result[@"data"];
        
        if ([self.type isEqualToNumber:@(2)]) {
            //用户
            NSArray *dataAry = result[@"data"];
            for (NSDictionary *dict in dataAry) {
                NSDictionary *userDict = dict[@"user"];
                FSUserModel *model = [FSUserModel mj_objectWithKeyValues:userDict];
                [self.userAry addObject:model];
            }
            [self.myTableView reloadData];
            [self checkFooterState];
        } else if ([self.type isEqualToNumber:@(1)]) {
            for (int i = 0; i < dataAry.count; i ++) {
                NSDictionary *dict = dataAry[i];
                NSDictionary *stuff = dict[@"stuff"];
                FSZuoPin *model = [FSZuoPin mj_objectWithKeyValues:stuff];
                [self.stuffAry addObject:model];
            }
        }
        [self.myTableView reloadData];
        [self checkFooterState];
    } failure:^(FBRequest *request, NSError *error) {
        [self.myTableView.mj_footer endRefreshing];
    }];
}

-(void)checkFooterState{
    if ([self.type isEqualToNumber:@(2)]) {
        //用户
        self.myTableView.mj_footer.hidden = self.userAry.count == 0;
        if (self.userAry.count == self.total) {
            self.myTableView.mj_footer.hidden = YES;
        }else{
            [self.myTableView.mj_footer endRefreshing];
        }
    } else if ([self.type isEqualToNumber:@(1)]) {
        self.myTableView.mj_footer.hidden = self.stuffAry.count == 0;
        if (self.stuffAry.count == self.total) {
            self.myTableView.mj_footer.hidden = YES;
        }else{
            [self.myTableView.mj_footer endRefreshing];
        }
    }
}

-(SGTopTitleView *)segmentedControl{
    if (!_segmentedControl) {
        _segmentedControl = [[SGTopTitleView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, 44)];
        _segmentedControl.staticTitleArr = @[NSLocalizedString(@"video", nil), NSLocalizedString(@"picture", nil), NSLocalizedString(@"user", nil)];
        _segmentedControl.backgroundColor = [UIColor whiteColor];
        _segmentedControl.delegate_SG = self;
    }
    return _segmentedControl;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 65 + 44, SCREEN_WIDTH, 1)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    }
    return _lineView;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (searchBar.text.length == 0) {
        
    } else {
        [self.view addSubview:self.segmentedControl];
        [self.view addSubview:self.lineView];
        [self.view endEditing:YES];
        //进行网络请求
        [self.myTableView.mj_header beginRefreshing];
    }
}

#pragma mark - - - SGTopScrollMenu代理方法
- (void)SGTopTitleView:(SGTopTitleView *)topTitleView didSelectTitleAtIndex:(NSInteger)index {
    if (index == 0) {
        self.type = @(1);
        self.tid = @(2);
    } else if (index == 1) {
        self.type = @(1);
        self.tid = @(1);
    } else if (index == 2) {
        self.type = @(2);
        self.tid = @(0);
    }
    //进行网络请求
    [self.myTableView.mj_header beginRefreshing];
}


- (IBAction)cancelClick:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
