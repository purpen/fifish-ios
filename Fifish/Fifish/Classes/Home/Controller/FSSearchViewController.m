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
#import "FSReportView.h"
#import "FSUserModel.h"
#import "FSHomePageViewController.h"
#import "FSPlayViewController.h"
#import "Masonry.h"
#import "FSReportViewController.h"
#import "CTFrameParserConfig.h"
#import "CoreTextData.h"
#import "CTFrameParser.h"
#import "NSString+FSAttributedString.h"

@interface FSSearchViewController () <UISearchBarDelegate, SGTopTitleViewDelegate, UITableViewDelegate, UITableViewDataSource>

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
@property (nonatomic, strong) FSReportView *reportView;
/**  */
@property (nonatomic, strong) NSMutableArray *stuffAry;
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

@implementation FSSearchViewController

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

-(NSMutableArray *)stuffAry{
    if (!_stuffAry) {
        _stuffAry = [NSMutableArray array];
    }
    return _stuffAry;
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
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.segmentedControl.y + self.segmentedControl.height, SCREEN_WIDTH, SCREEN_HEIGHT - self.segmentedControl.y - self.segmentedControl.height) style:UITableViewStyleGrouped];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.showsVerticalScrollIndicator = NO;
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FSFoundStuffTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"FSFoundStuffTableViewCell"];
        [_myTableView registerNib:[UINib nibWithNibName:@"FSListUserTableViewCell" bundle:nil] forCellReuseIdentifier:@"FSListUserTableViewCell"];
        _myTableView.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
    }
    return _myTableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.type isEqualToNumber:@(2)]) {
        //用户
        return self.userAry.count > 0 ? self.userAry.count : 1;
    } else if ([self.type isEqualToNumber:@(1)]) {
        return 1;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.type isEqualToNumber:@(2)]) {
        //用户
        return 1;
    } else if ([self.type isEqualToNumber:@(1)]) {
        return self.stuffAry.count > 0 ? self.stuffAry.count : 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.type isEqualToNumber:@(2)]) {
        if (self.userAry.count == 0) {
            static NSString *cellId = @"emptyShow";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
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

        FSFoundStuffTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSFoundStuffTableViewCell"];
        cell.navc = self.navigationController;
        //传入模型
        FSZuoPin *model = self.stuffAry[indexPath.section];
        cell.model = model;
        cell.ctData = self.ctDataAry[indexPath.section];
        cell.contentString = self.contentStringAry[indexPath.section];
        cell.hideFlag = [self.hideAry[indexPath.section] integerValue];
        cell.fucosBtn.tag = indexPath.section;
        [cell.fucosBtn addTarget:self action:@selector(fucosClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.navi = self.navigationController;
        cell.commendBtn.tag = indexPath.section;
        [cell.commendBtn addTarget:self action:@selector(commendClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.moreBtn.tag = indexPath.section;
        [cell.moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.pictuerView.tapBTn.tag = indexPath.section;
        [cell.pictuerView.tapBTn addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.videoView.tapBtn.tag = indexPath.section;
        [cell.videoView.tapBtn addTarget:self action:@selector(videoClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return nil;
}

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
    } else {
        FSHomeDetailViewController *vc = [[FSHomeDetailViewController alloc] init];
        vc.model = self.stuffAry[indexPath.section];
        vc.title = NSLocalizedString(@"comments", nil);
        [self.navigationController pushViewController:vc animated:YES];
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


#pragma mark - 评论按钮
-(void)commendClick: (UIButton *) sender{
    FSHomeDetailViewController *vc = [[FSHomeDetailViewController alloc] init];
    vc.model = self.stuffAry[sender.tag];
    vc.title = NSLocalizedString(@"comments", nil);
    [self.navigationController pushViewController:vc animated:YES];
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
                    [self.myTableView reloadData];
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
                    [self.myTableView reloadData];
                }
            }
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.type isEqualToNumber:@(2)]) {
        if (self.userAry.count == 0) {
            return SCREEN_HEIGHT - 109;
        }
        return 60;
    } else if ([self.type isEqualToNumber:@(1)]) {
        if (self.stuffAry.count == 0) {
            return SCREEN_HEIGHT - 109;
        }
        NSString *cellHeightStr = self.cellHeightAry[indexPath.section];
        CGFloat gaoDu = [cellHeightStr floatValue];
        return gaoDu;
    }
    return 0;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.type = @(1);
    self.tid = @(2);
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
                    if (SCREEN_HEIGHT == 568.0) {
                        CGFloat gaoDu = 0;
                        if (model.content.length <= 53) {
                            [self.hideAry addObject:@(1)];
                            gaoDu = (textH + 375 + 20) / 667.0 * SCREEN_HEIGHT;
                        } else {
                            [self.hideAry addObject:@(0)];
                            gaoDu = (85 + 375) / 667.0 * SCREEN_HEIGHT;
                        }
                        [self.cellHeightAry addObject:[NSString stringWithFormat:@"%f",gaoDu]];
                    } else if (SCREEN_HEIGHT == 667.0) {
                        CGFloat gaoDu = 0;
                        if (model.content.length <= 65) {
                            [self.hideAry addObject:@(1)];
                            gaoDu = (textH + 375 - 12) / 667.0 * SCREEN_HEIGHT;
                        } else {
                            [self.hideAry addObject:@(0)];
                            gaoDu = (53 + 375) / 667.0 * SCREEN_HEIGHT;
                        }
                        [self.cellHeightAry addObject:[NSString stringWithFormat:@"%f",gaoDu]];
                    } else {
                        CGFloat gaoDu = 0;
                        if (model.content.length <= 96) {
                            [self.hideAry addObject:@(1)];
                            gaoDu = (textH + 375 + 12);
                        } else {
                            [self.hideAry addObject:@(0)];
                            gaoDu = (53 + 375);
                        }
                        [self.cellHeightAry addObject:[NSString stringWithFormat:@"%f",gaoDu]];
                    }
                } else {
                    CGFloat textH = [model.content getSpaceLabelHeightWithSpeace:5 withFont:[UIFont systemFontOfSize:14] withWidth:(SCREEN_WIDTH - 30)];
                    if (SCREEN_HEIGHT == 568.0) {
                        CGFloat gaoDu = 0;
                        if (model.content.length <= 53) {
                            [self.hideAry addObject:@(1)];
                            gaoDu = (textH + 347 + 20) / 667.0 * SCREEN_HEIGHT;
                        } else {
                            [self.hideAry addObject:@(0)];
                            gaoDu = (85 + 347) / 667.0 * SCREEN_HEIGHT;
                        }
                        [self.cellHeightAry addObject:[NSString stringWithFormat:@"%f",gaoDu]];
                    } else if (SCREEN_HEIGHT == 667.0) {
                        CGFloat gaoDu = 0;
                        if (model.content.length <= 65) {
                            [self.hideAry addObject:@(1)];
                            gaoDu = (textH + 347 - 12) / 667.0 * SCREEN_HEIGHT;
                        } else {
                            [self.hideAry addObject:@(0)];
                            gaoDu = (53 + 347) / 667.0 * SCREEN_HEIGHT;
                        }
                        [self.cellHeightAry addObject:[NSString stringWithFormat:@"%f",gaoDu]];
                    } else {
                        CGFloat gaoDu = 0;
                        if (model.content.length <= 96) {
                            [self.hideAry addObject:@(1)];
                            gaoDu = (textH + 347 - 30) / 667.0 * SCREEN_HEIGHT;
                        } else {
                            [self.hideAry addObject:@(0)];
                            gaoDu = (53 + 347) / 667.0 * SCREEN_HEIGHT;
                        }
                        [self.cellHeightAry addObject:[NSString stringWithFormat:@"%f",gaoDu]];
                    }
                }
                CoreTextData *data = [CTFrameParser parseTemplateFile:filename config:config];
                [self.ctDataAry addObject:data];
                
                NSInteger flag = [self.hideAry[i] integerValue];
                if (flag) {
                    NSAttributedString  *setString = [model.content stringWithParagraphlineSpeace:5 textColor:[UIColor colorWithHexString:@"#222222"] textFont:[UIFont systemFontOfSize:14]];
                    [self.contentStringAry addObject:setString];
                } else {
                    NSAttributedString  *setString = [model.content stringHideLastFourWithParagraphlineSpeace:5 textColor:[UIColor colorWithHexString:@"#222222"] textFont:[UIFont systemFontOfSize:14]];
                    [self.contentStringAry addObject:setString];
                }
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
                    if (SCREEN_HEIGHT == 568.0) {
                        CGFloat gaoDu = 0;
                        if (model.content.length <= 53) {
                            [self.hideAry addObject:@(1)];
                            gaoDu = (textH + 375 + 20) / 667.0 * SCREEN_HEIGHT;
                        } else {
                            [self.hideAry addObject:@(0)];
                            gaoDu = (85 + 375) / 667.0 * SCREEN_HEIGHT;
                        }
                        [self.cellHeightAry addObject:[NSString stringWithFormat:@"%f",gaoDu]];
                    } else if (SCREEN_HEIGHT == 667.0) {
                        CGFloat gaoDu = 0;
                        if (model.content.length <= 65) {
                            [self.hideAry addObject:@(1)];
                            gaoDu = (textH + 375 - 12) / 667.0 * SCREEN_HEIGHT;
                        } else {
                            [self.hideAry addObject:@(0)];
                            gaoDu = (53 + 375) / 667.0 * SCREEN_HEIGHT;
                        }
                        [self.cellHeightAry addObject:[NSString stringWithFormat:@"%f",gaoDu]];
                    } else {
                        CGFloat gaoDu = 0;
                        if (model.content.length <= 96) {
                            [self.hideAry addObject:@(1)];
                            gaoDu = (textH + 375 + 12);
                        } else {
                            [self.hideAry addObject:@(0)];
                            gaoDu = (53 + 375);
                        }
                        [self.cellHeightAry addObject:[NSString stringWithFormat:@"%f",gaoDu]];
                    }
                } else {
                    CGFloat textH = [model.content getSpaceLabelHeightWithSpeace:5 withFont:[UIFont systemFontOfSize:14] withWidth:(SCREEN_WIDTH - 30)];
                    if (SCREEN_HEIGHT == 568.0) {
                        CGFloat gaoDu = 0;
                        if (model.content.length <= 53) {
                            [self.hideAry addObject:@(1)];
                            gaoDu = (textH + 347 + 20) / 667.0 * SCREEN_HEIGHT;
                        } else {
                            [self.hideAry addObject:@(0)];
                            gaoDu = (85 + 347) / 667.0 * SCREEN_HEIGHT;
                        }
                        [self.cellHeightAry addObject:[NSString stringWithFormat:@"%f",gaoDu]];
                    } else if (SCREEN_HEIGHT == 667.0) {
                        CGFloat gaoDu = 0;
                        if (model.content.length <= 65) {
                            [self.hideAry addObject:@(1)];
                            gaoDu = (textH + 347 - 12) / 667.0 * SCREEN_HEIGHT;
                        } else {
                            [self.hideAry addObject:@(0)];
                            gaoDu = (53 + 347) / 667.0 * SCREEN_HEIGHT;
                        }
                        [self.cellHeightAry addObject:[NSString stringWithFormat:@"%f",gaoDu]];
                    } else {
                        CGFloat gaoDu = 0;
                        if (model.content.length <= 96) {
                            [self.hideAry addObject:@(1)];
                            gaoDu = (textH + 347 - 30) / 667.0 * SCREEN_HEIGHT;
                        } else {
                            [self.hideAry addObject:@(0)];
                            gaoDu = (53 + 347) / 667.0 * SCREEN_HEIGHT;
                        }
                        [self.cellHeightAry addObject:[NSString stringWithFormat:@"%f",gaoDu]];
                    }
                }
                CoreTextData *data = [CTFrameParser parseTemplateFile:filename config:config];
                [self.ctDataAry addObject:data];
                
                NSInteger flag = [self.hideAry[i] integerValue];
                if (flag) {
                    NSAttributedString  *setString = [model.content stringWithParagraphlineSpeace:5 textColor:[UIColor colorWithHexString:@"#222222"] textFont:[UIFont systemFontOfSize:14]];
                    [self.contentStringAry addObject:setString];
                } else {
                    NSAttributedString  *setString = [model.content stringHideLastFourWithParagraphlineSpeace:5 textColor:[UIColor colorWithHexString:@"#222222"] textFont:[UIFont systemFontOfSize:14]];
                    [self.contentStringAry addObject:setString];
                }
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
        [self.view addSubview:self.myTableView];
        [self setupRefresh];
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

- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
