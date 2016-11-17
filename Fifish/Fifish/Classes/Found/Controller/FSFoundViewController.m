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
#import "UIBarButtonItem+FSExtension.h"
#import "FSFindFriendViewController.h"
#import "FSSearchViewController.h"
#import "FSNavigationViewController.h"
#import "FSReportViewController.h"
#import "CTFrameParserConfig.h"
#import "CoreTextData.h"
#import "CTFrameParser.h"
#import "NSString+FSAttributedString.h"

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
/**  */
@property (nonatomic, strong) NSMutableArray *cellHeightAry;
/**  */
@property (nonatomic, strong) NSMutableArray *tagMAry;
/**  */
@property (nonatomic, strong) NSMutableArray *ctDataAry;
/**  */
@property (nonatomic, strong) NSMutableArray *contentStringAry;
/**  */
@property (nonatomic, strong) NSMutableArray *hideAry;

@end

@implementation FSFoundViewController

-(NSMutableArray *)hideAry{
    if (!_hideAry) {
        _hideAry = [NSMutableArray array];
    }
    return _hideAry;
}

-(NSMutableArray *)contentStringAry{
    if (!_contentStringAry) {
        _contentStringAry = [NSMutableArray array];
    }
    return _contentStringAry;
}

-(NSMutableArray *)ctDataAry{
    if (!_ctDataAry) {
        _ctDataAry = [NSMutableArray array];
    }
    return _ctDataAry;
}

-(NSMutableArray *)tagMAry{
    if (!_tagMAry) {
        _tagMAry = [NSMutableArray array];
    }
    return _tagMAry;
}

-(NSMutableArray *)cellHeightAry{
    if (!_cellHeightAry) {
        _cellHeightAry = [NSMutableArray array];
    }
    return _cellHeightAry;
}

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
    UIBarButtonItem *addItem = [UIBarButtonItem itemWithImage:@"me_addFriend" highImage:nil title:nil target:self action:@selector(addClick)];
    self.navigationItem.rightBarButtonItem = addItem;
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithImage:@"home_search" highImage:nil title:nil target:self action:@selector(searchClick)];
    self.navigationItem.leftBarButtonItem = searchItem;
    [self.view addSubview:self.contentTableView];
    // 添加刷新控件
    [self setupRefresh];
}

