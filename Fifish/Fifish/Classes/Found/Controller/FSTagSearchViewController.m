//
//  FSTagSearchViewController.m
//  Fifish
//
//  Created by THN-Dong on 2016/10/19.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSTagSearchViewController.h"
#import "SGTopTitleView.h"
#import "MJRefresh.h"
#import "FSHomeViewCell.h"
#import "UIImageView+WebCache.h"
#import "FSZuoPin.h"
#import "FSTagSearchOneTableViewCell.h"
#import "FSHomeDetailViewController.h"
#import "FSBigImageViewController.h"
#import "FSPlayViewController.h"
#import "FSUserModel.h"
#import "FSListUserTableViewCell.h"
#import "Masonry.h"
#import "FSHomePageViewController.h"
#import "FSReportViewController.h"
#import "CTFrameParserConfig.h"
#import "CoreTextData.h"
#import "CTFrameParser.h"
#import "NSString+FSAttributedString.h"
#import "WMPlayer.h"

@interface FSTagSearchViewController ()<SGTopTitleViewDelegate, UITableViewDelegate, UITableViewDataSource, FSHomeViewCellDelegate, WMPlayerDelegate, FSHomeDetailViewControllerDelegate>
{
    WMPlayer *wmPlayer;
}
/**
 1、作品
 2、用户
 */
@property (nonatomic, strong) NSNumber *type;
/**  */
@property (nonatomic, strong) UITableView *myTableView;
/**  */
@property (nonatomic, strong) SGTopTitleView *segmentedControl;
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
@property (nonatomic, strong) NSMutableArray *stuffAry;
/**  */
@property (nonatomic, strong) UIView *lineView;
/**  */
@property (nonatomic, strong) NSMutableArray *userAry;
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
@property (nonatomic, strong) NSIndexPath *indexPath;
/**  */
@property (nonatomic, strong) UIView *imageView;
@property (nonatomic, assign) BOOL isSmallScreen;

@end

@implementation FSTagSearchViewController

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

-(NSMutableArray *)userAry{
    if (!_userAry) {
        _userAry = [NSMutableArray array];
    }
    return _userAry;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 10)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    }
    return _lineView;
}

-(NSMutableArray *)stuffAry{
    if (!_stuffAry) {
        _stuffAry = [NSMutableArray array];
    }
    return _stuffAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = NSLocalizedString(@"tag", nil);
    self.type = @(1);
    self.tid = @(1);
    [self.view addSubview:self.myTableView];
    [self setupRefresh];
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
    [self.myTableView.mj_footer endRefreshing];
    self.current_page = 1;
    FBRequest *request = [FBAPI getWithUrlString:@"/search/list" requestDictionary:@{
                                                                                     @"page" : @(self.current_page),
                                                                                     @"per_page" : @(10),
                                                                                     @"str" : self.placeString,
                                                                                     @"type" : self.type,
                                                                                     @"tid" : self.tid,
                                                                                     @"evt" : @(1),
                                                                                     @"sort" : @(1)
                                                                                     } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        [self.myTableView.mj_header endRefreshing];
        self.current_page = [result[@"meta"][@"pagination"][@"current_page"] integerValue];
        self.total = [result[@"meta"][@"pagination"][@"total"] integerValue];
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
            [self parsing];
        }
        [self.myTableView reloadData];
        [self checkFooterState];
    } failure:^(FBRequest *request, NSError *error) {
        [self.myTableView.mj_header endRefreshing];
    }];
}

