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
#import "Masonry.h"
#import "FSEditInformationViewController.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "FSZuoPin.h"
#import "AFNetworking.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "FSZuoPinTableViewCell.h"
#import "FSUserModel.h"
#import "SVProgressHUD.h"
#import "FSListUserModel.h"
#import "FSListUserTableViewCell.h"
#import "FSHomeDetailViewController.h"
#import "FSStuffCountTableViewCell.h"
#import "FSZuoPinGroupTableViewCell.h"
#import "FSFansModel.h"
#import "UINavigationBar+FSExtension.h"
#import "UIBarButtonItem+FSExtension.h"
#import "FSUserModel2.h"

#define NAVBAR_CHANGE_POINT 170

typedef NS_ENUM(NSInteger, FSType) {
    FSTypeZuoPin,
    FSTypeGuanZhu,
    FSTypeFenSi
};

@interface FSHomePageViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

{
    BOOL statusChangeFlag;
}

/**  */
@property (nonatomic, strong) UITableView *contentTableView;
/** 当前选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
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
/**  */
@property(nonatomic,assign) NSInteger current_page;
/**  */
@property(nonatomic,assign) NSInteger total_rows;
/**  */
@property (nonatomic, strong) CAGradientLayer *shadow;
/**  */
@property (nonatomic, strong) UIView *naviView;
/**  */
@property (nonatomic, assign) BOOL arrangementFlag;
/** 自己或别人的个人中心 */
@property (nonatomic, assign) BOOL isMyself;
/**  */
@property (nonatomic, strong) FSUserModel *user_model;
/**  */
@property (nonatomic, strong) UIButton *fucosBtn;


@end

static NSString * const zuoPinCellId = @"zuoPin";
static NSString * const fucosCellId = @"fucos";

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
    FSUserModel2 *userModel = [[FSUserModel2 findAll] lastObject];
    if ([userModel.userId isEqualToString:self.userId]) {
        self.isMyself = YES;
    } else {
        self.isMyself = NO;
    }
    // 设置导航栏
    [self setupNav];
    [self.contentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


-(UIView *)naviView{
    if (!_naviView) {
        _naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        if (self.isMyself) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(15, 26, 0, 0);
            [button setImage:[UIImage imageNamed:@"me_back"] forState:UIControlStateNormal];
            [button sizeToFit];
            [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
            [_naviView addSubview:button];
            
            UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [editBtn setImage:[UIImage imageNamed:@"me_edit"] forState:UIControlStateNormal];
            [editBtn sizeToFit];
            [editBtn addTarget:self action:@selector(editBtn) forControlEvents:UIControlEventTouchUpInside];
            [_naviView addSubview:editBtn];
            [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(_naviView.mas_right).offset(-15);
                make.top.mas_equalTo(button.mas_top).offset(0);
            }];
            
        } else {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(15, 26, 0, 0);
            [button setImage:[UIImage imageNamed:@"me_back"] forState:UIControlStateNormal];
            [button sizeToFit];
            [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
            [_naviView addSubview:button];
            
            [_naviView addSubview:self.fucosBtn];
            [_fucosBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(_naviView.mas_right).offset(-15);
                make.top.mas_equalTo(button.mas_top).offset(0);
                make.width.mas_equalTo(72);
                make.height.mas_equalTo(26);
            }];
        }
        _naviView.backgroundColor = [UIColor clearColor];
    }
    return _naviView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UIColor * color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"me_bg_large_bottom"]];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        [self.navigationController.navigationBar setShadowImage:nil];
    } else {
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}

