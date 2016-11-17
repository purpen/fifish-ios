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

@interface FSTagSearchViewController ()<SGTopTitleViewDelegate, UITableViewDelegate, UITableViewDataSource>

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
            cell.navi = self.navigationController;
            cell.model = self.stuffAry[indexPath.section - 1];
            cell.ctData = self.contentStringAry[indexPath.section - 1];
            cell.hideFlag = self.hideAry[indexPath.section - 1];
            cell.contentString = self.contentStringAry[indexPath.section - 1];
            cell.likeBtn.tag = indexPath.section - 1;
            cell.commendBtn.tag = indexPath.section - 1;
            [cell.likeBtn addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
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
            vc.model = self.stuffAry[indexPath.section - 1];
            vc.title = @"评论";
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
    vc.model = self.stuffAry[sender.tag];
    vc.title = NSLocalizedString(@"comments", nil);
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

@end