-(void)addClick{
    FSFindFriendViewController *vc = [[FSFindFriendViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)searchClick{
    FSSearchViewController *vc = [[FSSearchViewController alloc] init];
    FSNavigationViewController *navi = [[FSNavigationViewController alloc] initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:nil];
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
            NSString *large = fileDict[@"adpic"];
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
        [self.cellHeightAry removeAllObjects];
        [self.hideAry removeAllObjects];
        for (int i = 0; i < self.stuffAry.count; i++) {
            FSZuoPin *model = self.stuffAry[i];
            CGFloat textH = [model.content getSpaceLabelHeightWithSpeace:5 withFont:[UIFont systemFontOfSize:14] withWidth:(SCREEN_WIDTH - 30)];
            CGFloat gaoDu = 0;
            if (model.content.length <= 80 / 667.0 * SCREEN_HEIGHT) {
                [self.hideAry addObject:@(1)];
                gaoDu = (textH + 378) / 667.0 * SCREEN_HEIGHT;
            } else {
                [self.hideAry addObject:@(0)];
                gaoDu = (53 + 378) / 667.0 * SCREEN_HEIGHT;
            }
            [self.cellHeightAry addObject:[NSString stringWithFormat:@"%f",gaoDu]];
        }
        [self.ctDataAry removeAllObjects];
        for (int i = 0; i < self.stuffAry.count; i++) {
            FSZuoPin *model = self.stuffAry[i];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *path = [paths objectAtIndex:0];
            NSString *filename = [path stringByAppendingPathComponent:@"tag.plist"];
            NSFileManager *fm = [NSFileManager defaultManager];
            [fm createFileAtPath:filename contents:nil attributes:nil];
            CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
            [self.tagMAry removeAllObjects];
            if (model.tags.count > 0) {
                //                self.tagtagLabel.hidden = NO;
                for (int i = 0; i < model.tags.count; i ++) {
                    NSDictionary *dict = model.tags[i];
                    NSDictionary *cellDict = @{
                                               @"color" : @"blue",
                                               @"content" : [NSString stringWithFormat:@" %@",dict[@"name"]],
                                               @"url" : @"hh",
                                               @"type" : @"link"
                                               };
                    [self.tagMAry addObject:cellDict];
                }
                config.width = SCREEN_WIDTH;
                [self.tagMAry writeToFile:filename atomically:YES];
            } else {
                //                self.tagtagLabel.hidden = YES;
            }
            CoreTextData *data = [CTFrameParser parseTemplateFile:filename config:config];
            [self.ctDataAry addObject:data];
        }
        [self.contentStringAry removeAllObjects];
        for (int i = 0; i < self.stuffAry.count; i++) {
            FSZuoPin *model = self.stuffAry[i];
            NSAttributedString  *setString = [model.content stringWithParagraphlineSpeace:5 textColor:[UIColor colorWithHexString:@"#222222"] textFont:[UIFont systemFontOfSize:14]];
            [self.contentStringAry addObject:setString];
        }
        [self.contentTableView reloadData];
        [self.contentTableView.mj_footer endRefreshing];
        [self checkFooterState];
    } failure:^(FBRequest *request, NSError *error) {
        // 提醒
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Loading user data failed", nil)];
        
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
        self.current_page = [result[@"meta"][@"pagination"][@"current_page"] integerValue];
        self.total_rows = [result[@"meta"][@"pagination"][@"total"] integerValue];
        NSArray *rows = result[@"data"];
        self.stuffAry = [FSZuoPin mj_objectArrayWithKeyValuesArray:rows];
        [self.cellHeightAry removeAllObjects];
        [self.hideAry removeAllObjects];
        for (int i = 0; i < self.stuffAry.count; i++) {
            FSZuoPin *model = self.stuffAry[i];
            CGFloat textH = [model.content getSpaceLabelHeightWithSpeace:5 withFont:[UIFont systemFontOfSize:14] withWidth:(SCREEN_WIDTH - 30)];
            CGFloat gaoDu = 0;
            if (model.content.length <= 80 / 667.0 * SCREEN_HEIGHT) {
                [self.hideAry addObject:@(1)];
                gaoDu = (textH + 378) / 667.0 * SCREEN_HEIGHT;
            } else {
                [self.hideAry addObject:@(0)];
                gaoDu = (53 + 378) / 667.0 * SCREEN_HEIGHT;
            }
            [self.cellHeightAry addObject:[NSString stringWithFormat:@"%f",gaoDu]];
        }
        [self.ctDataAry removeAllObjects];
        for (int i = 0; i < self.stuffAry.count; i++) {
            FSZuoPin *model = self.stuffAry[i];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *path = [paths objectAtIndex:0];
            NSString *filename = [path stringByAppendingPathComponent:@"tag.plist"];
            NSFileManager *fm = [NSFileManager defaultManager];
            [fm createFileAtPath:filename contents:nil attributes:nil];
            CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
            [self.tagMAry removeAllObjects];
            if (model.tags.count > 0) {
//                self.tagtagLabel.hidden = NO;
                for (int i = 0; i < model.tags.count; i ++) {
                    NSDictionary *dict = model.tags[i];
                    NSDictionary *cellDict = @{
                                               @"color" : @"blue",
                                               @"content" : [NSString stringWithFormat:@" %@",dict[@"name"]],
                                               @"url" : @"hh",
                                               @"type" : @"link"
                                               };
                    [self.tagMAry addObject:cellDict];
                }
                config.width = SCREEN_WIDTH;
                [self.tagMAry writeToFile:filename atomically:YES];
            } else {
//                self.tagtagLabel.hidden = YES;
            }
            CoreTextData *data = [CTFrameParser parseTemplateFile:filename config:config];
            [self.ctDataAry addObject:data];
        }
        [self.contentStringAry removeAllObjects];
        for (int i = 0; i < self.stuffAry.count; i++) {
            FSZuoPin *model = self.stuffAry[i];
            NSAttributedString  *setString = [model.content stringWithParagraphlineSpeace:5 textColor:[UIColor colorWithHexString:@"#222222"] textFont:[UIFont systemFontOfSize:14]];
            [self.contentStringAry addObject:setString];
        }
        [self.contentTableView reloadData];
        [self.contentTableView.mj_header endRefreshing];
        [self checkFooterState];
    } failure:^(FBRequest *request, NSError *error) {
        // 提醒
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Loading user data failed", nil)];
        
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
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Loading user data failed", nil)];
        
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
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Loading user data failed", nil)];
        
        // 让底部控件结束刷新
        [self.contentTableView.mj_header endRefreshing];
    }];
}