-(UIButton *)fucosBtn{
    if (!_fucosBtn) {
        _fucosBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fucosBtn.width = 72;
        _fucosBtn.height = 26;
        _fucosBtn.layer.masksToBounds = YES;
        _fucosBtn.layer.cornerRadius = 13;
        _fucosBtn.layer.borderWidth = 1;
        _fucosBtn.layer.borderColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;
        [_fucosBtn setTitle:[NSString stringWithFormat:@"+ %@", NSLocalizedString(@"fucos", nil)] forState:UIControlStateNormal];
        [_fucosBtn setTitle:NSLocalizedString(@"focused", nil) forState:UIControlStateSelected];
        _fucosBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_fucosBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        [_fucosBtn setTitleColor:[UIColor colorWithHexString:@"#2288FF"] forState:UIControlStateSelected];
        [_fucosBtn setImage:[UIImage imageNamed:@"me_fucos_right"] forState:UIControlStateSelected];
        _fucosBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
        _fucosBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 0);
        [_fucosBtn addTarget:self action:@selector(fucosCenterClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fucosBtn;
}

#pragma mark - 导航右边关注
-(void)fucosCenterClick:(UIButton*)sender{
    if (sender.selected) {
        //取消关注
        FBRequest *request = [FBAPI deleteWithUrlString:[NSString stringWithFormat:@"/user/%@/cancelFollow",self.user_model.userId] requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            sender.selected = NO;
            sender.layer.borderColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    } else {
        //关注
        FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/user/%@/follow",self.user_model.userId] requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            sender.selected = YES;
            sender.layer.borderColor = [UIColor colorWithHexString:@"#2288FF"].CGColor;
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    }
}



#pragma mark - 设置导航条
-(void)setupNav{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    if (self.isMyself) {
        UIBarButtonItem *searchItem = [UIBarButtonItem itemWithImage:@"me_back" highImage:nil title:nil target:self action:@selector(back)];
        self.navigationItem.leftBarButtonItem = searchItem;
        
        UIBarButtonItem *quick_releaseItem = [UIBarButtonItem itemWithImage:@"me_edit" highImage:nil title:nil target:self action:@selector(editBtn)];
        self.navigationItem.rightBarButtonItem = quick_releaseItem;
    } else {
        UIBarButtonItem *searchItem = [UIBarButtonItem itemWithImage:@"me_back" highImage:nil title:nil target:self action:@selector(back)];
        self.navigationItem.leftBarButtonItem = searchItem;
        
        UIBarButtonItem *fucosItem = [[UIBarButtonItem alloc] initWithCustomView:self.fucosBtn];
        self.navigationItem.rightBarButtonItem = fucosItem;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    UIColor *color = [UIColor colorWithHexString:@"#ffffff"];
    [self.navigationController.navigationBar lt_setBackgroundColor:color];
    [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:1]];
}


#pragma mark - 懒加载顶部渐变层
-(CAGradientLayer *)shadow{
    if (!_shadow) {
        _shadow = [CAGradientLayer layer];
        _shadow.startPoint = CGPointMake(0, 2);
        _shadow.endPoint = CGPointMake(0, 0);
        _shadow.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                           (__bridge id)[UIColor blackColor].CGColor];
        _shadow.locations = @[@(0.5f), @(2.5f)];
        _shadow.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    }
    return _shadow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.type = FSTypeZuoPin;
    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.contentTableView];
    
    [self setUpRefresh];
    
    [self.view.layer addSublayer:self.shadow];
}

#pragma mark - 设置刷新
-(void)setUpRefresh{
    self.contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    // 自动改变透明度
    self.contentTableView.mj_header.automaticallyChangeAlpha = YES;
    [self.contentTableView.mj_header beginRefreshing];
    self.contentTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.contentTableView.mj_footer.hidden = YES;
}

#pragma mark - 加载更多
-(void)loadMore{
    
    [self.contentTableView.mj_header endRefreshing];
    switch (self.type) {
        case FSTypeZuoPin:
        {
            //作品网络请求
            [self zuoPinRequestMore];
        }
            break;
            
        case FSTypeGuanZhu:
        {
            //关注网络请求
            [self fucosRequsetMore];
        }
            break;
            
        case FSTypeFenSi:
        {
            //粉丝网络请求
            [self fansRequestMore];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 刷新
-(void)loadNew{
    [self.contentTableView.mj_footer endRefreshing];
    [self updateUserInfo];
    
    self.current_page = 1;
    
    switch (self.type) {
        case FSTypeZuoPin:
        {
            //作品网络请求
            [self zuoPinRequest];
        }
            break;
            
        case FSTypeGuanZhu:
        {
            //关注网络请求
            [self fucosRequset];
        }
            break;
            
        case FSTypeFenSi:
        {
            //粉丝网络请求
            [self fansRequest];
        }
            break;
            
        default:
            break;
    }
}

-(void)fucosRequsetMore{
    FBRequest *request = [FBAPI getWithUrlString:[NSString stringWithFormat:@"/user/%@/followers",self.userId] requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        self.current_page = [result[@"meta"][@"pagination"][@"current_page"] integerValue];
        self.total_rows = [result[@"meta"][@"pagination"][@"total"] integerValue];
        NSArray *dataAry = result[@"data"];
        NSArray *ary = [FSListUserModel mj_objectArrayWithKeyValuesArray:dataAry];
        [self.guanZhuPersons addObjectsFromArray:ary];
        [self.contentTableView reloadData];
        [self checkFooterState];
        [self.contentTableView.mj_header endRefreshing];
    } failure:^(FBRequest *request, NSError *error) {
        // 提醒
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Network error", nil)];
        
        // 让底部控件结束刷新
        [self.contentTableView.mj_header endRefreshing];
    }];
}

#pragma mark - 关注网络请求
-(void)fucosRequset{
    FBRequest *request = [FBAPI getWithUrlString:[NSString stringWithFormat:@"/user/%@/followers",self.userId] requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        self.current_page = [result[@"meta"][@"pagination"][@"current_page"] integerValue];
        self.total_rows = [result[@"meta"][@"pagination"][@"total"] integerValue];
        NSArray *dataAry = result[@"data"];
        self.guanZhuPersons = [FSListUserModel mj_objectArrayWithKeyValuesArray:dataAry];
        NSArray *ary = [FSListUserModel findAll];
        [FSListUserModel deleteObjects:ary];
        [FSListUserModel saveObjects:self.guanZhuPersons];
        [self.contentTableView reloadData];
        [self checkFooterState];
        [self.contentTableView.mj_header endRefreshing];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Network error", nil)];
        [self.contentTableView.mj_header endRefreshing];
        self.guanZhuPersons = (NSMutableArray*)[FSListUserModel findAll];
        [self.contentTableView reloadData];
    }];
}

-(void)fansRequestMore{
    FBRequest *request = [FBAPI getWithUrlString:[NSString stringWithFormat:@"/user/%@/fans",self.userId] requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        self.current_page = [result[@"meta"][@"pagination"][@"current_page"] integerValue];
        self.total_rows = [result[@"meta"][@"pagination"][@"total"] integerValue];
        NSArray *dataAry = result[@"data"];
        NSArray *ary = [FSFansModel mj_objectArrayWithKeyValuesArray:dataAry];
        [self.fenSiPersons addObjectsFromArray:ary];
        [self.contentTableView reloadData];
        [self checkFooterState];
        [self.contentTableView.mj_header endRefreshing];
    } failure:^(FBRequest *request, NSError *error) {
        // 提醒
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Network error", nil)];
        
        // 让底部控件结束刷新
        [self.contentTableView.mj_header endRefreshing];
    }];
}

#pragma mark - 粉丝网络请求
-(void)fansRequest{
    FBRequest *request = [FBAPI getWithUrlString:[NSString stringWithFormat:@"/user/%@/fans",self.userId] requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        self.current_page = [result[@"meta"][@"pagination"][@"current_page"] integerValue];
        self.total_rows = [result[@"meta"][@"pagination"][@"total"] integerValue];
        NSArray *dataAry = result[@"data"];
        self.fenSiPersons = [FSFansModel mj_objectArrayWithKeyValuesArray:dataAry];
        NSArray *ary = [FSFansModel findAll];
        [FSFansModel deleteObjects:ary];
        [FSFansModel saveObjects:self.fenSiPersons];
        [self.contentTableView reloadData];
        [self checkFooterState];
        [self.contentTableView.mj_header endRefreshing];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Network error", nil)];
        [self.contentTableView.mj_header endRefreshing];
        self.fenSiPersons = (NSMutableArray*)[FSFansModel findAll];
        [self.contentTableView reloadData];
    }];
}