-(void)parsing{
    [self.cellHeightAry removeAllObjects];
    [self.hideAry removeAllObjects];
    [self.ctDataAry removeAllObjects];
    [self.contentStringAry removeAllObjects];
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
            
            
            
            CGFloat textH = [model.content getSpaceLabelHeightWithSpeace:5 withFont:[UIFont systemFontOfSize:14] withWidth:(SCREEN_WIDTH - 30)];
            CGFloat gaoDu = 0;
            if (SCREEN_HEIGHT == 568.0) {
                if (model.content.length <= 53) {
                    [self.hideAry addObject:@(1)];
                    gaoDu = (textH + 375 + 20) / 667.0 * SCREEN_HEIGHT;
                } else {
                    [self.hideAry addObject:@(0)];
                    gaoDu = (85 + 375) / 667.0 * SCREEN_HEIGHT;
                }
            } else if (SCREEN_HEIGHT == 667.0) {
                if (model.content.length <= 65) {
                    [self.hideAry addObject:@(1)];
                    gaoDu = (textH + 375 - 12) / 667.0 * SCREEN_HEIGHT;
                } else {
                    [self.hideAry addObject:@(0)];
                    gaoDu = (53 + 375) / 667.0 * SCREEN_HEIGHT;
                }
            } else {
                if (model.content.length <= 96) {
                    [self.hideAry addObject:@(1)];
                    gaoDu = (textH + 375 + 12);
                } else {
                    [self.hideAry addObject:@(0)];
                    gaoDu = (53 + 375);
                }
            }
            [self.cellHeightAry addObject:[NSString stringWithFormat:@"%f",gaoDu + 8]];
        } else {
            CGFloat textH = [model.content getSpaceLabelHeightWithSpeace:5 withFont:[UIFont systemFontOfSize:14] withWidth:(SCREEN_WIDTH - 30)];
            CGFloat gaoDu = 0;
            if (SCREEN_HEIGHT == 568.0) {
                if (model.content.length <= 53) {
                    [self.hideAry addObject:@(1)];
                    gaoDu = (textH + 347 + 20) / 667.0 * SCREEN_HEIGHT;
                } else {
                    [self.hideAry addObject:@(0)];
                    gaoDu = (85 + 347) / 667.0 * SCREEN_HEIGHT;
                }
            } else if (SCREEN_HEIGHT == 667.0) {
                if (model.content.length <= 65) {
                    [self.hideAry addObject:@(1)];
                    gaoDu = (textH + 347 - 12) / 667.0 * SCREEN_HEIGHT;
                } else {
                    [self.hideAry addObject:@(0)];
                    gaoDu = (53 + 347) / 667.0 * SCREEN_HEIGHT;
                }
            } else {
                if (model.content.length <= 96) {
                    [self.hideAry addObject:@(1)];
                    gaoDu = (textH + 347 - 30) / 667.0 * SCREEN_HEIGHT;
                } else {
                    [self.hideAry addObject:@(0)];
                    gaoDu = (53 + 347) / 667.0 * SCREEN_HEIGHT;
                }
            }
            [self.cellHeightAry addObject:[NSString stringWithFormat:@"%f",gaoDu + 3]];
        }
        CoreTextData *data = [CTFrameParser parseTemplateFile:filename config:config];
        [self.ctDataAry addObject:data];
        
        NSInteger flag = [self.hideAry[i] integerValue];
        if (flag) {
            NSAttributedString  *setString = [model.content stringWithParagraphlineSpeace:5 textColor:[UIColor colorWithHexString:@"#222222"] textFont:[UIFont systemFontOfSize:14] andIsAll:NO];
            [self.contentStringAry addObject:setString];
        } else {
            NSAttributedString  *setString = [model.content stringHideLastFourWithParagraphlineSpeace:5 textColor:[UIColor colorWithHexString:@"#222222"] textFont:[UIFont systemFontOfSize:14]];
            [self.contentStringAry addObject:setString];
        }
    }
}


-(void)loadMore{
    [self.myTableView.mj_header endRefreshing];
    FBRequest *request = [FBAPI getWithUrlString:@"/search/list" requestDictionary:@{
                                                                                     @"page" : @(++self.current_page),
                                                                                     @"per_page" : @(10),
                                                                                     @"str" : self.placeString,
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
            [self parsing];
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


-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)style:UITableViewStyleGrouped];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.showsVerticalScrollIndicator = NO;
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FSHomeViewCell class]) bundle:nil] forCellReuseIdentifier:@"FSHomeViewCell"];
        [_myTableView registerNib:[UINib nibWithNibName:@"FSTagSearchOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"FSTagSearchOneTableViewCell"];
        [_myTableView registerNib:[UINib nibWithNibName:@"FSListUserTableViewCell" bundle:nil] forCellReuseIdentifier:@"FSListUserTableViewCell"];
        _myTableView.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
    }
    return _myTableView;
}