-(UITableView *)contentTableView{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50) style:UITableViewStyleGrouped];
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
    return 2 + self.stuffAry.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1 || section == 2) {
        return 30.0f;
    } else {
        return 0.01f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 10;
    } else {
        return 10;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 90;
    } else if (indexPath.section == 1) {
        return 100;
    } else if (indexPath.section > 1) {
        NSString *cellHeightStr = self.cellHeightAry[indexPath.section - 2];
        CGFloat gaoDu = [cellHeightStr floatValue];
        return gaoDu;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.headerView = [FSFoundHeaderView viewFromXib];
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    if (section == 0) {
        self.headerView.titleLabel.text = NSLocalizedString(@"Hot labels", nil);
        return self.headerView;
    } else if (section == 1) {
        self.headerView.titleLabel.text = NSLocalizedString(@"Popular user", nil);
        return self.headerView;
    } else if (section == 2) {
        self.headerView.titleLabel.text = NSLocalizedString(@"Hot recommended", nil);
        return self.headerView;
    }
    return nil;
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
    } else {
        FSFoundStuffTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSFoundStuffTableViewCell"];
        cell.model = self.stuffAry[indexPath.section - 2];
        cell.hideFlag = [self.hideAry[indexPath.section - 2] integerValue];
        cell.ctData = self.ctDataAry[indexPath.section - 2];
        cell.contentString = self.contentStringAry[indexPath.section - 2];
        cell.myViewController = self;
        cell.fucosBtn.tag = indexPath.section - 2;
        cell.navc = self.navigationController;
        [cell.fucosBtn addTarget:self action:@selector(fucosClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.navi = self.navigationController;
        cell.likeBtn.tag = indexPath.section - 2;
        cell.commendBtn.tag = indexPath.section - 2;
        [cell.likeBtn addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.commendBtn addTarget:self action:@selector(commendClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.pictuerView.tapBTn.tag = indexPath.section - 2;
        [cell.pictuerView.tapBTn addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.videoView.tapBtn.tag = indexPath.section - 2;
        [cell.videoView.tapBtn addTarget:self action:@selector(videoClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FSHomeDetailViewController *vc = [[FSHomeDetailViewController alloc] init];
    vc.model = self.stuffAry[indexPath.section - 2];
    vc.title = NSLocalizedString(@"comments", nil);
    [self.navigationController pushViewController:vc animated:YES];
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
    if ([self isLoginAndPresentLoginVc]) {
        if (sender.selected) {
            //取消关注
            FSZuoPin *model = self.stuffAry[sender.tag];
            FBRequest *request = [FBAPI deleteWithUrlString:[NSString stringWithFormat:@"/user/%@/cancelFollow",model.user_id] requestDictionary:nil delegate:self];
            [request startRequestSuccess:^(FBRequest *request, id result) {
                for (int i = 0; i < self.stuffAry.count; i ++) {
                    FSZuoPin *cellModel = self.stuffAry[i];
                    if ([cellModel.user_id isEqualToString:model.user_id]) {
                        cellModel.is_follow = 0;
                        [self.contentTableView reloadData];
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
                        [self.contentTableView reloadData];
                    }
                }
            } failure:^(FBRequest *request, NSError *error) {
                
            }];
        }
    }
}

#pragma mark - 更多按钮
-(void)moreClick:(UIButton*)sender{
    FSReportViewController *vc = [[FSReportViewController alloc] init];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:^{
        [UIView animateWithDuration:0.05 animations:^{
            vc.firstViewBottomSapce.constant = 0;
            [vc.view layoutIfNeeded];
        } completion:nil];
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
    if ([self isLoginAndPresentLoginVc]) {
        NSString *idStr = ((FSZuoPin*)self.stuffAry[sender.tag]).idFeild;
        if (sender.selected) {
            FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/stuffs/%@/cancelike",idStr] requestDictionary:nil delegate:self];
            [request startRequestSuccess:^(FBRequest *request, id result) {
                sender.selected = NO;
                ((FSZuoPin*)self.stuffAry[sender.tag]).is_love = 0;
            } failure:^(FBRequest *request, NSError *error) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"The operation failure", nil)];
            }];
        } else {
            FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/stuffs/%@/dolike",idStr] requestDictionary:nil delegate:self];
            [request startRequestSuccess:^(FBRequest *request, id result) {
                sender.selected = YES;
                ((FSZuoPin*)self.stuffAry[sender.tag]).is_love = 1;
            } failure:^(FBRequest *request, NSError *error) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"The operation failure", nil)];
            }];
        }
    }
}

#pragma mark - 点击图片
-(void)imageClick:(UIButton*)sender{
    FSBigImageViewController *vc = [[FSBigImageViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    FSZuoPin *model = self.stuffAry[sender.tag];
    vc.imageUrl = model.srcfile;
    [self presentViewController:vc animated:YES completion:nil];
}

@end