#pragma mark - 刷新个人信息
-(void)updateUserInfo{
    if (self.isMyself) {
        FBRequest *request2 = [FBAPI getWithUrlString:@"/me/profile" requestDictionary:nil delegate:self];
        [request2 startRequestSuccess:^(FBRequest *request, id result) {
            FSUserModel2 *userModel = [[FSUserModel2 findAll] lastObject];
            NSDictionary *dict = result[@"data"];
            userModel = [FSUserModel2 mj_objectWithKeyValues:dict];
            userModel.isLogin = YES;
            self.userId = userModel.userId;
            [userModel saveOrUpdate];
            [self.contentTableView reloadData];
        } failure:^(FBRequest *request, NSError *error) {
            FSUserModel2 *userModel = [[FSUserModel2 findAll] lastObject];
            self.userId = userModel.userId;
            [self.contentTableView reloadData];
        }];
    } else {
        FBRequest *request2 = [FBAPI getWithUrlString:[NSString stringWithFormat:@"/user/%@",self.userId] requestDictionary:nil delegate:self];
        [request2 startRequestSuccess:^(FBRequest *request, id result) {
            NSDictionary *dict = result[@"data"];
            self.user_model = [FSUserModel mj_objectWithKeyValues:dict];
            self.userId = self.user_model.userId;
            self.fucosBtn.selected = self.user_model.following == 1;
            if (self.fucosBtn.selected) {
                self.fucosBtn.layer.borderColor = [UIColor colorWithHexString:@"#2288FF"].CGColor;
            } else {
                self.fucosBtn.layer.borderColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;
            }
            [self.contentTableView reloadData];
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    }
}

#pragma mark - 作品的网络请求
-(void)zuoPinRequest{
    FBRequest *request = [FBAPI getWithUrlString:@"/stuffs" requestDictionary:@{
                                                                                @"page" : @(self.current_page),
                                                                                @"per_page" : @(12),
                                                                                @"user_id" : self.userId
                                                                                } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        self.current_page = [result[@"meta"][@"pagination"][@"current_page"] integerValue];
        self.total_rows = [result[@"meta"][@"pagination"][@"total"] integerValue];
        NSArray *dataAry = result[@"data"];
        self.zuoPins = [FSZuoPin mj_objectArrayWithKeyValuesArray:dataAry];
        NSArray *ary = [FSZuoPin findAll];
        [FSZuoPin deleteObjects:ary];
        [FSZuoPin saveObjects:self.zuoPins];
        [self.contentTableView reloadData];
        [self.contentTableView.mj_header endRefreshing];
        [self checkFooterState];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Network error", nil)];
        [self.contentTableView.mj_header endRefreshing];
        self.zuoPins = (NSMutableArray*)[FSZuoPin findAll];
        [self.contentTableView reloadData];
    }];
}

#pragma mark - 作品网络请求更多
-(void)zuoPinRequestMore{
    FBRequest *request = [FBAPI getWithUrlString:@"/stuffs" requestDictionary:@{
                                                                                @"page" : @(++ self.current_page),
                                                                                @"per_page" : @(12),
                                                                                @"user_id" : self.userId
                                                                                } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        self.current_page = [result[@"meta"][@"pagination"][@"current_page"] integerValue];
        self.total_rows = [result[@"meta"][@"pagination"][@"total"] integerValue];
        NSArray *dataAry = result[@"data"];
        NSArray *ary = [FSZuoPin mj_objectArrayWithKeyValuesArray:dataAry];
        [self.zuoPins addObjectsFromArray:ary];
        [self.contentTableView reloadData];
        [self.contentTableView.mj_footer endRefreshing];
        [self checkFooterState];
    } failure:^(FBRequest *request, NSError *error) {
        // 提醒
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Network error", nil)];
        
        // 让底部控件结束刷新
        [self.contentTableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 调整头尾状态
-(void)checkFooterState{
    switch (self.type) {
        case FSTypeZuoPin:
        {
            //作品
            self.contentTableView.mj_footer.hidden = self.zuoPins.count == 0;
            if (self.zuoPins.count == self.total_rows) {
                self.contentTableView.mj_footer.hidden = YES;
            }else{
                [self.contentTableView.mj_footer endRefreshing];
            }
        }
            break;
            
        case FSTypeGuanZhu:
        {
            //关注
            self.contentTableView.mj_footer.hidden = self.guanZhuPersons.count == 0;
            if (self.guanZhuPersons.count == self.total_rows) {
                self.contentTableView.mj_footer.hidden = YES;
            }else{
                [self.contentTableView.mj_footer endRefreshing];
            }
        }
            break;
            
        case FSTypeFenSi:
        {
            //粉丝
            self.contentTableView.mj_footer.hidden = self.fenSiPersons.count == 0;
            if (self.fenSiPersons.count == self.total_rows) {
                self.contentTableView.mj_footer.hidden = YES;
            }else{
                [self.contentTableView.mj_footer endRefreshing];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 懒加载tableview
-(UITableView *)contentTableView{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] init];
        _contentTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        [_contentTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FSZuoPinTableViewCell class]) bundle:nil] forCellReuseIdentifier:zuoPinCellId];
        [_contentTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FSListUserTableViewCell class]) bundle:nil] forCellReuseIdentifier:fucosCellId];
        [_contentTableView registerNib:[UINib nibWithNibName:@"FSStuffCountTableViewCell" bundle:nil] forCellReuseIdentifier:@"FSStuffCountTableViewCell"];
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _contentTableView;
}