-(SGTopTitleView *)segmentedControl{
    if (!_segmentedControl) {
        _segmentedControl = [[SGTopTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _segmentedControl.staticTitleArr = @[NSLocalizedString(@"picture", nil), NSLocalizedString(@"video", nil), NSLocalizedString(@"user", nil)];
        _segmentedControl.backgroundColor = [UIColor whiteColor];
        _segmentedControl.delegate_SG = self;
    }
    return _segmentedControl;
}

#pragma mark - - - SGTopScrollMenu代理方法
- (void)SGTopTitleView:(SGTopTitleView *)topTitleView didSelectTitleAtIndex:(NSInteger)index {
    if (index == 0) {
        self.type = @(1);
        self.tid = @(1);
    } else if (index == 1) {
        self.type = @(1);
        self.tid = @(2);
    } else if (index == 2) {
        self.type = @(2);
        self.tid = @(0);
    }
    //进行网络请求
    [self.myTableView.mj_header beginRefreshing];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.type isEqualToNumber:@(2)]) {
        if (section == 0) {
            return 2;
        } else {
            return self.userAry.count > 0 ? self.userAry.count : 1;
        }
    } else if ([self.type isEqualToNumber:@(1)]) {
        if (section == 0) {
            return 2;
        } else {
            return 1;
        }
    }
    return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.type isEqualToNumber:@(2)]) {
        return 2;
    } else if ([self.type isEqualToNumber:@(1)]) {
        return self.stuffAry.count > 0 ? self.stuffAry.count + 1 : 2;
    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 170;
        } else if (indexPath.row == 1) {
            return 44;
        }
    } else {
        if ([self.type isEqualToNumber:@(2)]) {
            if (self.userAry.count == 0) {
                return SCREEN_HEIGHT - 288;
            }
            return 60;
        } else if ([self.type isEqualToNumber:@(1)]) {
            if (self.stuffAry.count == 0) {
                return SCREEN_HEIGHT - 288;
            }
            NSString *cellHeightStr = self.cellHeightAry[indexPath.section - 1];
            CGFloat gaoDu = [cellHeightStr floatValue];
            return gaoDu;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            FSTagSearchOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSTagSearchOneTableViewCell"];
            cell.placeString = self.placeString;
            cell.navc = self.navigationController;
            return cell;
        } else if (indexPath.row == 1) {
            static NSString *cellId = @"cellTwo";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.contentView addSubview:self.segmentedControl];
                [cell.contentView addSubview:self.lineView];
            }
            return cell;
        }
    } else {
        if ([self.type isEqualToNumber:@(2)]) {
            if (self.userAry.count == 0) {
                static NSString *emptyCell = @"emptyShow";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:emptyCell];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:emptyCell];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_search_empty"]];
                    [cell.contentView addSubview:imageView];
                    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.mas_equalTo(cell.contentView.centerY).offset(0);
                        make.centerX.mas_equalTo(cell.contentView.centerX).offset(0);
                    }];
                }
                return cell;
            }
            //用户
            FSListUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSListUserTableViewCell"];
            //传入模型
            FSUserModel *model = self.userAry[indexPath.row];
            cell.userModel = model;
            cell.fucosBtn.tag = indexPath.row;
            [cell.fucosBtn addTarget:self action:@selector(userFcousClick:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        } else if ([self.type isEqualToNumber:@(1)]) {
            if (self.stuffAry.count == 0) {
                static NSString *cellId = @"emptyShow";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_search_empty"]];
                    [cell.contentView addSubview:imageView];
                    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.mas_equalTo(cell.contentView.centerY).offset(0);
                        make.centerX.mas_equalTo(cell.contentView.centerX).offset(0);
                    }];
                }
                return cell;
            }
            
            FSHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSHomeViewCell"];
            cell.fSHomeViewDelegate = self;
            cell.navi = self.navigationController;
            cell.model = self.stuffAry[indexPath.section - 1];
            cell.ctData = self.ctDataAry[indexPath.section - 1];
            cell.hideFlag = [self.hideAry[indexPath.section - 1] integerValue];
            cell.contentString = self.contentStringAry[indexPath.section - 1];
            cell.commendBtn.tag = indexPath.section - 1;
            [cell.commendBtn addTarget:self action:@selector(commendClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.pictuerView.tapBTn.tag = indexPath.section - 1;
            [cell.pictuerView.tapBTn addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.videoView.tapBtn.tag = indexPath.section - 1;
            [cell.videoView.tapBtn addTarget:self action:@selector(videoClick:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return;
    } else {
        if ([self.type isEqualToNumber:@(2)]) {
            FSHomePageViewController *vc = [[FSHomePageViewController alloc] init];
            FSUserModel *model = self.userAry[indexPath.row];
            vc.userId = model.userId;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([self.type isEqualToNumber:@(1)]) {
            FSHomeDetailViewController *vc = [[FSHomeDetailViewController alloc] init];
            vc.homeDetailDelegate = self;
            vc.model = self.stuffAry[indexPath.section - 1];
            vc.title = NSLocalizedString(@"comments", nil);
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
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
            sender.backgroundColor = [UIColor colorWithHexString:@"#2288FF"];
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    }
}

#pragma mark - 视频播放
-(void)videoClick:(UIButton*)sender{
    //开始播放视频
    FSZuoPin *model = self.stuffAry[sender.tag];
    FSPlayViewController *mvPlayer = [[FSPlayViewController alloc] init];
    mvPlayer.videoUrl = [NSURL URLWithString:model.srcfile];
    [self presentViewController:mvPlayer animated:YES completion:nil];
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

#pragma mark - 更多按钮
-(void)moreClick:(UIButton*)sender{
    FSReportViewController *vc = [[FSReportViewController alloc] init];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:^{
        [UIView animateWithDuration:0.25 animations:^{
            vc.firstViewBottomSapce.constant = 0;
            [vc.view layoutIfNeeded];
        } completion:nil];
    }];
}


#pragma mark - 评论按钮
-(void)commendClick: (UIButton *) sender{
    FSHomeDetailViewController *vc = [[FSHomeDetailViewController alloc] init];
    vc.homeDetailDelegate = self;
    vc.model = self.stuffAry[sender.tag];
    vc.title = NSLocalizedString(@"comments", nil);
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - FSHomeDetailViewControllerDelegate
-(void)lickClick:(BOOL)btnState :(NSString *)idFiled andlikeCount:(NSInteger)likecount{
    int n;
    for (int i = 0; i < self.stuffAry.count; i ++) {
        NSString *idStr = ((FSZuoPin*)self.stuffAry[i]).idFeild;
        if ([idStr isEqualToString:idFiled]) {
            n = i;
            break;
        }
    }
    FSHomeViewCell *cell = [self.mutableCopy cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:(n + 1)]];
    cell.likeBtn.selected = btnState;
    if (btnState) {
        cell.like_count_label.textColor = [UIColor colorWithHexString:@"#2288ff"];
    } else {
        cell.like_count_label.textColor = [UIColor colorWithHexString:@"#7F8FA2"];
    }
    cell.like_count_label.text = [NSString stringWithFormat:@"%ld", likecount];
}

-(void)fucosDelegateClick:(BOOL)senderState andId:(NSString *)idFiled{
    int n;
    for (int i = 0; i < self.stuffAry.count; i ++) {
        NSString *idStr = ((FSZuoPin*)self.stuffAry[i]).idFeild;
        if ([idStr isEqualToString:idFiled]) {
            n = i;
            FSHomeViewCell *cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:(n + 1)]];
            cell.model.is_follow = senderState ? 1 : 0;
            cell.likeBtn.selected = senderState;
            cell.model.idFeild = idFiled;
        }
    }
    [self.myTableView reloadData];
}


-(void)homeTableViewCell:(FSHomeViewCell *)cell didClickVideoWithVideoUrl:(NSString *)videoUrl videoCover:(FSHomeVideoView *)baseImageView{
    self.indexPath = [self.myTableView indexPathForCell:cell];
    self.imageView = baseImageView;
    
    wmPlayer = [[WMPlayer alloc]initWithFrame:baseImageView.bounds];
    wmPlayer.delegate = self;
    wmPlayer.closeBtnStyle = CloseBtnStylePop;
    wmPlayer.URLString = videoUrl;
    [baseImageView addSubview:wmPlayer];
    [wmPlayer play];
}

#pragma mark - WMPlayerDelegate
- (BOOL)prefersStatusBarHidden {
    if (wmPlayer) {
        if (wmPlayer.isFullscreen) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

- (void)toCell {
    [wmPlayer removeFromSuperview];
    [UIView animateWithDuration:0.5f animations:^{
        wmPlayer.transform = CGAffineTransformIdentity;
        wmPlayer.frame = self.imageView.bounds;
        wmPlayer.playerLayer.frame =  wmPlayer.bounds;
        [self.imageView addSubview:wmPlayer];
        [self.imageView bringSubviewToFront:wmPlayer];
        [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(wmPlayer).with.offset(0);
        }];
        [wmPlayer.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.top.equalTo(wmPlayer).with.offset(0);
        }];
        [wmPlayer.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer.topView).with.offset(45);
            make.right.equalTo(wmPlayer.topView).with.offset(-45);
            make.center.equalTo(wmPlayer.topView);
            make.top.equalTo(wmPlayer.topView).with.offset(0);
        }];
        [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(wmPlayer).with.offset(5);
        }];
        [wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(wmPlayer);
            make.width.equalTo(wmPlayer);
            make.height.equalTo(@30);
        }];
    }completion:^(BOOL finished) {
        wmPlayer.isFullscreen = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        self.isSmallScreen = NO;
        wmPlayer.fullScreenBtn.selected = NO;
        
    }];
    
    
}

