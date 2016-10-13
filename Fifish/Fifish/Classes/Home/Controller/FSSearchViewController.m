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

@interface FSSearchViewController () <UISearchBarDelegate, SGTopTitleViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *cancelBTn;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
/**  */
@property (nonatomic, strong) SGTopTitleView *segmentedControl;
/**
    1、图片
    2、视频
    3、用户 
 */
@property (nonatomic, strong) NSNumber *type;
/**  */
@property (nonatomic, strong) NSMutableArray *videoAry;
/**  */
@property (nonatomic, strong) NSMutableArray *pictureAry;
/**  */
@property (nonatomic, strong) NSMutableArray *userAry;
/**  */
@property (nonatomic, strong) UITableView *myTableView;
/**  */
@property (nonatomic, assign) NSInteger current_page;
/**  */
@property (nonatomic, assign) NSInteger total;
/**  */
@property(nonatomic,copy) NSString *tid;
/**  */
@property (nonatomic, strong) UIView *lineView;
/**  */
@property (nonatomic, strong) FSMoreView *moreView;
/**  */
@property (nonatomic, strong) FSReportView *reportView;

@end

@implementation FSSearchViewController

-(FSMoreView *)moreView{
    if (!_moreView) {
        _moreView = [FSMoreView viewFromXib];
    }
    return _moreView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(NSMutableArray *)videoAry{
    if (!_videoAry) {
        _videoAry = [NSMutableArray array];
    }
    return _videoAry;
}

-(NSMutableArray *)pictureAry{
    if (!_pictureAry) {
        _pictureAry = [NSMutableArray array];
    }
    return _pictureAry;
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
    }
    return _myTableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.tid isEqualToString:@"0"]) {
        //用户
        return self.userAry.count;
    } else if ([self.tid isEqualToString:@"1"]) {
        //图片
        return self.pictureAry.count;
    } else if ([self.tid isEqualToString:@"2"]) {
        //视频
        return self.videoAry.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.tid isEqualToString:@"0"]) {
        //用户
        static NSString *userCell = @"userCell";
        FSListUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userCell];
        if (cell == nil) {
            cell = [[FSListUserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userCell];
        }
        //传入模型
        return cell;
    } else if ([self.tid isEqualToString:@"1"]) {
        //图片
        FSFoundStuffTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSFoundStuffTableViewCell"];
        //传入模型
        FSZuoPin *model = self.pictureAry[indexPath.row];
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
        cell.pictuerView.tapBTn.tag = indexPath.row;
        [cell.pictuerView.tapBTn addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else if ([self.tid isEqualToString:@"2"]) {
        //视频
        
    }
    return nil;
}

#pragma mark - 点击图片
-(void)imageClick:(UIButton*)sender{
    FSBigImageViewController *vc = [[FSBigImageViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    FSZuoPin *model = self.pictureAry[sender.tag];
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
    vc.model = self.pictureAry[sender.tag];
    vc.title = @"评论";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 点击喜欢按钮
-(void)likeClick:(UIButton*)sender{
    NSString *idStr = ((FSZuoPin*)self.pictureAry[sender.tag]).idFeild;
    if (sender.selected) {
        FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/stuffs/%@/cancelike",idStr] requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            sender.selected = NO;
            ((FSZuoPin*)self.pictureAry[sender.tag]).is_love = 0;
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"操作失败"];
        }];
    } else {
        FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/stuffs/%@/dolike",idStr] requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            sender.selected = YES;
            ((FSZuoPin*)self.pictureAry[sender.tag]).is_love = 1;
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"操作失败"];
        }];
    }
}

