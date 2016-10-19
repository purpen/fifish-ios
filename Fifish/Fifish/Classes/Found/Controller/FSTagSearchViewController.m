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
#import "FSFoundStuffTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "FSTagSearchCollectionViewCell.h"
#import "FSZuoPin.h"

@interface FSTagSearchViewController ()<SGTopTitleViewDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *defaultImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
/**
 1、最新
 2、最热
 3、用户
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
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
/**  */
@property (nonatomic, strong) NSArray *tagAry;
/**  */
@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
/**  */
@property(nonatomic,copy) NSString *tid;
/**  */
@property (nonatomic, strong) NSMutableArray *pictureAry;

@end

@implementation FSTagSearchViewController

-(NSMutableArray *)pictureAry{
    if (!_pictureAry) {
        _pictureAry = [NSMutableArray array];
    }
    return _pictureAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"tag", nil);
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.headImageUrl] placeholderImage:[UIImage imageNamed:@""]];
    self.tagLabel.text = [NSString stringWithFormat:@"# %@",self.placeString];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 5;
    self.shadowView.layer.masksToBounds = YES;
    self.shadowView.layer.cornerRadius = 5;
    self.type = @(1);
    [self.view addSubview:self.myCollectionView];
    [self tagRequest];
    [self.view addSubview:self.myTableView];
    [self setupRefresh];
}

-(void)tagRequest{
    NSString *encodedString = [[NSString stringWithFormat:@"/tags/%@",self.placeString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    FBRequest *request = [FBAPI getWithUrlString:encodedString requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        self.countLabel.text = [NSString stringWithFormat:@"使用次数:%@",result[@"data"][@"total_count"]];
        self.tagAry = result[@"data"][@"related_words"];
        [self.myCollectionView reloadData];
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

-(UICollectionView *)myCollectionView{
    if (!_myCollectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 10);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 190, SCREEN_WIDTH, 22) collectionViewLayout:flowLayout];
        _myCollectionView.backgroundColor = [UIColor clearColor];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.showsHorizontalScrollIndicator = NO;
        [_myCollectionView registerNib:[UINib nibWithNibName:@"FSTagSearchCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FSTagSearchCollectionViewCell"];
    }
    return _myCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.tagAry.count > 0) {
        return self.tagAry.count;
    }
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = self.tagAry[indexPath.row];
    // 文字的最大尺寸
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width , MAXFLOAT);
    // 计算文字的高度
    CGFloat textW = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.width;
    return CGSizeMake(textW + 20, 22);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FSTagSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FSTagSearchCollectionViewCell" forIndexPath:indexPath];
    NSString *str = self.tagAry[indexPath.row];
    cell.tagText = str;
    return cell;
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
                                                                                     @"str" : self.placeString,
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
//        self.myTableView.mj_footer.hidden = self.userAry.count == 0;
//        if (self.userAry.count == self.total) {
//            self.myTableView.mj_footer.hidden = YES;
//        }else{
//            [self.myTableView.mj_footer endRefreshing];
//        }
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
//        self.myTableView.mj_footer.hidden = self.videoAry.count == 0;
//        if (self.videoAry.count == self.total) {
//            self.myTableView.mj_footer.hidden = YES;
//        }else{
//            [self.myTableView.mj_footer endRefreshing];
//        }
    }
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

-(SGTopTitleView *)segmentedControl{
    if (!_segmentedControl) {
        _segmentedControl = [[SGTopTitleView alloc] initWithFrame:CGRectMake(0, self.defaultImageView.height + self.defaultImageView.y, SCREEN_WIDTH, 44)];
        _segmentedControl.staticTitleArr = @[NSLocalizedString(@"video", nil), NSLocalizedString(@"hottest", nil), NSLocalizedString(@"picture", nil)];
        _segmentedControl.backgroundColor = [UIColor whiteColor];
        _segmentedControl.delegate_SG = self;
    }
    return _segmentedControl;
}

#pragma mark - - - SGTopScrollMenu代理方法
- (void)SGTopTitleView:(SGTopTitleView *)topTitleView didSelectTitleAtIndex:(NSInteger)index {
    self.type = [NSNumber numberWithInteger:index];
    //进行网络请求
    [self.myTableView.mj_header beginRefreshing];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.tid isEqualToString:@"0"]) {
        //用户
//        return self.userAry.count;
    } else if ([self.tid isEqualToString:@"1"]) {
        //图片
        return self.pictureAry.count;
    } else if ([self.tid isEqualToString:@"2"]) {
        //视频
//        return self.videoAry.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.tid isEqualToString:@"0"]) {
        //用户
//        static NSString *userCell = @"userCell";
//        FSListUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userCell];
//        if (cell == nil) {
//            cell = [[FSListUserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userCell];
//        }
//        //传入模型
//        return cell;
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


@end