- (void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation {
    [wmPlayer removeFromSuperview];
    wmPlayer.transform = CGAffineTransformIdentity;
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        wmPlayer.transform = CGAffineTransformMakeRotation(-M_PI_2);
    } else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        wmPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    wmPlayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    wmPlayer.playerLayer.frame =  CGRectMake(0,0, SCREEN_HEIGHT,SCREEN_WIDTH);
    
    [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(SCREEN_WIDTH-40);
        make.width.mas_equalTo(SCREEN_HEIGHT);
    }];
    
    [wmPlayer.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.equalTo(wmPlayer).with.offset(0);
        make.width.mas_equalTo(SCREEN_HEIGHT);
    }];
    
    [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wmPlayer).with.offset((-SCREEN_HEIGHT/2));
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(wmPlayer).with.offset(5);
        
    }];
    
    [wmPlayer.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wmPlayer.topView).with.offset(45);
        make.right.equalTo(wmPlayer.topView).with.offset(-45);
        make.center.equalTo(wmPlayer.topView);
        make.top.equalTo(wmPlayer.topView).with.offset(0);
    }];
    
    [wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_HEIGHT);
        make.center.mas_equalTo(CGPointMake(SCREEN_WIDTH/2-36, -(SCREEN_WIDTH/2)));
        make.height.equalTo(@30);
    }];
    
    [wmPlayer.loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointMake(SCREEN_WIDTH/2-37, -(SCREEN_WIDTH/2-37)));
    }];
    [wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_HEIGHT);
        make.center.mas_equalTo(CGPointMake(SCREEN_WIDTH/2-36, -(SCREEN_HEIGHT/2)+36));
        make.height.equalTo(@30);
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:wmPlayer];
    
    wmPlayer.fullScreenBtn.selected = YES;
    [wmPlayer bringSubviewToFront:wmPlayer.bottomView];
    
}

