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

@interface FSHomePageViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

/**  */
@property (nonatomic, strong) UITableView *contentTableView;
/**  */
@property (nonatomic, strong) UIScrollView *contentScrollview;

@end

static NSString * const FSMeHeadCellId = @"topic";
static NSString * const CellId = @"topic";

@implementation FSHomePageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 初始化子控制器
    [self setupChildVces];
    
    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.contentTableView];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
//    
//    [_contentTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FSMeHeadTableViewCell class]) bundle:nil] forCellReuseIdentifier:FSMeHeadCellId];
}

/**
 * 初始化子控制器
 */
- (void)setupChildVces
{
    UITableViewController *all = [[UITableViewController alloc] init];
    all.title = @"全部";
//    all.type = XMGTopicTypeAll;
    [self addChildViewController:all];
    
    UITableViewController *video = [[UITableViewController alloc] init];
    video.title = @"视频";
//    video.type = XMGTopicTypeVideo;
    [self addChildViewController:video];
    
    UITableViewController *voice = [[UITableViewController alloc] init];
    voice.title = @"声音";
//    voice.type = XMGTopicTypeVoice;
    [self addChildViewController:voice];
}

-(UITableView *)contentTableView{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] init];
        _contentTableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    }
    return _contentTableView;
}

-(UIScrollView *)contentScrollview{
    if (!_contentScrollview) {
        _contentScrollview = [[UIScrollView alloc] init];
        UITableViewCell *cell = [self.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        _contentScrollview.frame = cell.contentView.bounds;
        _contentScrollview.delegate = self;
        _contentScrollview.pagingEnabled = YES;
        _contentScrollview.contentSize = CGSizeMake(_contentScrollview.width * self.childViewControllers.count, 0);
        // 添加第一个控制器的view
        [self scrollViewDidEndScrollingAnimation:_contentScrollview];
    }
    return _contentScrollview;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        FSMeHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FSMeHeadCellId];
        if (cell == nil) {
            cell = [[FSMeHeadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FSMeHeadCellId];
        }
        cell.backgroundColor = [UIColor redColor];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
        }
        cell.backgroundColor = [UIColor yellowColor];
        [cell.contentView addSubview:self.contentScrollview];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 250;
    }else{
        return 250;
    }
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    // 取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0; // 设置控制器view的y值为0(默认是20)
    vc.view.height = scrollView.height; // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
    [scrollView addSubview:vc.view];
}

@end
