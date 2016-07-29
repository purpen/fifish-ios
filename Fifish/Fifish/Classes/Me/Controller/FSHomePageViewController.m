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
#import "FSZuoPinTableViewController.h"
#import "FSGuanZhuTableViewController.h"
#import "FSFenSiTableViewController.h"
#import "Masonry.h"
#import "FSEditInformationViewController.h"

@interface FSHomePageViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

/**  */
@property (nonatomic, strong) UITableView *contentTableView;
/**  */
@property (nonatomic, strong) UIScrollView *contentScrollview;
/** 当前选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;

@end


@implementation FSHomePageViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 设置导航栏
    [self setupNav];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.contentTableView];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    
    
    [self setChanelView];
    
}

-(void)setChanelView{
    FSZuoPinTableViewController *zuoPin = [[FSZuoPinTableViewController alloc] init];
    zuoPin.view.backgroundColor = [UIColor redColor];
    zuoPin.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 500);
    [self.contentScrollview addSubview:zuoPin.view];
    
    FSGuanZhuTableViewController *guanZhu = [[FSGuanZhuTableViewController alloc] init];
    guanZhu.view.backgroundColor = [UIColor yellowColor];
    guanZhu.view.frame = CGRectMake(1*SCREEN_WIDTH, 0, SCREEN_WIDTH, 500);
    [self.contentScrollview addSubview:guanZhu.view];
    
    FSFenSiTableViewController *fenSi = [[FSFenSiTableViewController alloc] init];
    fenSi.view.backgroundColor = [UIColor greenColor];
    fenSi.view.frame = CGRectMake(2*SCREEN_WIDTH, 0, SCREEN_WIDTH, 500);
    [self.contentScrollview addSubview:fenSi.view];
}

-(void)setupNav{
    self.navigationController.navigationBarHidden = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, 26, 0, 0);
    [button setImage:[UIImage imageNamed:@"me_back"] forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setImage:[UIImage imageNamed:@"me_edit"] forState:UIControlStateNormal];
    [editBtn sizeToFit];
    [editBtn addTarget:self action:@selector(editBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editBtn];
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.top.mas_equalTo(button.mas_top).offset(0);
    }];
}

-(void)editBtn{
    FSEditInformationViewController *vc = [[FSEditInformationViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}



-(UITableView *)contentTableView{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] init];
        _contentTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    }
    return _contentTableView;
}

-(UIScrollView *)contentScrollview{
    if (!_contentScrollview) {
        _contentScrollview = [[UIScrollView alloc] init];
        _contentScrollview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 500);
        _contentScrollview.delegate = self;
        _contentScrollview.pagingEnabled = YES;
        _contentScrollview.bounces = NO;
        _contentScrollview.contentSize = CGSizeMake(_contentScrollview.width * 3, 0);
    }
    return _contentScrollview;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        FSMeHeadTableViewCell *cell = [[FSMeHeadTableViewCell alloc] init];
        cell.backgroundColor = [UIColor redColor];
        cell.zuoPinLabel.textColor = DEFAULT_COLOR;
        cell.zuoPinShu.textColor = DEFAULT_COLOR;
        [cell.zuoPinBtn addTarget:self action:@selector(zuoPinBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.guanZhuBtn addTarget:self action:@selector(guanZhuBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell.fenSiBtn addTarget:self action:@selector(fenSiBtn:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell.contentView addSubview:self.contentScrollview];
        return cell;
    }
}

-(void)zuoPinBtn:(UIButton*)sender{
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
    // 滚动
    CGPoint offset = _contentScrollview.contentOffset;
    offset.x = 0 * self.contentScrollview.width;
    [self.contentScrollview setContentOffset:offset animated:YES];
}

-(void)guanZhuBtn:(UIButton*)sender{
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
    // 滚动
    CGPoint offset = _contentScrollview.contentOffset;
    offset.x = 1 * self.contentScrollview.width;
    [self.contentScrollview setContentOffset:offset animated:YES];
}

-(void)fenSiBtn:(UIButton*)sender{
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
    // 滚动
    CGPoint offset = _contentScrollview.contentOffset;
    offset.x = 2 * self.contentScrollview.width;
    [self.contentScrollview setContentOffset:offset animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 250;
    }else{
        return 500;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.contentScrollview]) {
        // 点击按钮
        NSInteger index = scrollView.contentOffset.x / scrollView.width;
        FSMeHeadTableViewCell *cell = [_contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (index == 0) {
            [self zuoPinBtn:cell.zuoPinBtn];
        }else if (index == 1){
            [self guanZhuBtn:cell.guanZhuBtn];
        }else if (index == 2){
            [self fenSiBtn:cell.fenSiBtn];
        }
    }
}

@end