- (void)toSmallScreen {
    // 放widow上
    [wmPlayer removeFromSuperview];
    [UIView animateWithDuration:0.3f animations:^{
        wmPlayer.transform = CGAffineTransformIdentity;
        wmPlayer.frame = CGRectMake(SCREEN_WIDTH/2,SCREEN_HEIGHT-kTabBarHeight-(SCREEN_WIDTH/2)*0.75, SCREEN_WIDTH/2, (SCREEN_WIDTH/2)*0.75);
        wmPlayer.playerLayer.frame = wmPlayer.bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:wmPlayer];
        [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(wmPlayer).with.offset(0);
        }];
        [wmPlayer.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.top.equalTo(wmPlayer).with.offset(0);
        }];
        [wmPlayer.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer.topView).with.offset(45);
            make.right.equalTo(wmPlayer.topView).with.offset(-45);
            make.center.equalTo(wmPlayer.topView);
            make.top.equalTo(wmPlayer.topView).with.offset(0);
        }];
        [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(wmPlayer).with.offset(5);
            
        }];
        [wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(wmPlayer);
            make.width.equalTo(wmPlayer);
            make.height.equalTo(@30);
        }];
        
    } completion:^(BOOL finished) {
        wmPlayer.isFullscreen = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        wmPlayer.fullScreenBtn.selected = NO;
        self.isSmallScreen = YES;
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:wmPlayer];
    }];
}

