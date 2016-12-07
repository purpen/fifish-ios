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
#import "WMPlayer.h"
#import "FSHistoryView.h"
#import "FSSearchModel.h"
#define ADVICE_TABLEVIEW 11

@interface FSSearchViewController () <UISearchBarDelegate, SGTopTitleViewDelegate, UITableViewDelegate, UITableViewDataSource, FSFoundStuffTableViewCellDelegate, WMPlayerDelegate, FSHomeDetailViewControllerDelegate, FSHistoryViewDelegate>
{
    WMPlayer *wmPlayer;
}
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
@property (nonatomic, strong) NSMutableArray *tagMAry;
/**  */
@property (nonatomic, strong) NSMutableArray *ctDataAry;

@property (nonatomic, strong) NSIndexPath *indexPath;
/**  */
@property (nonatomic, strong) UIView *imageView;
@property (nonatomic, assign) BOOL isSmallScreen;
/** ` */
@property (nonatomic, strong) FSHistoryView *historyView;
/**  */
@property (nonatomic, strong) NSArray *adviceAry;
/**  */
@property (nonatomic, strong) UITableView *adviceTableView;

@end

@implementation FSSearchViewController

-(UITableView *)adviceTableView{
    if (!_adviceTableView) {
        _adviceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _adviceTableView.delegate = self;
        _adviceTableView.dataSource = self;
        _adviceTableView.showsVerticalScrollIndicator = NO;
        _adviceTableView.tag = ADVICE_TABLEVIEW;
        [_adviceTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        _adviceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _adviceTableView;
}

-(FSHistoryView *)historyView{
    if (!_historyView) {
        _historyView = [[FSHistoryView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 500)];
        _historyView.hVDelegate = self;
    }
    return _historyView;
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
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.segmentedControl.y + self.segmentedControl.height + 1, SCREEN_WIDTH, SCREEN_HEIGHT - self.segmentedControl.y - self.segmentedControl.height - 1) style:UITableViewStyleGrouped];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.showsVerticalScrollIndicator = NO;
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FSFoundStuffTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"FSFoundStuffTableViewCell"];
        [_myTableView registerNib:[UINib nibWithNibName:@"FSListUserTableViewCell" bundle:nil] forCellReuseIdentifier:@"FSListUserTableViewCell"];
        _myTableView.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
        _myTableView.estimatedRowHeight = 400;
    }
    return _myTableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == ADVICE_TABLEVIEW) {
        return self.adviceAry.count;
    }
    if ([self.type isEqualToNumber:@(2)]) {
        //用户
        return self.userAry.count > 0 ? self.userAry.count : 1;
    } else if ([self.type isEqualToNumber:@(1)]) {
        return 1;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == ADVICE_TABLEVIEW) {
        return 1;
    }
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
    if (tableView.tag == ADVICE_TABLEVIEW) {
        return 0.00001f;
    }
    return 10;
}

-(void)userFcousClick:(UIButton*)sender{
    if (sender.selected) {
        FBRequest *request = [FBAPI deleteWithUrlString:[NSString stringWithFormat:@"/user/%@/cancelFollow",((FSUserModel*)self.userAry[sender.tag]).userId] requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            sender.selected = NO;
            sender.layer.borderColor = [UIColor colorWithHexString:@"#7F8FA2"].CGColor;
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    } else {
        FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/user/%@/follow",((FSUserModel*)self.userAry[sender.tag]).userId] requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            sender.selected = YES;
            sender.layer.borderColor = [UIColor colorWithHexString:@"#2288FF"].CGColor;
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == ADVICE_TABLEVIEW) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        [cell.contentView addSubview:self.lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(1));
            make.left.right.bottom.equalTo(@(0));
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *str = self.adviceAry[indexPath.row];
        cell.textLabel.text = str;
        return cell;
    }
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
                    make.top.equalTo(cell.contentView.mas_top).offset(250/667.0*SCREEN_HEIGHT);
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
                    make.top.equalTo(cell.contentView.mas_top).offset(250/667.0*SCREEN_HEIGHT);
                }];
            }
            return cell;
        }

        FSFoundStuffTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSFoundStuffTableViewCell"];
        cell.fSHomeViewDelegate = self;
        cell.navc = self.navigationController;
        //传入模型
        FSZuoPin *model = self.stuffAry[indexPath.section];
        cell.model = model;
        cell.ctData = self.ctDataAry[indexPath.section];
        cell.fucosBtn.tag = indexPath.section;
        [cell.fucosBtn addTarget:self action:@selector(fucosClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.navi = self.navigationController;
        cell.commendBtn.tag = indexPath.section;
        [cell.commendBtn addTarget:self action:@selector(commendClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.moreBtn.tag = indexPath.section;
        [cell.moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.pictuerView.tapBTn.tag = indexPath.section;
        [cell.pictuerView.tapBTn addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == ADVICE_TABLEVIEW) {
        NSString *str = self.adviceAry[indexPath.row];
        self.searchBar.text = str;
        [self searchBarSearchButtonClicked:self.searchBar];
        return;
    }
    if ([self.type isEqualToNumber:@(2)]) {
        FSHomePageViewController *vc = [[FSHomePageViewController alloc] init];
        FSUserModel *model = self.userAry[indexPath.row];
        vc.userId = model.userId;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        FSHomeDetailViewController *vc = [[FSHomeDetailViewController alloc] init];
        vc.homeDetailDelegate = self;
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
    vc.model = model;
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - 评论按钮
-(void)commendClick: (UIButton *) sender{
    FSHomeDetailViewController *vc = [[FSHomeDetailViewController alloc] init];
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
    FSFoundStuffTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:n]];
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
            FSFoundStuffTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:n]];
            cell.model.is_follow = senderState ? 1 : 0;
            cell.likeBtn.selected = senderState;
            cell.model.idFeild = idFiled;
        }
    }
    [self.myTableView reloadData];
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


- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.type = @(1);
    self.tid = @(2);
    [self.searchBar performSelector:@selector(becomeFirstResponder) withObject:self afterDelay:0.5];
    [self.view addSubview:self.historyView];
}