#pragma mark - tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        switch (self.type) {
            case FSTypeZuoPin:
            {
                //作品数量
                if (self.arrangementFlag) {
                    return 1 + 1;
                } else {
                    return self.zuoPins.count + 1;
                }
            }
                break;
                
            case FSTypeGuanZhu:
            {
                //关注数量
                return self.guanZhuPersons.count;
            }
                break;
                
            case FSTypeFenSi:
            {
                //粉丝数量
                return self.fenSiPersons.count;
            }
                break;
                
            default:
                break;
        }
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 284 / 667.0 * SCREEN_HEIGHT;
    } else if (indexPath.section == 1) {
        switch (self.type) {
            case FSTypeZuoPin:
            {
                //作品高度
                if (indexPath.row == 0) {
                    return 30;
                } else {
                    if (self.arrangementFlag) {
                        NSInteger n1 = self.zuoPins.count / 3;
                        NSInteger n2 = self.zuoPins.count % 3;
                        if (n2 > 0) {
                            n1 ++;
                        }
                        return n1 * ((SCREEN_WIDTH - 5 * 2) / 3 + 10);
                    } else {
                        return (211 + 40) / 667.0 * SCREEN_HEIGHT;
                    }
                }
            }
                break;
                
            case FSTypeGuanZhu:
            {
                //关注高度
                return 55 / 667.0 * SCREEN_HEIGHT;
            }
                break;
                
            case FSTypeFenSi:
            {
                //粉丝高度
                return 55 / 667.0 * SCREEN_HEIGHT;
            }
                break;
                
            default:
                break;
        }
    }
    return 210 + 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        NSString *cellStr1 = @"cellStr1";
        FSMeHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr1];
        if (cell == nil) {
            cell = [[FSMeHeadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr1];
        }
        FSUserModel2 *userModel = [[FSUserModel2 findAll] lastObject];
        if (self.isMyself) {
           cell.model2 = userModel;
        } else {
            cell.model = self.user_model;
        }
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
    } else if (indexPath.section == 1) {
        switch (self.type) {
            case FSTypeZuoPin:
            {
                //作品cell
                if (indexPath.row == 0) {
                    FSStuffCountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSStuffCountTableViewCell"];
                    if (self.isMyself) {
                        FSUserModel2 *userModel = [[FSUserModel2 findAll] lastObject];
                        cell.stuffCountLabel.text = [NSString stringWithFormat:@"%@%@",userModel.stuff_count, NSLocalizedString(@"works", nil)];
                    } else {
                        cell.stuffCountLabel.text = [NSString stringWithFormat:@"%@%@",self.user_model.stuff_count, NSLocalizedString(@"works", nil)];
                    }
                    [cell.arrangementBtn addTarget:self action:@selector(changeArrangment:) forControlEvents:UIControlEventTouchUpInside];
                    return cell;
                } else {
                    if (self.arrangementFlag) {
                        //组式排列
                        static NSString *cellId = @"cellOne";
                        FSZuoPinGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                        if (cell == nil) {
                            cell = [[FSZuoPinGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                        }
                        cell.groupAry = self.zuoPins;
                        cell.navc = self.navigationController;
                        return cell;
                    } else {
                        //正常排列
                        FSZuoPinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:zuoPinCellId];
                        cell.zuopin = self.zuoPins[indexPath.row - 1];
                        return cell;
                    }
                }
            }
                break;
                
            case FSTypeGuanZhu:
            {
                //关注
                FSListUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:fucosCellId];
                cell.model = self.guanZhuPersons[indexPath.row];
                cell.fucosBtn.tag = indexPath.row;
                [cell.fucosBtn addTarget:self action:@selector(fucosClick:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
                break;
                
            case FSTypeFenSi:
            {
                //粉丝
                FSListUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:fucosCellId];
                cell.fansModel = self.fenSiPersons[indexPath.row];
                cell.fucosBtn.tag = indexPath.row;
                [cell.fucosBtn addTarget:self action:@selector(fucosClick:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
                break;
                
            default:
                break;
        }
    }
    return nil;
}

#pragma mark - 改变排列方式
-(void)changeArrangment:(UIButton*)sender{
    sender.selected = !sender.selected;
    self.arrangementFlag = sender.selected;
    [self.contentTableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        switch (self.type) {
            case FSTypeZuoPin:
            {
                if (indexPath.row == 0) {
                    return;
                }
                FSHomeDetailViewController *vc = [[FSHomeDetailViewController alloc] init];
                vc.model = self.zuoPins[indexPath.row - 1];
                vc.title = NSLocalizedString(@"work details", nil);
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case FSTypeGuanZhu:
            {
                FSHomePageViewController *vc = [[FSHomePageViewController alloc] init];
                FSListUserModel *model = self.guanZhuPersons[indexPath.row];
                vc.userId = model.userId;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case FSTypeFenSi:
            {
                FSHomePageViewController *vc = [[FSHomePageViewController alloc] init];
                FSFansModel *model = self.fenSiPersons[indexPath.row];
                vc.userId = model.userId;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}


#pragma mark - 点击关注按钮
-(void)fucosClick : (UIButton *) sender {
    switch (self.type) {
        case FSTypeZuoPin:
        {
        }
            break;
        case FSTypeGuanZhu:
        {
            if (sender.selected) {
                FBRequest *request = [FBAPI deleteWithUrlString:[NSString stringWithFormat:@"/user/%@/cancelFollow",((FSListUserModel*)self.guanZhuPersons[sender.tag]).userId] requestDictionary:nil delegate:self];
                [request startRequestSuccess:^(FBRequest *request, id result) {
                    sender.selected = NO;
                    sender.layer.borderColor = [UIColor colorWithHexString:@"#7F8FA2"].CGColor;
                } failure:^(FBRequest *request, NSError *error) {
                    
                }];
            } else {
                FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/user/%@/follow",((FSListUserModel*)self.guanZhuPersons[sender.tag]).userId] requestDictionary:nil delegate:self];
                [request startRequestSuccess:^(FBRequest *request, id result) {
                    sender.selected = YES;
                    sender.layer.borderColor = [UIColor colorWithHexString:@"#2288FF"].CGColor;
                } failure:^(FBRequest *request, NSError *error) {
                    
                }];
            }
        }
            break;
        case FSTypeFenSi:
        {
            if (sender.selected) {
                FBRequest *request = [FBAPI deleteWithUrlString:[NSString stringWithFormat:@"/user/%@/cancelFollow",((FSFansModel*)self.fenSiPersons[sender.tag]).userId] requestDictionary:nil delegate:self];
                [request startRequestSuccess:^(FBRequest *request, id result) {
                    sender.selected = NO;
                    sender.layer.borderColor = [UIColor colorWithHexString:@"#7F8FA2"].CGColor;
                } failure:^(FBRequest *request, NSError *error) {
                    
                }];
            } else {
                FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/user/%@/follow",((FSFansModel*)self.fenSiPersons[sender.tag]).userId] requestDictionary:nil delegate:self];
                [request startRequestSuccess:^(FBRequest *request, id result) {
                    sender.selected = YES;
                    sender.layer.borderColor = [UIColor colorWithHexString:@"#2288FF"].CGColor;
                } failure:^(FBRequest *request, NSError *error) {
                    
                }];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 编辑
-(void)editBtn{
    FSEditInformationViewController *vc = [[FSEditInformationViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
    [self loadNew];
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
    [self loadNew];
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
    [self loadNew];
}


@end