#pragma mark - 关注
-(void)fucosClick:(UIButton*)sender{
    if (sender.selected) {
        //取消关注
        FSZuoPin *model = self.pictureAry[sender.tag];
        FBRequest *request = [FBAPI deleteWithUrlString:[NSString stringWithFormat:@"/user/%@/cancelFollow",model.user_id] requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            for (int i = 0; i < self.pictureAry.count; i ++) {
                FSZuoPin *cellModel = self.pictureAry[i];
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
        FSZuoPin *model = self.pictureAry[sender.tag];
        FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/user/%@/follow",model.user_id] requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            for (int i = 0; i < self.pictureAry.count; i ++) {
                FSZuoPin *cellModel = self.pictureAry[i];
                NSLog(@"cell的ID %@",cellModel.user_id);
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
    if ([self.tid isEqualToString:@"0"]) {
        //用户
        return self.userAry.count;
    } else if ([self.tid isEqualToString:@"1"]) {
        //图片
        FSZuoPin *model = self.pictureAry[indexPath.row];
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width , MAXFLOAT);
        CGFloat textH = [model.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
        CGFloat gaoDu = 210 + 59 + 44 + textH + 20 + 44;
        return gaoDu;
    } else if ([self.tid isEqualToString:@"2"]) {
        //视频
        return self.videoAry.count;
    }
    return 0;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.type = @(2);
    [self.view addSubview:self.myTableView];
    [self setupRefresh];
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
    NSString *type2;
    if ([self.type isEqualToNumber:@(2)]) {
        //type = 2 tid = 0
        type2 = @"2";
        self.tid = @"0";//用户
    } else {
        //type = 1
        type2 = @"1";
        if ([self.type isEqualToNumber:@(1)]) {
            //tid = 1
            self.tid = @"1";//图片
        } else {
            //tid = 2
            self.tid = @"2";//视频
        }
    }
    FBRequest *request = [FBAPI getWithUrlString:@"/search/list" requestDictionary:@{
                                                                                     @"page" : @(self.current_page),
                                                                                     @"per_page" : @(10),
                                                                                     @"str" : self.searchBar.text,
                                                                                     @"type" : type2,
                                                                                     @"tid" : self.tid,
                                                                                     @"evt" : @(1),
                                                                                     @"sort" : @(1)
                                                                                     } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        [self.myTableView.mj_header endRefreshing];
        NSLog(@"搜索  %@",result);
        self.current_page = [result[@"meta"][@"pagination"][@"current_page"] integerValue];
        self.total = [result[@"meta"][@"pagination"][@"total"] integerValue];
        if (self.total == 0) {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Can't find the content", nil)];
        }
        NSArray *dataAry = result[@"data"];
        if ([self.tid isEqualToString:@"0"]) {
            //用户
            
        } else if ([self.tid isEqualToString:@"1"]) {
            //图片
            [self.pictureAry removeAllObjects];
            for (int i = 0; i < dataAry.count; i ++) {
                NSDictionary *dict = dataAry[i];
                NSDictionary *stuff = dict[@"stuff"];
                FSZuoPin *model = [FSZuoPin mj_objectWithKeyValues:stuff];
                [self.pictureAry addObject:model];
            }
        } else if ([self.tid isEqualToString:@"2"]) {
            //视频
            
        }
        [self.myTableView reloadData];
        [self checkFooterState];
    } failure:^(FBRequest *request, NSError *error) {
        [self.myTableView.mj_header endRefreshing];
    }];
}

-(void)checkFooterState{
    if ([self.tid isEqualToString:@"0"]) {
        //用户
        self.myTableView.mj_footer.hidden = self.userAry.count == 0;
        if (self.userAry.count == self.total) {
            self.myTableView.mj_footer.hidden = YES;
        }else{
            [self.myTableView.mj_footer endRefreshing];
        }
    } else if ([self.tid isEqualToString:@"1"]) {
        //图片
        self.myTableView.mj_footer.hidden = self.pictureAry.count == 0;
        if (self.pictureAry.count == self.total) {
            self.myTableView.mj_footer.hidden = YES;
        }else{
            [self.myTableView.mj_footer endRefreshing];
        }
    } else if ([self.tid isEqualToString:@"2"]) {
        //视频
        self.myTableView.mj_footer.hidden = self.videoAry.count == 0;
        if (self.videoAry.count == self.total) {
            self.myTableView.mj_footer.hidden = YES;
        }else{
            [self.myTableView.mj_footer endRefreshing];
        }
    }
}

-(void)loadMore{
    [self.myTableView.mj_header endRefreshing];
    NSString *type2;
    if ([self.type isEqualToNumber:@(2)]) {
        //type = 2 tid = 0
        type2 = @"2";
        self.tid = @"0";//用户
    } else {
        //type = 1
        type2 = @"1";
        if ([self.type isEqualToNumber:@(1)]) {
            //tid = 1
            self.tid = @"1";//图片
        } else {
            //tid = 2
            self.tid = @"2";//视频
        }
    }
    FBRequest *request = [FBAPI getWithUrlString:@"/search/list" requestDictionary:@{
                                                                                     @"page" : @(++self.current_page),
                                                                                     @"per_page" : @(10),
                                                                                     @"str" : self.searchBar.text,
                                                                                     @"type" : type2,
                                                                                     @"tid" : self.tid,
                                                                                     @"evt" : @(1),
                                                                                     @"sort" : @(1)
                                                                                     } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        [self.myTableView.mj_footer endRefreshing];
        NSLog(@"搜索  %@",result);
        self.current_page = [result[@"meta"][@"pagination"][@"current_page"] integerValue];
        self.total = [result[@"meta"][@"pagination"][@"total"] integerValue];
        if (self.total == 0) {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Can't find the content", nil)];
        }
        NSArray *rows = result[@"data"];
        if ([self.tid isEqualToString:@"0"]) {
            //用户
            
        } else if ([self.tid isEqualToString:@"1"]) {
            //图片
            
        } else if ([self.tid isEqualToString:@"2"]) {
            //视频
            
        }
        //self.pictureAry = [];
        [self.myTableView reloadData];
        [self checkFooterState];
    } failure:^(FBRequest *request, NSError *error) {
        [self.myTableView.mj_footer endRefreshing];
    }];
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
    self.type = [NSNumber numberWithInteger:index];
    //进行网络请求
    [self.myTableView.mj_header beginRefreshing];
}


- (IBAction)cancelClick:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
