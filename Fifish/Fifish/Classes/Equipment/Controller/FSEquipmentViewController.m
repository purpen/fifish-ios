//
//  FSEquipmentViewController.m
//  Fifish
//
//  Created by THN-Dong on 16/7/25.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSEquipmentViewController.h"
#import "VideoLiveController.h"
#import "UIBarButtonItem+FSExtension.h"
#import "FSConst.h"
#import "UIView+FSExtension.h"
#import "Masonry.h"
#import "FSContenHelpViewController.h"
#import "FBAPI.h"
#import "AppDelegate.h"
#import "FSTipView.h"
#import "UIView+FSExtension.h"

@interface FSEquipmentViewController ()<UIScrollViewDelegate,reachableDelegate>

@property (weak, nonatomic) IBOutlet UIButton *connectionBtn;
/**  */
@property (nonatomic, strong) UIScrollView *contentScrollview;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**  */
@property (nonatomic, strong) NSArray *pictuerAry;
/**  */
@property (nonatomic, strong) UIPageControl *pagrControl;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
/**  */
@property (nonatomic, strong) FSTipView *tipView;

@end

@implementation FSEquipmentViewController


-(NSArray *)pictuerAry{
    if (!_pictuerAry) {
        _pictuerAry = [NSArray arrayWithObjects:@"eq_eqImage", nil];
    }
    return _pictuerAry;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tipView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 170);
    [self.view addSubview:self.tipView];
    
}

-(void)isReachAble{
    [FBAPI isExistenceROVwithBlock:^(BOOL isconnect) {
        if (isconnect) {
            self.statusLabel.text = @"WIFI已连接";
            [self.connectionBtn setTitle:@"已连接" forState:UIControlStateNormal];
            self.connectionBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [self.connectionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            self.connectionBtn.enabled = NO;
        } else {
            self.statusLabel.text = @"WIFI未连接";
            [self.connectionBtn setTitle:@"连接WIFI" forState:UIControlStateNormal];
            self.connectionBtn.layer.borderColor = DEFAULT_COLOR.CGColor;
            [self.connectionBtn setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
            self.connectionBtn.enabled = YES;
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.reachDelegate = self;
    
    self.navigationItem.title = @"Fifish";
    UIBarButtonItem *cancelItem = [UIBarButtonItem itemWithImage:@"eq_cancel" highImage:nil title:nil target:self action:@selector(cancelClick)];
    self.navigationItem.rightBarButtonItem = cancelItem;
    
    self.connectionBtn.layer.masksToBounds = YES;
    self.connectionBtn.layer.cornerRadius = 22;
    self.connectionBtn.layer.borderWidth = 1;
    self.connectionBtn.layer.borderColor = DEFAULT_COLOR.CGColor;
    
    [self.view addSubview:self.contentScrollview];
    [self.contentScrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10);
        make.bottom.mas_equalTo(self.connectionBtn.mas_top).offset(-40);
    }];
    
    [self setImage];
    [self.view addSubview:self.pagrControl];
    [_pagrControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(self.contentScrollview.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    if (self.pictuerAry.count == 1) {
        self.pagrControl.hidden = YES;
    } else if (self.pictuerAry.count > 1) {
        self.pagrControl.hidden = NO;
    }
}

#pragma mark - 连接帮助
- (IBAction)contenHelp:(UIButton *)sender {
    FSContenHelpViewController *vc = [[FSContenHelpViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(UIPageControl *)pagrControl{
    if (!_pagrControl) {
        _pagrControl = [[UIPageControl alloc] init];
        _pagrControl.numberOfPages = self.pictuerAry.count;
        _pagrControl.currentPage = 0;
        _pagrControl.currentPageIndicatorTintColor = DEFAULT_COLOR;
        _pagrControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#D7D7D7" alpha:1];
    }
    return _pagrControl;
}

-(void)setImage{
    for (int i = 0; i < self.pictuerAry.count; i++) {
        UIImageView  *showImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.pictuerAry[i]]];
        showImageView.x = i * SCREEN_WIDTH;
        showImageView.y = showImageView.height * 0.5;
        showImageView.width = SCREEN_WIDTH;
//        showImageView.height = self.contentScrollview.height;
        showImageView.contentMode = UIViewContentModeScaleToFill;
        [_contentScrollview addSubview:showImageView];
    }
}

-(UIScrollView *)contentScrollview{
    if (!_contentScrollview) {
        _contentScrollview = [[UIScrollView alloc] init];
        _contentScrollview.backgroundColor = [UIColor clearColor];
        _contentScrollview.delegate = self;
        _contentScrollview.contentSize = CGSizeMake(SCREEN_WIDTH * self.pictuerAry.count, 0);
        _contentScrollview.pagingEnabled = YES;
        _contentScrollview.showsVerticalScrollIndicator = NO;
        _contentScrollview.showsHorizontalScrollIndicator = NO;
        _contentScrollview.alwaysBounceVertical = NO;
        _contentScrollview.alwaysBounceHorizontal = NO;
        _contentScrollview.bounces = NO;
    }
    return _contentScrollview;
}

-(void)cancelClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = fabs(scrollView.contentOffset.x/SCREEN_WIDTH);
    _pagrControl.currentPage = index;
}

-(FSTipView *)tipView{
    if (!_tipView) {
        _tipView = [FSTipView viewFromXib];
    }
    return _tipView;
}

- (IBAction)contentROV:(UIButton *)sender {
    
    if ([self.statusLabel.text isEqualToString:@"WIFI未连接"]) {
//        [UIView animateWithDuration:0.3 animations:^{
//            self.tipView.y = SCREEN_HEIGHT - 170;
//        } completion:nil];
        VideoLiveController * videoLive = [[VideoLiveController alloc] init];
        [self presentViewController:videoLive animated:YES completion:nil];
    } else {
        //跳到设备
        
    }
    
}


@end