-(void)setupRefresh{
//    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    [self loadNew];
    // 自动改变透明度
//    self.myTableView.mj_header.automaticallyChangeAlpha = YES;
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.myTableView.mj_footer.hidden = YES;
}

-(void)parsing{
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
                                           @"content" : [NSString stringWithFormat:@"#%@ ",dict[@"name"]],
                                           @"url" : @"hh",
                                           @"type" : @"link"
                                           };
                [self.tagMAry addObject:cellDict];
            }
            config.width = SCREEN_WIDTH;
            [self.tagMAry writeToFile:filename atomically:YES];
        }
        CoreTextData *data = [CTFrameParser parseTemplateFile:filename config:config];
        [self.ctDataAry addObject:data];
    }
}


-(void)loadNew{
    if (self.searchBar.text.length == 0) return;
    [SVProgressHUD show];
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
        [SVProgressHUD dismiss];
        self.current_page = [result[@"meta"][@"pagination"][@"current_page"] integerValue];
        self.total = [result[@"meta"][@"pagination"][@"total"] integerValue];
       
        NSArray *dataAry = result[@"data"];
        
        if ([self.type isEqualToNumber:@(2)]) {
            //用户
            NSLog(@"用户 %@", result);
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
        [SVProgressHUD dismiss];
    }];
}

-(void)loadMore{
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

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.historyView.hidden = searchBar.text.length != 0;
    if (searchBar.text.length == 0) {
        [self.view bringSubviewToFront:self.historyView];
        return;
    }
    FBRequest *request = [FBAPI getWithUrlString:@"/search/expanded" requestDictionary:@{
                                                                                         @"q" : searchBar.text,
                                                                                         @"size" : @(5)
                                                                                         } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        [self.view addSubview:self.adviceTableView];
        NSDictionary *dataDict = result[@"data"];
        self.adviceAry = dataDict[@"swords"];
        [self.adviceTableView reloadData];
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (searchBar.text.length != 0) {
        [self.view addSubview:self.segmentedControl];
        [self.view addSubview:self.lineView];
        [self.view endEditing:YES];
        [self.view addSubview:self.myTableView];
        [self setupRefresh];
        //进行网络请求
        [self loadNew];
        FSSearchModel *model = [[FSSearchModel alloc] init];
        model.keyStr = searchBar.text;
        NSArray *ary = [FSSearchModel findAll];
        for (FSSearchModel *kModel in ary) {
            if ([kModel.keyStr isEqualToString:model.keyStr]) return;
        }
        if (ary.count >= 10) {
            FSSearchModel *deleteModel = ary[0];
            [deleteModel deleteObject];
        }
        [model save];
    }
}

-(void)beginSearch:(NSString *)keyStr{
    self.searchBar.text = keyStr;
    [self searchBarSearchButtonClicked:self.searchBar];
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
    [self loadNew];
}

- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)homeTableViewCell:(FSFoundStuffTableViewCell *)cell didClickVideoWithVideoUrl:(NSString *)videoUrl videoCover:(FSHomeVideoView *)baseImageView{
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