- (void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)closeBtn {
    if (wmplayer.isFullscreen) {
        wmplayer.isFullscreen = NO;
        [UIApplication sharedApplication].statusBarHidden = NO;
        [self toCell];
    } else {
        [self releaseWMPlayer];
    }
    
}

- (void)wmplayer:(WMPlayer *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn {
    if (fullScreenBtn.isSelected) {//全屏显示
        wmPlayer.isFullscreen = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
        [UIApplication sharedApplication].statusBarHidden = YES;
    } else {
        [UIApplication sharedApplication].statusBarHidden = NO;
        if (self.isSmallScreen) {
            // 放widow上,小屏显示
            [self toSmallScreen];
        } else {
            [self toCell];
        }
    }
}

- (void)wmplayer:(WMPlayer *)wmplayer singleTaped:(UITapGestureRecognizer *)singleTap{
    NSLog(@"didSingleTaped");
}

- (void)wmplayer:(WMPlayer *)wmplayer doubleTaped:(UITapGestureRecognizer *)doubleTap{
    NSLog(@"didDoubleTaped");
}

- (void)wmplayerFailedPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state {
    NSLog(@"wmplayerDidFailedPlay");
}

- (void)wmplayerReadyToPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state {
    NSLog(@"wmplayerDidReadyToPlay");
}

- (void)wmplayerFinishedPlay:(WMPlayer *)wmplayer {
    [self releaseWMPlayer];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)releaseWMPlayer {
    [wmPlayer pause];
    [wmPlayer removeFromSuperview];
    [wmPlayer.playerLayer removeFromSuperlayer];
    [wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
    wmPlayer.player = nil;
    wmPlayer.currentItem = nil;
    //释放定时器，否侧不会调用WMPlayer中的dealloc方法
    [wmPlayer.autoDismissTimer invalidate];
    wmPlayer.autoDismissTimer = nil;
    wmPlayer.playOrPauseBtn = nil;
    wmPlayer.playerLayer = nil;
    wmPlayer = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (wmPlayer.superview) {
        CGRect rectInTableView = [self.myTableView rectForRowAtIndexPath:self.indexPath];
        CGRect rectInSuperview = [self.myTableView convertRect:rectInTableView toView:[self.myTableView superview]];
        if (rectInSuperview.origin.y < -self.imageView.frame.size.height || rectInSuperview.origin.y>SCREEN_HEIGHT-kTopBarHeight-kTabBarHeight) {//往上拖动
            
            if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:wmPlayer]&&self.isSmallScreen) {
                self.isSmallScreen = YES;
            } else {
                [self releaseWMPlayer];
            }
        } else {
            if ([self.imageView.subviews containsObject:wmPlayer]) {
                
            } else {
                [self releaseWMPlayer];
            }
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self releaseWMPlayer];
}

@end
